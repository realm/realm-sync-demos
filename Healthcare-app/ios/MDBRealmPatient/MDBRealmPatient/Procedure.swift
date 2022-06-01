//
//  Procedure.swift
//  MDBRealmPatient
//
//  Created by Mackbook on 07/05/22.
//

import Foundation
import RealmSwift

class Procedure: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var encounter: Encounter?
    @Persisted var identifier: String?
    @Persisted var note: List<Procedure_Notes>
    @Persisted var nurseIdentifier: String?
    @Persisted var patientIdentifier: String?
    @Persisted var practitionerIdentifier: String?
    @Persisted var status: String?
    @Persisted var subject: Patient?
    @Persisted var usedReference: List<Medication>
}
class Procedure_Notes: EmbeddedObject {
    @Persisted var author: Reference?
    @Persisted var text: String?
    @Persisted var time: Date?
}
class Medication: EmbeddedObject {
    @Persisted var amount: Int?
    @Persisted var code: Codable_Concept?
    @Persisted var form: Codable_Concept?
}
