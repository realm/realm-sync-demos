//
//  PractitionerRole.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/29/22.
//

import Foundation
import RealmSwift

class PractitionerRole: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var about: String?
    @Persisted var active: Bool?
    @Persisted var availableTime: Availability?
    @Persisted var code: Codable_Concept?
    @Persisted var identifier: String?
    @Persisted var name: Human_Name?
    @Persisted var organization: Organization?
    @Persisted var practitioner: Practitioner?
    @Persisted var specialty: Codable_Concept?
}



class Availability: EmbeddedObject {
@Persisted var allDay: Bool?
@Persisted var availableEndTime: String?
@Persisted var availableStartTime: String?
@Persisted var daysOfWeek: String?
}
class Practitioner: Object {
@Persisted(primaryKey: true) var _id: ObjectId
@Persisted var about: String?
@Persisted var active: Bool?
@Persisted var birthDate: Date?
@Persisted var gender: String?
@Persisted var identifier: String?
@Persisted var name: Human_Name?
@Persisted var photo: List<Attachment>
}
