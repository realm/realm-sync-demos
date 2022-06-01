//
//  PatientModel.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 22/04/22.
//

import Foundation
import RealmSwift

class Patient: Object {
    @Persisted(primaryKey: true) var _id    : ObjectId

    @Persisted var active                   : Bool?

    @Persisted var birthDate                : Date?

    @Persisted var gender                   : String?

    @Persisted var identifier               : String?

    @Persisted var name                     : Human_Name?
    
    override init() {}
    
    convenience init(_id : ObjectId, active : Bool, birthDate : Date, gender : String, identifier : String, name : Human_Name?) {
        self.init()
        self._id                = _id
        self.active             = active
        self.birthDate          = birthDate
        self.gender             = gender
        self.identifier         = identifier
        self.name               = name
    }
}

//User name 
class Human_Name: EmbeddedObject {
    @Persisted var given            : String?

    @Persisted var prefix           : List<String>

    @Persisted var suffix           : List<String>

    @Persisted var text             : String?
}
