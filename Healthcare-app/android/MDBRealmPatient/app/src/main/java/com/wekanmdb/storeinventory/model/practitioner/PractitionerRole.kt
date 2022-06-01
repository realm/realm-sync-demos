package com.wekanmdb.storeinventory.model.practitioner

import com.wekanmdb.storeinventory.model.embededclass.*
import com.wekanmdb.storeinventory.model.organization.Organization
import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import org.bson.types.ObjectId

open class PractitionerRole (
    @PrimaryKey var _id: ObjectId = ObjectId(),
    var identifier: String? = null,
    var active: Boolean? = null,
    var practitioner: Practitioner? = null,
    var organization: Organization? = null,
    var availableTime: Availability? = null,
    var code:Codable_Concept? = null,
    var specialty:Codable_Concept? = null
): RealmObject() {
}