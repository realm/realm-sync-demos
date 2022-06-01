package com.wekanmdb.storeinventory.model.embededclass

import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class Coding (
    var system: String? = null,
    var code: String? = null,
    var display: String? = null
) : RealmObject() {}