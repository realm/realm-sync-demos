//
//  Encounter.swift
//  MDBRealmPatient
//
//  Created by Mackbook on 07/05/22.
//

import Foundation
import RealmSwift

class Encounter: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var appointment: Appointment?
    @Persisted var diagnosis: Diagnosis?
    @Persisted var identifier: String?
    @Persisted var nurseIdentifier: String?
    @Persisted var participant: List<Encounter_Participant>
    @Persisted var practitionerIdentifier: String?
    @Persisted var reasonReference: Reference?
    @Persisted var serviceProvider: Reference?
    @Persisted var status: String?
    @Persisted var subject: Patient?
    @Persisted var subjectIdentifier: String?
}
class Diagnosis: EmbeddedObject {
    @Persisted var condition: Reference?
    @Persisted var rank: Int?
    @Persisted var use: Codable_Concept?
}
class Encounter_Participant: EmbeddedObject {
    @Persisted var individual: Reference?
    @Persisted var type: Codable_Concept?
}
