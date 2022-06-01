package com.wekanmdb.storeinventory.model.embededclass

import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.RealmClass
import io.realm.annotations.Required

@RealmClass(embedded = true)
open class Human_Name(
    var text: String? = null,
    @Required
    var prefix: RealmList<String> = RealmList(),
    @Required
    var suffix: RealmList<String> = RealmList(),
    var given: String? = null
) : RealmObject() {}