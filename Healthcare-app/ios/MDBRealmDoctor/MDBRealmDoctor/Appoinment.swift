//
//  Appoinment.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 02/05/22.
//

import Foundation
import RealmSwift

class Appointment: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
       @Persisted var end: Date?
       @Persisted var identifier: String?
       @Persisted var nurseIdentifier: String?
       @Persisted var participant: List<Appointment_Participant>
       @Persisted var patientIdentifier: String?
       @Persisted var patientInstruction: String?
       @Persisted var practitionerIdentifier: String?
       @Persisted var reasonReference: Reference?
       @Persisted var slot: Int?
       @Persisted var start: Date?
       @Persisted var status: String?
    
//    override init() {}
//
//    convenience init(id: ObjectId,
//                     end: Date?,
//                     identifier: String?,
//                     participant: List<Appointment_Participant>,patientInstruction: String?,reasonReference: Reference?,slot: Int?,start: Date?,status: String?) {
//        self.init()
//
//        self._id                = id
//        self.end                = end
//        self.identifier         = identifier
//        self.participant        = participant
//        self.patientInstruction = patientInstruction
//        self.reasonReference    = reasonReference
//        self.slot               = slot
//        self.start              = start
//        self.status             = status
//    }
}

class Appointment_Participant: EmbeddedObject {
    @Persisted var actor: Reference?

    @Persisted var required: Bool?

    @Persisted var status: String?
    
    override init() {}
    
    convenience init(actor: Reference?, required: Bool?, status: String?) {
        self.init()
        
        self.actor      = actor
        self.required   = required
        self.status     = status
    }
}
