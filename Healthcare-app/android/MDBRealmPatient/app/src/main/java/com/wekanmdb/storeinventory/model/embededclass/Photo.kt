package com.wekanmdb.storeinventory.model.embededclass

import io.realm.RealmObject;
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class Photo(
    var creation: String? = null,
    var title: String? = null
): RealmObject() {}
