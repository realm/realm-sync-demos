package com.wekanmdb.storeinventory.model.user

import com.wekanmdb.storeinventory.model.store.Stores
import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import io.realm.annotations.Required
import org.bson.types.ObjectId

open class Users(
        @PrimaryKey
        var _id: ObjectId = ObjectId(),
        var _partition: String = "",
        var customDataId: String? = null,
        var email: String = "",
        var firstName: String? = null,
        var lastName: String? = null,
        @Required
        var location: RealmList<Double>? = null,
        var stores: RealmList<Stores>? = null,
        var userRole: String? = null
): RealmObject()





