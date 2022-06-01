//
//  Organization.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/26/22.
//

import Foundation
import RealmSwift

class Organization: Object {
@Persisted(primaryKey: true) var _id: ObjectId
@Persisted var active: Bool?
@Persisted var address: List<Address>
@Persisted var identifier: String?
@Persisted var name: String?
@Persisted var photo: List<Attachment>
@Persisted var type: Codable_Concept?
    
    convenience init(_id: ObjectId, active: Bool, identifier: String, name: String?, address: List<Address>, photo: List<Attachment>, type: Codable_Concept?) {
        self.init()
        self._id = _id
        self.active = active
        self.identifier = identifier
        self.name = name
        self.address = address
        self.photo = photo
        self.type = type
    }
}
class Address: EmbeddedObject {
@Persisted var city: String?
@Persisted var country: String?
@Persisted var line: List<String>
@Persisted var postalCode: String?
@Persisted var state: String?
}

class Attachment: EmbeddedObject {
@Persisted var creation: Date?
@Persisted var data: String?
@Persisted var title: String?
@Persisted var url: String?
}

class Codable_Concept: EmbeddedObject {
@Persisted var coding: List<Coding> = List()
@Persisted var text: String?
}
class Coding: EmbeddedObject {
@Persisted var code: String?
@Persisted var display: String?
@Persisted var system: String?
}
