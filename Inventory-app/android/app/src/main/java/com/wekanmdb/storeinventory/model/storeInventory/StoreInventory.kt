package com.wekanmdb.storeinventory.model.storeInventory

import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import io.realm.annotations.Required
import org.bson.types.ObjectId
import java.io.Serializable

open class StoreInventory(
    @PrimaryKey
    var _id: ObjectId=ObjectId(),
    var storeId: ObjectId?=null,
    var productId: ObjectId?=null,
    var quantity: Int? = 0,
    var productName: String="",
    var image: String = "",
    var _partition: String = ""
) : RealmObject()

