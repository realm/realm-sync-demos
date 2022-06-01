package com.wekanmdb.storeinventory.model.embededclass

import io.realm.RealmObject
import io.realm.annotations.RealmClass
import java.util.*

@RealmClass(embedded = true)
open class Procedure_Notes(
    var author: Reference?=null,
    var time: Date? = null,
    var text: String? = null

) : RealmObject() {}