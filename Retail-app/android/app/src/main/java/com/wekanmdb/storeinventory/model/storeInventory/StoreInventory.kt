package com.wekanmdb.storeinventory.model.storeInventory

import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import io.realm.annotations.Required
import org.bson.types.ObjectId
import java.io.Serializable

open class StoreInventory(
    @PrimaryKey var _id: ObjectId = ObjectId(),
    var _partition: String = "",
    var image: String = "",
    var productId: ObjectId? = null,
    var productName: String = "",
    var quantity: Int? = null,
    var storeId: ObjectId? = null
): RealmObject()

