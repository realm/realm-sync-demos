//
//  Jobs.swift
//  AppShowcase
//
//  Created by Gagandeep on 06/09/21.
//

import Foundation
import RealmSwift

class Jobs: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var _partition: String = ""
    @Persisted var status: String = ""
    @Persisted var createdBy: Users? = nil
    @Persisted var assignedTo: Users? = nil
    @Persisted var sourceStore: Stores? = nil
    @Persisted var destinationStore: Stores? = nil
    @Persisted var pickupDatetime: Date? = nil
    @Persisted var products: RealmSwift.List<ProductQuantity>

    convenience init(_partition: String, status: String, createdBy: Users?, assignedTo: Users?, sourceStore: Stores?, destinationStore: Stores?, pickupDatetime: Date?, products: List<ProductQuantity>) {
        self.init()
        self._partition = _partition
        self.status = status
        self.createdBy = createdBy
        self.assignedTo = assignedTo
        self.sourceStore = sourceStore
        self.destinationStore = destinationStore
        self.pickupDatetime = pickupDatetime
        self.products = products
    }
}
