//
//  StoreInventory.swift
//  AppShowcase
//
//  Created by Gagandeep on 06/09/21.
//

import Foundation
import RealmSwift

//class StoreInventory: Object {
//    @objc dynamic var _id: ObjectId = ObjectId.generate()
//
//    @objc dynamic var _partition: String = ""
//
//    @objc dynamic var image: String = ""
//
//    @objc dynamic var productId: ObjectId? = nil
//
//    @objc dynamic var productName: String = ""
//
////    dynamic var quantity: Int?
//    @Persisted var quantity: Int?
//
//    @objc dynamic var storeId: ObjectId? = nil
//    override static func primaryKey() -> String? {
//        return "_id"
//    }
//}


class StoreInventory: Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var _partition: String = ""
    @Persisted var productName: String = ""
    @Persisted var image: String = ""
    @Persisted var quantity: Int?
    @Persisted var storeId: ObjectId? = nil
    @Persisted var productId: ObjectId? = nil

//    convenience init(_id: ObjectId, storeId: ObjectId, productId: ObjectId, image: String, quantity: Int, productName: String, _partition: String) {
//        self.init()
//        self._id = _id
//        self._partition = _partition
//        self.storeId = storeId
//        self.productId = productId
//        self.image = image
//        self.productName = productName
//        self.quantity = quantity
//    }
}
