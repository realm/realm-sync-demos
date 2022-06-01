package com.wekanmdb.storeinventory.model.appoinment

import com.wekanmdb.storeinventory.model.embededclass.Appointment_Participant
import com.wekanmdb.storeinventory.model.embededclass.Reference
import io.realm.RealmList;
import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey
import java.util.Date;
import org.bson.types.ObjectId;
open class Appointment(
    @PrimaryKey var _id: ObjectId = ObjectId(),
    var end: Date? = null,
    var identifier: String? = null,
    var participant: RealmList<Appointment_Participant> = RealmList(),
    var patientIdentifier: String? = null,
    var patientInstruction: String? = null,
    var practitionerIdentifier: String? = null,
    var reasonReference: Reference? = null,
    var slot: Long? = null,
    var start: Date? = null,
    var status: String? = null
): RealmObject() {}