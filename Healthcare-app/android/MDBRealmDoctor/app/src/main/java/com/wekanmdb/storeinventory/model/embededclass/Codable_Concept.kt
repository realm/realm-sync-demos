package com.wekanmdb.storeinventory.model.embededclass

import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.RealmClass
import io.realm.annotations.Required

@RealmClass(embedded = true)
open class Codable_Concept (

    var coding: RealmList<Coding> = RealmList(),
    var text: String? = null
) : RealmObject() {}