package com.wekanmdb.storeinventory.model.product

import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import org.bson.types.ObjectId

open class Products(
        @PrimaryKey
        var _id: ObjectId = ObjectId(),
        var name: String = "",
        var detail: String ?= null,
        var sku: Long = 0,
        var image: String = "",
        var price: Double = 0.0,
        var totalQuantity: Int = 0,
        var _partition: String = ""
) : RealmObject()

