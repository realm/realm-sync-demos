//
//  Stores.swift
//  AppShowcase
//
//  Created by Gagandeep on 06/09/21.
//

import Foundation
import RealmSwift

//class Stores: Object {
//    @objc dynamic var _id: ObjectId = ObjectId.generate()
//
//    @objc dynamic var _partition: String = ""
//
//    @objc dynamic var address: String = ""
//
//    @objc dynamic var name: String = ""
//    override static func primaryKey() -> String? {
//        return "_id"
//    }
//}


class Stores: Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var _partition: String = ""
    @Persisted var name: String = ""
    @Persisted var address: String = ""

    convenience init(_id: ObjectId, name: String, address: String, _partition: String) {
        self.init()
        self._id = _id
        self._partition = _partition
        self.name = name
        self.address = address
    }
}
