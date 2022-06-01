package com.wekanmdb.storeinventory.model.embededclass

import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class Diagnosis  (
    var condition: Reference? = null,
    var rank: Long? = null,
    var use: Codable_Concept? = null
) : RealmObject() {}