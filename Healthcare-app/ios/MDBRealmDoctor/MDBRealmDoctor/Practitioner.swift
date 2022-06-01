//
//  Practitioner.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 02/05/22.
//

import Foundation
import RealmSwift

class Practitioner: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var about: String?
    @Persisted var active: Bool?
    @Persisted var birthDate: Date?
    @Persisted var gender: String?
    @Persisted var identifier: String?
    @Persisted var name: Human_Name?
    @Persisted var photo: List<Attachment>
    
    override init() {}
    
    convenience init(_id: ObjectId,about: String?,active: Bool?, birthDate: Date?, gender: String?, identifier: String?, name: Human_Name?,photo: List<Attachment>) {
        self.init()
        
        self._id        = _id
        self.about      = about
        self.active     = active
        self.birthDate  = birthDate
        self.gender     = gender
        self.identifier = identifier
        self.name       = name
        self.photo      = photo
    }
}
