//
//  Organisation.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 02/05/22.
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
    
    override init() {}
    
    convenience init(id: ObjectId, active: Bool?,address: List<Address>,identifier: String?, name: String?,photo: List<Attachment>,type: Codable_Concept? ) {
        self.init()
        
        self._id        = id
        self.active     = active
        self.address    = address
        self.identifier = identifier
        self.name       = name
        self.photo      = photo
        self.type       = type
    }
}

class Address: EmbeddedObject {
    @Persisted var city: String?

    @Persisted var country: String?

    @Persisted var line: List<String>

    @Persisted var postalCode: String?

    @Persisted var state: String?
}
