//
//  Condition.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 5/4/22.
//

import Foundation
import RealmSwift


class Condition: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var active: Bool? = true
    @Persisted var code: Codable_Concept?
    @Persisted var notes: String?
    @Persisted var subject: Reference?
    @Persisted var subjectIdentifier: String?
}

class Reference: EmbeddedObject {
    @Persisted var identifier: ObjectId?
    @Persisted var reference: String?
    @Persisted var type: String?
}

