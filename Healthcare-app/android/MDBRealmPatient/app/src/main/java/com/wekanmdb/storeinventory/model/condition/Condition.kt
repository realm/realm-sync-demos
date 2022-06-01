package com.wekanmdb.storeinventory.model.condition

import com.wekanmdb.storeinventory.model.embededclass.Codable_Concept
import com.wekanmdb.storeinventory.model.embededclass.Reference
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import org.bson.types.ObjectId

open class Condition(
    @PrimaryKey var _id: ObjectId = ObjectId(),
    var active: Boolean? = null,
    var code: Codable_Concept? = null,
    var notes: String? = null,
    var subject: Reference? = null,
    var subjectIdentifier: String? = null
) : RealmObject() {}