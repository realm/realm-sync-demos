//
//  LSignUpModel.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 02/05/22.
//

import Foundation
import RealmSwift

class signUpModelData : NSObject {
    var firstName   : RealmSwift.AnyBSON?
    var lastName    : RealmSwift.AnyBSON?
    var gender      : RealmSwift.AnyBSON?
    var authUserId  : RealmSwift.AnyBSON?
    var birthDate   : RealmSwift.AnyBSON?
    var id          : RealmSwift.AnyBSON?
    var userType    : RealmSwift.AnyBSON?
    var createdAt   : RealmSwift.AnyBSON?
    var uuid        : RealmSwift.AnyBSON?
    var referenceId : RealmSwift.AnyBSON?
    
    override init() {}
    
    convenience init(dictionary : [String : Any]) {
        self.init()
        self.firstName = dictionary["firstName"] as? RealmSwift.AnyBSON ?? ""
        self.lastName = dictionary["lastName"] as? RealmSwift.AnyBSON ?? ""
        self.gender = dictionary["gender"] as? RealmSwift.AnyBSON ?? ""
        self.authUserId = dictionary["authUserId"] as? RealmSwift.AnyBSON ?? ""
        self.birthDate = dictionary["birthDate"] as? RealmSwift.AnyBSON ?? ""
        self.id = dictionary["_id"] as? RealmSwift.AnyBSON ?? ""
        self.userType = dictionary["userType"] as? RealmSwift.AnyBSON ?? ""
        self.createdAt = dictionary["createdAt"] as? RealmSwift.AnyBSON ?? ""
        self.uuid = dictionary["uuid"] as? RealmSwift.AnyBSON ?? ""
        self.referenceId = dictionary["referenceId"] as? RealmSwift.AnyBSON ?? ""
    }
}
