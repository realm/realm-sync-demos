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
        @PrimaryKey
        var _id: ObjectId = ObjectId(),
        var createdBy: Users? = null,
        var assignedTo: Users? = null,
        var sourceStore: Stores? = null,
        var destinationStore: Stores? = null,
        var pickupDatetime: Date? = null,
        var status: String = "",
        var products: RealmList<ProductQuantity>? = null,
        var _partition: String = "master"
) : RealmObject()


open class ProductQuantity(
        @PrimaryKey
        var _id: ObjectId = ObjectId(),
        var product: Products ?= null,
        var quantity: Int = 0,
        var _partition: String = "master"
) : RealmObject()









