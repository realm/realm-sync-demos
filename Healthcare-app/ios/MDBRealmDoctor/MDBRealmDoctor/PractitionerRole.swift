//
//  PractitionerRole.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 02/05/22.
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

    @Persisted var photo: List<Attachment>

    @Persisted var practitioner: Practitioner?

    @Persisted var specialty: Codable_Concept?
    
    override init() {}
    
    convenience init(_id: ObjectId,about: String?, active: Bool?,availableTime: Availability?,code: Codable_Concept?,identifier: String?,name: Human_Name?,organization: Organization?,photo: List<Attachment>,practitioner: Practitioner?,specialty: Codable_Concept?) {
        self.init()
        
        self._id                    = _id
        self.about                  = about
        self.active                 = active
        self.availableTime          = availableTime
        self.code                   = code
        self.identifier             = identifier
        self.name                   = name
        self.organization           = organization
        self.photo                  = photo
        self.practitioner           = practitioner
        self.specialty              = specialty
    }
}

class Availability: EmbeddedObject {
    @Persisted var allDay: Bool?

    @Persisted var availableEndTime: String?

    @Persisted var availableStartTime: String?

    @Persisted var daysOfWeek: String?
}

class Attachment: EmbeddedObject {
    @Persisted var creation: Date?

    @Persisted var data: String?

    @Persisted var title: String?

    @Persisted var url: String?
}
