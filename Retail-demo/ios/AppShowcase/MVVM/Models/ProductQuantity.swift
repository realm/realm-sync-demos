//
//  ProductQuantity.swift
//  AppShowcase
//
//  Created by Gagandeep on 06/09/21.
//

import Foundation
import RealmSwift

//class ProductQuantity: Object {
//    @objc dynamic var _id: ObjectId = ObjectId.generate()
//
//    @objc dynamic var _partition: String = ""
//
//    @objc dynamic var product: Products?
//
//    @objc dynamic var quantity: Int = 0
//    override static func primaryKey() -> String? {
//        return "_id"
//    }
//}


class ProductQuantity: Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var _partition: String = ""
    @Persisted var quantity: Int = 0
    @Persisted var product: Products?

    convenience init(_partition: String, quantity: Int, product: Products?) {
        self.init()
        self._partition = _partition
        self.quantity = quantity
        self.product = product
    }
}
