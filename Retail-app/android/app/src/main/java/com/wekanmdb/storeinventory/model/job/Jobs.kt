package com.wekanmdb.storeinventory.model.job

import com.wekanmdb.storeinventory.model.product.Products
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.model.user.Users
import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import io.realm.annotations.RealmClass
import org.bson.types.ObjectId
import java.util.*

open class Jobs(
        @PrimaryKey var _id: ObjectId = ObjectId(),
        var _partition: String = "",
        var assignedTo: Users? = null,
        var createdBy: Users? = null,
        var datetime: Date? = null,
        var destinationStore: Stores? = null,
        var order: ObjectId? = null,
        var products: RealmList<ProductQuantity> = RealmList(),
        var receivedBy: String? = null,
        var sourceStore: Stores? = null,
        var status: String = "",
        var type: String? = null,
        var location: Job_Location? = null
): RealmObject()


open class ProductQuantity(
        @PrimaryKey
        var _id: ObjectId = ObjectId(),
        var product: Products ?= null,
        var quantity: Int = 0,
        var _partition: String = "master"
) : RealmObject()

@RealmClass(embedded = true)
open class Job_Location(
        var latitude: Double = 0.0,
        var longitude: Double= 0.0

) : RealmObject()









