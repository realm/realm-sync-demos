package com.wekanmdb.storeinventory.model.embededclass

import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class Availability(
    var daysOfWeek: String? = null,
    var availableStartTime: String?=null,
    var availableEndTime: String?=null,
    var allDay: Boolean? = null

):RealmObject() {
}