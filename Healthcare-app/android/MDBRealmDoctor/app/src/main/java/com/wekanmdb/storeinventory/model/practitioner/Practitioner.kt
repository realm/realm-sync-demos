package com.wekanmdb.storeinventory.model.practitioner

import com.wekanmdb.storeinventory.model.embededclass.Attachment
import com.wekanmdb.storeinventory.model.embededclass.Human_Name
import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import org.bson.types.ObjectId
import java.util.*

open class Practitioner(
    @PrimaryKey var _id: ObjectId = ObjectId(),
    var about: String? = null,
    var active: Boolean? = null,
    var birthDate: Date? = null,
    var gender: String? = null,
    var identifier: String? = null,
    var name: Human_Name? = null,
    var photo: RealmList<Attachment> = RealmList()
): RealmObject() {
}