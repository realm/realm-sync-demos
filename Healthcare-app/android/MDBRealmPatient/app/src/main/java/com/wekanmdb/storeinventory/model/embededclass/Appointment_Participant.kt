package com.wekanmdb.storeinventory.model.embededclass

import io.realm.RealmObject
import io.realm.annotations.RealmClass
@RealmClass(embedded = true)
open class Appointment_Participant(
    var actor: Reference?= null,
    var required: Boolean? = null,
    var status: String? = null
) : RealmObject() {}