//
//  Users.swift
//  AppShowcase
//
//  Created by Gagandeep on 06/09/21.
//

import Foundation
import RealmSwift

class Users: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var _partition: String = ""
    @Persisted var email: String = ""
    @Persisted var firstName: String? = nil
    @Persisted var lastName: String? = nil
    @Persisted var userRole: String? = nil
    @Persisted var stores: Stores? = nil
    @Persisted var customDataId: String? = nil

    convenience init(_id: ObjectId, _partition: String, email: String, firstName: String?, lastName: String?, userRole: String?, store: Stores?, customDataId: String?) {
        self.init()
        self._id = _id
        self._partition = _partition
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.userRole = userRole
        self.stores = store
        self.customDataId = customDataId
    }
}
