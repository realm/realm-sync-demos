//
//  Orders.swift
//  AppShowcase
//
//  Created by Brian Christo on 11/02/22.
//

import Foundation
import RealmSwift

class Orders_type: EmbeddedObject {
    @Persisted var address: String? = nil
    @Persisted var name: String = ""
}

class Order_Location: EmbeddedObject {
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
}

class Orders: Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var _partition: String = ""
    @Persisted var createdDate: Date = Date()
    @Persisted var orderId: String  = ""
    @Persisted var customerName: String = ""
    @Persisted var customerEmail: String = ""
    @Persisted var type: Orders_type?
    @Persisted var paymentStatus: String? = nil
    @Persisted var paymentType: String = ""
    @Persisted var createdBy: Users?
    @Persisted var products = RealmSwift.List<ProductQuantity>()
    @Persisted var location: Order_Location?

    convenience init(_partition: String, orderId: String, customerName: String, customerEmail: String, paymentStatus: String, paymentType: String, createdDate: Date, type: Orders_type?, createdBy: Users?, products: List<ProductQuantity>) {
        self.init()
        self._partition = _partition
        self.orderId = orderId
        self.customerName = customerName
        self.customerEmail = customerEmail
        self.paymentStatus = paymentStatus
        self.paymentType = paymentType
        self.createdDate = createdDate
        self.type = type
        self.products = products
    }
}

//class OrderType: Object {
//    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted var name: String = ""
//    @Persisted var address: String? = nil
//
//    convenience init(name: String, address: String) {
//        self.init()
//        self.name = name
//        self.address = address
//    }
//
//}
