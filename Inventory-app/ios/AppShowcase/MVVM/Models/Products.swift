//
//  Products.swift
//  AppShowcase
//
//  Created by Gagandeep on 31/08/21.
//

import Foundation
import RealmSwift

class Products: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var _partition: String
    @Persisted var name: String = ""
    @Persisted var detail: String? = nil
    @Persisted var sku: Int = 0
    @Persisted var image: String = ""
    @Persisted var price: Double = 0.00
    @Persisted var totalQuantity: Int = 0
    
    convenience init(_id: ObjectId, partition: String, name: String, detail: String?, sku: Int, image: String, price: Double, totalQuantity: Int) {
        self.init()
        self._id = _id
        self._partition = partition
        self.name = name
        self.detail = detail
        self.sku = sku
        self.image = image
        self.price = price
        self.totalQuantity = totalQuantity
    }
}
