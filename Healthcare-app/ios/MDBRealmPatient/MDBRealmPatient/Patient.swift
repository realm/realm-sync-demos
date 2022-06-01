//
//  Patient.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/29/22.
//

import Foundation
import RealmSwift


class Patient: Object {
@Persisted(primaryKey: true) var _id: ObjectId
@Persisted var active: Bool?
@Persisted var birthDate: Date?
@Persisted var gender: String?
@Persisted var identifier: String?
@Persisted var name: Human_Name?
}
class Human_Name: EmbeddedObject {
@Persisted var given: String?
@Persisted var prefix: List<String>
@Persisted var suffix: List<String>
@Persisted var text: String?
}
