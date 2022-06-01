//
//  BookingSlotViewModel.swift
//  MDBRealmPatient
//
//  Created by Mackbook on 07/05/22.
//

import Foundation
import RealmSwift

class BookingSlotViewModel: NSObject {
    
    var timeSlotObjects     : [Schedule]    = []
    var timeSlotFilterObjects : [Schedule]    = []
    var available           : [Int]         = [5, 10, 15, 20, 25, 30]
    var practitionerRole    : PractitionerRole?
    var conditionOption     : Condition?
    var selectedTimeSlot    = Schedule()
    var selectedDate            = Date()
    var selectedDateString            = ""
    var selectedFilterDateString      = Date()
    var appoitnments: Results<Appointment>?
    var is24Hour: Bool = false
    
    // Schema Submit Objects
    var appointmentSchema = Appointment()
    var encounterSchema = Encounter()
    var procedureSchema = Procedure()
    var getProcedureId: ObjectId!
    
    func chechAvailableSlot(slotId: Int) -> Bool  {
        if available.contains(slotId) {
            return false
        }
        return true
    }
    func setSlotObjects() {
        is24Hour = dateFormatIs24Hour()
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = MMMddyyyyDateFormat(twentyFourHour: is24Hour)
        
        var startDate = "05:00 AM"
        var endDate = "09:00 PM"
        if is24Hour {
            startDate = "05:00"
            endDate = "21:00"
        }
        
        let date1 = inputDateFormatter.date(from: startDate)
        let date2 = inputDateFormatter.date(from: endDate)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "hh:mm a"

        var i = 1
        var time = startDate
        time = is24Hour ? "\(time) AM" : time
        while true {
            let date = date1?.addingTimeInterval(TimeInterval(i*30*60))
            let string = formatter.string(from: date!)
            if date! > date2! {
                break;
            }
            var scheduleObject = Schedule()
            scheduleObject.timeslotId = i
            scheduleObject.isAvailable = chechAvailableSlot(slotId: scheduleObject.timeslotId)
            scheduleObject.endTime = string
            scheduleObject.startTime = time
            if time.range(of: "AM") != nil {
                scheduleObject.timeSpecifigation = "Morning"
            } else {
                let filterString = ["12:00 PM","12:30 PM","01:00 PM","01:30 PM","02:00 PM" ,"02:30 PM","03:00 PM","03:30 PM"]
                let filterTimeObject = filterString.filter{ $0 == time }
                if filterTimeObject.isEmpty {
                    scheduleObject.timeSpecifigation = "Evening"
                } else {
                    scheduleObject.timeSpecifigation = "Afternoon"
                }
            }
            timeSlotObjects.append(scheduleObject)
            i += 1
            time = string
        }
    }
    func updateAppointmentData() {
        
        self.getProcedureId = self.procedureSchema._id

        let reference = Reference()
        reference.identifier = RealmManager.shared.getPatientId()
        reference.reference = "Patient"
        reference.type = "Relative"
        
        let referenceByDoctor = Reference()
        referenceByDoctor.identifier = self.practitionerRole?.practitioner?._id
        referenceByDoctor.reference = "Practitioner/Doctor"
        referenceByDoctor.type = "Relative"
        
        let appointmentParticipantUser = Appointment_Participant()
        appointmentParticipantUser.actor = reference
        appointmentParticipantUser.required = true
        appointmentParticipantUser.status = "accepted"
        
        let appointmentParticipantDoctor = Appointment_Participant()
        appointmentParticipantDoctor.actor = referenceByDoctor
        appointmentParticipantDoctor.required = true
        appointmentParticipantDoctor.status = "accepted"
        
        
        let participant =  List<Appointment_Participant>()
        participant.append(appointmentParticipantUser)
        participant.append(appointmentParticipantDoctor)
        
        let appointment = Appointment()
        appointment._id = ObjectId.generate()
        appointment.reasonReference = self.getConditionObject()
        appointment.slot = selectedTimeSlot.timeslotId
        appointment.identifier = getUniverselId()
        appointment.status = "booked"
        appointment.participant = participant
        appointment.patientInstruction = conditionOption?.notes
        appointment.start = self.appendDateAndTime(section: "Start")
        appointment.end = self.appendDateAndTime(section: "End")
        appointment.patientIdentifier = RealmManager.shared.getPatientIdentifier()
        appointment.practitionerIdentifier = self.practitionerRole?.practitioner?.identifier
        
        self.appointmentSchema = appointment
        
    }
    func updateEncounterData() {
        // Reference
        let referenceByDoctor = Reference()
        referenceByDoctor.identifier = self.practitionerRole?.practitioner?._id
        referenceByDoctor.reference = "Practitioner/Doctor"
        referenceByDoctor.type = "Relative"
        
        // Codable_Concept
        let coding = Coding()
        coding.code = "doctor"
        coding.system = "http://snomed.info/sct"
        coding.display = "Doctor"
        
        let codingList = List<Coding>()
        codingList.append(coding)
        
        let codableConcept = Codable_Concept()
        codableConcept.coding = codingList
        codableConcept.text = "Doctor"
        
        // Encounter_Participant
        let encounterParticipant = Encounter_Participant()
        encounterParticipant.individual = referenceByDoctor
        encounterParticipant.type = codableConcept
        
        let participant = List<Encounter_Participant>()
        participant.append(encounterParticipant)
        
        // Organization
        let serviceProvider = Reference()
        serviceProvider.identifier = self.practitionerRole?.organization?._id
        serviceProvider.type = "Relative"
        serviceProvider.reference = "Organization"
        
        // encounter
        let encounter = Encounter()
        encounter._id = ObjectId.generate()
        encounter.appointment = self.appointmentSchema
        encounter.identifier = getUniverselId()
        encounter.status = "planned"
        encounter.reasonReference = self.getConditionObject()
        encounter.subject = RealmManager.shared.getPatientObject()
        encounter.participant = participant
        encounter.serviceProvider = serviceProvider
        encounter.diagnosis = getDiagnosisObject()
        encounter.practitionerIdentifier = self.practitionerRole?.practitioner?.identifier
        encounter.subjectIdentifier = RealmManager.shared.getPatientIdentifier()
    print(encounter)
        self.encounterSchema = encounter
    }
    func updateProcedureData() {

        let procedure = Procedure()
        procedure._id = self.getProcedureId
        procedure.identifier = getUniverselId()
        procedure.status = "preparation"
        procedure.subject = RealmManager.shared.getPatientObject()
        procedure.encounter = self.encounterSchema
        procedure.practitionerIdentifier = self.practitionerRole?.practitioner?.identifier
        procedure.patientIdentifier = RealmManager.shared.getPatientIdentifier()
        self.procedureSchema =  procedure
    }
    func getConditionObject() -> Reference {
        // Condition
        let conditionProvider = Reference()
        conditionProvider.identifier = self.conditionOption?._id
        conditionProvider.type = "Relative"
        conditionProvider.reference = "Condition"
        return conditionProvider
    }
    func getDiagnosisObject() -> Diagnosis {
        
        let conditionProvider = Reference()
        conditionProvider.identifier = self.getProcedureId
        conditionProvider.type = "Relative"
        conditionProvider.reference = "Procedure"
        
        let coding = Coding()
        coding.code = "post-op"
        coding.system = "http://terminology.hl7.org/CodeSystem/diagnosis-role"
        coding.display = "post-op diagnosis"
        
        let codingList = List<Coding>()
        codingList.append(coding)
        
        
        let codableConcept = Codable_Concept()
        codableConcept.text = "post-op diagnosis"
        codableConcept.coding = codingList
        
        // Diagnosis
        let aiagnosis = Diagnosis()
        aiagnosis.condition = conditionProvider
        aiagnosis.rank = 1
        aiagnosis.use = codableConcept
        
        return aiagnosis
    }
    func getUniverselId() -> String {
        return "\(UUID().uuidString )"
    }
    /// createCondition API call
    /// - Parameters:
    ///   - completionHandler: completionHandler with success and error
    func createCondition(onSuccess success: @escaping OnSuccess,
               onFailure failure: @escaping OnFailure) {
        validateForm { taskSuccess in
            self.updateAppointmentData()
            self.updateEncounterData()
            self.updateProcedureData()
            RealmManager.shared.createBooking(appointment: appointmentSchema, encounter: encounterSchema, procedure: procedureSchema, success: { completed in
                success(completed)
            })
        } failure: { error in
            failure(error)
        }
    }
    /// Validates the login form
    func validateForm(success onTaskSuccess: OnTaskSuccess, failure onFailure: @escaping OnFailure) {
        
        
        if self.selectedDateString == "" {
            onFailure(FieldValidation.kBookingDate)
            return
        }
        if selectedTimeSlot.timeslotId == 0 {
            onFailure(FieldValidation.kBookingTime)
            return
        }
        if self.conditionOption == nil {
            onFailure(FieldValidation.kBookingConcern)
            return
        }
        
        onTaskSuccess(true)
    }
    func filterBySpecifigationTime(timeSpecifigation: String) {
        let filterTimeObject = self.timeSlotObjects.filter{ $0.timeSpecifigation == timeSpecifigation }
        self.timeSlotFilterObjects = filterTimeObject
    }
    func appendDateAndTime(section: String) -> Date {
        var combainedDateAndTime = ""
        if section == "Start" {
            combainedDateAndTime = "\(self.selectedDateString) \(self.selectedTimeSlot.startTime)"
        } else if section == "End"{
            combainedDateAndTime = "\(self.selectedDateString) \(self.selectedTimeSlot.endTime)"
        }
        self.selectedDate = combainedDateAndTime.getDateFromString()
        return self.selectedDate
    }
    func dateFormatIs24Hour() -> Bool {
        guard let dateFormat = DateFormatter.dateFormat (fromTemplate: "j",
                                                         options:0,
                                                         locale: Locale.current) else {
            return false
        }
        return !dateFormat.contains("a")
    }
    func MMMddyyyyDateFormat(twentyFourHour: Bool) -> String {
        let hourFormat = is24Hour ? "HH" : "hh"
        let amOrPmSuffix = is24Hour ? "" : "a"
        let  dateFormat = "\(hourFormat):mm \(amOrPmSuffix)"
        return dateFormat
    }
}
struct Schedule {
    var timeslotId: Int = 0
    var isAvailable: Bool = true
    var startTime: String = ""
    var endTime: String = ""
    var timeSpecifigation: String = ""
}

