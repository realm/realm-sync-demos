package com.wekanmdb.storeinventory.model.embededclass

import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class Medication (
    var form: Codable_Concept? = null,
    var amount: Long?=null,
    var code: Codable_Concept? = null
) : RealmObject() {}