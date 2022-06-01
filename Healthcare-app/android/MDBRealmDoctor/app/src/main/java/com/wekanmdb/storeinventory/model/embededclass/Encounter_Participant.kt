package com.wekanmdb.storeinventory.model.embededclass

import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class Encounter_Participant  (
    var type: Codable_Concept? = null,
    var individual: Reference? = null
) : RealmObject() {}