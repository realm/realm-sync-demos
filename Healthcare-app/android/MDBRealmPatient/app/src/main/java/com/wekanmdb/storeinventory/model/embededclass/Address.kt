package com.wekanmdb.storeinventory.model.embededclass

import io.realm.RealmList;
import io.realm.RealmObject;
import io.realm.annotations.RealmClass
import io.realm.annotations.Required

@RealmClass(embedded = true)
open class Address(
    var city: String? = null,

    var country: String? = null,
   @Required
    var line: RealmList<String> = RealmList(),

    var postalCode: String? = null,

    var state: String? = null
) : RealmObject() {}
