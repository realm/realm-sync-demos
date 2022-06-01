package com.wekanmdb.storeinventory.model.appoinment

import com.wekanmdb.storeinventory.model.embededclass.Appointment_Participant
import com.wekanmdb.storeinventory.model.embededclass.Reference
import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import io.realm.annotations.Required
import org.bson.types.ObjectId
import java.util.*

open class Appointment (
    @PrimaryKey var _id: ObjectId = ObjectId(),
    var identifier: String? = null,
    var status: String? = null,
    var reasonReference: Reference? = null,
    var start: Date?=null,
    var end: Date?=null,
    var patientInstruction: String? = null,
    var participant: RealmList<Appointment_Participant> = RealmList(),
    var slot: Long? = null,
    var patientIdentifier: String? = null,
    var practitionerIdentifier: String? = null,
    var nurseIdentifier: String? = null
) : RealmObject() {}