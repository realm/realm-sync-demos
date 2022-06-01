package com.wekanmdb.storeinventory.model.embededclass

import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.RealmClass
import org.bson.types.ObjectId

@RealmClass(embedded = true)
open class Reference(
    var type: String?=null,
    var identifier: ObjectId? = null,
    var reference: String? = null
) : RealmObject() {}