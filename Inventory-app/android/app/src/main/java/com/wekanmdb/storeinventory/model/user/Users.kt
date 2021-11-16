package com.wekanmdb.storeinventory.model.user

import com.wekanmdb.storeinventory.model.store.Stores
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import io.realm.annotations.Required
import org.bson.types.ObjectId

open class Users(
        @PrimaryKey
        var _id: ObjectId=ObjectId(),
        var email: String = "",
        var firstName: String? = null,
        var lastName: String? = null,
        var userRole: String? = null,
        var stores: Stores? = null,
        var customDataId: String? = null,
        var _partition: String = ""
) : RealmObject()





