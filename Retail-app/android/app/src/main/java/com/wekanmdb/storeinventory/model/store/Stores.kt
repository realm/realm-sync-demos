package com.wekanmdb.storeinventory.model.store

import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import io.realm.annotations.Required
import org.bson.types.ObjectId

open class Stores(
    @PrimaryKey var _id: ObjectId = ObjectId(),
    var _partition: String = "",
    var address: String = "",
    var name: String = ""
): RealmObject()


