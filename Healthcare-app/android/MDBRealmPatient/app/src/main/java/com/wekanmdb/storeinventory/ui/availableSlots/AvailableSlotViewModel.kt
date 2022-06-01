package com.wekanmdb.storeinventory.ui.availableSlots

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.appoinment.Appointment
import com.wekanmdb.storeinventory.model.condition.Condition
import com.wekanmdb.storeinventory.model.embededclass.*
import com.wekanmdb.storeinventory.model.encounter.Encounter
import com.wekanmdb.storeinventory.model.patient.Patient
import com.wekanmdb.storeinventory.model.procedure.Procedure
import com.wekanmdb.storeinventory.ui.consultation.ConsultationActivity
import com.wekanmdb.storeinventory.ui.hospital.HospitalActivity
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import java.util.*
import javax.inject.Inject

class AvailableSlotViewModel @Inject constructor() : BaseViewModel<AvailableSlotNavigator>() {
    private var timeSlots: MutableList<Long> = ArrayList()

    val appointmentResponseBody = MutableLiveData<MutableList<Long>?>()
    val concernResponseBody = MutableLiveData<RealmResults<Condition>?>()
    private lateinit var bookAppointment: Appointment
    private lateinit var encounter: Encounter
    private lateinit var procedure: Procedure
    private lateinit var encounterParti: Encounter_Participant
    val id = user?.customData?.get("referenceId") as ObjectId

    //Submitting the appointment for the particular patient
    fun submitAppointmentData(
        name: String,
        start: Date?,
        end: Date?,
        slot: Long?,
        notes: String?,
        doctorId: ObjectId?,
        doctorIdentifier: String?,
        conditionId: ObjectId?
    ): MutableLiveData<Boolean> {
        val responseBoolean = MutableLiveData<Boolean>()
        val patient = apprealm?.where<Patient>()?.equalTo("_id", id)?.findFirst()
        val response = MutableLiveData<Boolean>()
        apprealm?.executeTransaction {
            bookAppointment = Appointment()
            encounter = Encounter()
            procedure = Procedure()
            encounterParti = Encounter_Participant()

            //Appointment data
            val appointmentParticipant1 = Appointment_Participant(
                Reference(type = "Relative", identifier = id, reference = "Patient"),
                required = true, status = "accepted"
            )
            val appointmentParticipant2 = Appointment_Participant(
                Reference(
                    type = "Relative",
                    identifier = doctorId,
                    reference = "Practitioner/Doctor"
                ),
                required = true, status = "accepted"
            )
            bookAppointment.patientIdentifier=patient?.identifier
            bookAppointment.practitionerIdentifier=doctorIdentifier
            bookAppointment.identifier = UUID.randomUUID().toString()
            bookAppointment.status = "Booked"
            bookAppointment.reasonReference =
                Reference(type = "Relative", identifier = conditionId, reference = "Condition")
            bookAppointment.start = start
            bookAppointment.end = end
            bookAppointment.slot = slot
            bookAppointment.patientInstruction = notes
            bookAppointment.participant.add(appointmentParticipant1)
            bookAppointment.participant.add(appointmentParticipant2)
            it.insertOrUpdate(bookAppointment)
        }
        val appointment =
            apprealm?.where<Appointment>()?.equalTo("_id", bookAppointment._id)?.findFirst()
        ConsultationActivity.AppointmentId = appointment?._id
        apprealm?.executeTransaction {
            //Encouter Data
            encounter.practitionerIdentifier=doctorIdentifier
            encounter.subjectIdentifier=patient?.identifier
            encounter.identifier = UUID.randomUUID().toString()
            encounter.status = "Planned"
            encounter.reasonReference =
                Reference(type = "Relative", identifier = conditionId, reference = "Condition")
            encounter.subject = patient
            encounter.appointment = appointment
            encounter.serviceProvider = Reference(
                type = "Relative",
                identifier = HospitalActivity.hospitalID,
                reference = "Organization"
            )
            encounter.diagnosis?.use?.coding?.add(
                Coding(
                    system = "http://terminology.hl7.org/CodeSystem/diagnosis-role",
                    code = "post-op",
                    display = "post-op diagnosis"
                )
            )
            encounter.diagnosis?.use?.text = "post-op diagnosis"
            encounter.diagnosis = Diagnosis(
                condition = Reference(
                    type = "Relative",
                    identifier = procedure._id,
                    reference = "Procedure"
                ),
                rank = 1
            )
            encounterParti.type?.coding?.add(
                Coding(
                    system = "http://snomed.info/sct",
                    code = "doctor",
                    display = "Doctor"
                )
            )
            encounterParti.type?.text = "Doctor"
            encounter.participant.add(
                Encounter_Participant(
                    individual = Reference(
                        type = "Relative",
                        identifier = doctorId,
                        reference = "Practitioner/Doctor"
                    ),
                    type = encounterParti.type
                )
            )
            it.insertOrUpdate(encounter)

        }
        val encounter = apprealm?.where<Encounter>()?.equalTo("_id", encounter._id)?.findFirst()
        apprealm?.executeTransaction {
            //Procedure
            procedure.identifier = UUID.randomUUID().toString()
            procedure.status = "preparation"
            procedure.subject = patient
            procedure.encounter = encounter
            procedure.patientIdentifier=patient?.identifier
            procedure.practitionerIdentifier=doctorIdentifier
            it.insertOrUpdate(procedure)
            response.postValue(true)
        }
        responseBoolean.postValue(true)

        return responseBoolean
    }

    //getting list of condition illness
    fun getConditionData() {
        val response = MutableLiveData<Boolean>()
        val consultationList =
            apprealm?.where<Condition>()?.equalTo("subject.identifier", id)?.findAll()
        if (consultationList!!.isNotEmpty()) {
            concernResponseBody.postValue(consultationList)
        } else {
            concernResponseBody.value = consultationList
        }
    }

    //Getting all time slot data for the practitioner based on passing doctor ID
    fun getAppointmentTimeSlotData(id: ObjectId) {
        AvailableSlotActivity.timeslotsBookedList= arrayListOf()
        val appointmentList = apprealm?.where<Appointment>()?.findAll()
        appointmentList?.forEach {
            if (it.participant[1]?.actor?.identifier?.equals(id) == true) {
                timeSlots.add(it.slot!!)
                AvailableSlotActivity.timeslotsBookedList.add(it.slot!!)
            }
        }
        if (appointmentList!!.isNotEmpty()) {
            appointmentResponseBody.postValue(timeSlots)
        } else {
            appointmentResponseBody.value = timeSlots
        }
    }

}