package com.wekanmdb.storeinventory.model.organization

import com.wekanmdb.storeinventory.model.embededclass.Address
import com.wekanmdb.storeinventory.model.embededclass.Attachment
import com.wekanmdb.storeinventory.model.embededclass.Codable_Concept
import io.realm.RealmList;
import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey
import io.realm.annotations.Required
import org.bson.types.ObjectId;

open class Organization(
    @PrimaryKey var _id: ObjectId = ObjectId(),
    var active: Boolean? = null,
    var address: RealmList<Address> = RealmList(),
    var identifier: String? = null,
    var name: String? = null,
    var photo: RealmList<Attachment> = RealmList(),
    var type: Codable_Concept? = null
) : RealmObject() {}