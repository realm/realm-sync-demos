package com.wekanmdb.storeinventory.model.code

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey
import org.bson.types.ObjectId;

open class Code(
    @PrimaryKey var _id: ObjectId = ObjectId(),

    var category: String? = null,

    var code: String? = null,

    var comments: String? = null,

    var name: String? = null,

    var active: Boolean? = true,

    var system: String? = null
): RealmObject() {}
