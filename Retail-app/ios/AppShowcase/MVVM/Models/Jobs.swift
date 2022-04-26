//
//  Jobs.swift
//  AppShowcase
//
//  Created by Gagandeep on 06/09/21.
//

import Foundation
import RealmSwift

class Job_Location: EmbeddedObject {
    @Persisted var latitude: Double = 0
    @Persisted var longitude: Double = 0
}

class Jobs: Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var _partition: String = ""
    @Persisted var status: String = ""
    @Persisted var createdBy: Users?
    @Persisted var assignedTo: Users?
    @Persisted var sourceStore: Stores?
    @Persisted var destinationStore: Stores?
    @Persisted var datetime: Date? = nil
    @Persisted var products = RealmSwift.List<ProductQuantity>()
    @Persisted var type: String? = nil
    @Persisted var order: ObjectId? = nil
    @Persisted var receivedBy: String? = nil
    @Persisted var location: Job_Location?

    convenience init(_partition: String, status: String, createdBy: Users?, assignedTo: Users?, sourceStore: Stores?, destinationStore: Stores?, datetime: Date?, products: List<ProductQuantity>, type: String?, order: ObjectId?, receivedBy: String?, location: Job_Location?) {
        self.init()
        self._partition = _partition
        self.status = status
        self.createdBy = createdBy
        self.assignedTo = assignedTo
        self.sourceStore = sourceStore
        self.destinationStore = destinationStore
        self.datetime = datetime
        self.products = products
        self.type = type
        self.order = order
        self.receivedBy = receivedBy
        self.location = location
    }
    
    func setJobInfo(fromOrder order: Orders) {
        self.order = order._id
        
        self._partition = order._partition //"master"
        self.status = order.paymentStatus ?? Paymentstatus.pending.rawValue
        self.createdBy = order.createdBy
//        self.assignedTo =
//        self.sourceStore = sourceStore
//        self.destinationStore = destinationStore
        self.datetime = Date()
        self.products = order.products
//        self.type = order.type?.name
        self.order = order._id
//        self.receivedBy = order.customerName
        self.location?.latitude = order.location?.latitude ?? 0.0
        self.location?.longitude = order.location?.longitude ?? 0.0
        self.destinationStore?.address = order.type?.address ?? ""
    }
}
