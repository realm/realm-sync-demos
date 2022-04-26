package com.wekanmdb.storeinventory.model.product

import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import org.bson.types.ObjectId

open class Products(
        @PrimaryKey var _id: ObjectId = ObjectId(),
        var _partition: String = "",
        var description: String? = null,
        var brand: String? = null,
        var detail: String? = null,
        var image: String = "",
        var name: String = "",
        var price: Double = 0.0,
        var sku: Int = 0,
        var totalQuantity: Long = 0
): RealmObject()

