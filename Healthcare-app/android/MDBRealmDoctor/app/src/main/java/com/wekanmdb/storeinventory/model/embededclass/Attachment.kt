package com.wekanmdb.storeinventory.model.embededclass

import io.realm.RealmObject;
import io.realm.annotations.RealmClass
import java.util.*

@RealmClass(embedded = true)
open class Attachment(
    var creation: Date? = null,
    var data: String? = null,
    var title: String? = null,
    var url: String? = null
): RealmObject() {}
