package com.wekanmdb.storeinventory.model.patient

import com.wekanmdb.storeinventory.model.embededclass.Human_Name
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import org.bson.types.ObjectId
import java.util.*

open class Patient  (
    @PrimaryKey var _id: ObjectId = ObjectId(),
    var identifier: String? = null,
    var active: Boolean? = null,
    var birthDate: Date? = null,
    var gender: String? = null,
    var name: Human_Name? = null

): RealmObject() {}