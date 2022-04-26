//
//  Users.swift
//  AppShowcase
//
//  Created by Gagandeep on 06/09/21.
//

import Foundation
import RealmSwift

//class Users: Object {
//    @objc dynamic var _id: ObjectId = ObjectId.generate()
//
//    @objc dynamic var _partition: String = ""
//
//    @objc dynamic var customDataId: String? = nil
//
//    @objc dynamic var email: String = ""
//
//    @objc dynamic var firstName: String? = nil
//
//    @objc dynamic var lastName: String? = nil
//
//    let location = RealmSwift.List<Double>()
//
//    dynamic var stores = RealmSwift.List<Stores>()
//
//    @objc dynamic var userRole: String? = nil
//    override static func primaryKey() -> String? {
//        return "_id"
//    }
//}


class Users: Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var _partition: String = ""
    @Persisted var email: String = ""
    @Persisted var firstName: String? = nil
    @Persisted var lastName: String? = nil
    @Persisted var userRole: String? = nil
    @Persisted var stores = RealmSwift.List<Stores>()
    @Persisted var customDataId: String? = nil
    @Persisted var location = RealmSwift.List<Double>()

    convenience init(_id: ObjectId, _partition: String, email: String, firstName: String?, lastName: String?, userRole: String?, store: RealmSwift.List<Stores>, customDataId: String?, location: RealmSwift.List<Double>) {
        self.init()
        self._id = _id
        self._partition = _partition
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.userRole = userRole
        self.stores = store
        self.customDataId = customDataId
        self.location = location
    }
}
