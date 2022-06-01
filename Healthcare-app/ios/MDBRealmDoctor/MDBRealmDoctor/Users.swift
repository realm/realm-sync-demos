//
//  Users.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 02/05/22.
//

import Foundation
import RealmSwift

class Users: Object {
    @Persisted(primaryKey: true) var _id    : ObjectId

    @Persisted var _partition               : String = ""

    @Persisted var customDataId             : String?

    @Persisted var email                    : String = ""

    @Persisted var firstName                : String?

    @Persisted var lastName                 : String?

    @Persisted var location                 : List<Double>

    @Persisted var userRole                 : String?
    
    override init() {}
    
    convenience init(_id: ObjectId, _partition : String, customDataId : String, email : String, firstName : String, lastName : String, location : List<Double>, userRole : String) {
        self.init()
        
        self._id                = _id
        self._partition         = _partition
        self.customDataId       = customDataId
        self.email              = email
        self.firstName          = firstName
        self.lastName           = lastName
        self.location           = location
        self.userRole           = userRole
    }
}
