//
//  Appointment.swift
//  MDBRealmPatient
//
//  Created by Mackbook on 07/05/22.
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
}
class Appointment_Participant: EmbeddedObject {
    @Persisted var actor: Reference?
    @Persisted var required: Bool?
    @Persisted var status: String?
}
