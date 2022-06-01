package com.wekanmdb.storeinventory.model.encounter

import com.wekanmdb.storeinventory.model.appoinment.Appointment
import com.wekanmdb.storeinventory.model.embededclass.Diagnosis
import com.wekanmdb.storeinventory.model.embededclass.Encounter_Participant
import com.wekanmdb.storeinventory.model.embededclass.Reference
import com.wekanmdb.storeinventory.model.patient.Patient
import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import io.realm.annotations.Required
import org.bson.types.ObjectId

open class Encounter (
    @PrimaryKey var _id: ObjectId = ObjectId(),
    var identifier: String? = null,
    var status: String? = null,
    var reasonReference: Reference? = null,
    var subject: Patient? = null,
    var participant: RealmList<Encounter_Participant> = RealmList(),
    var appointment: Appointment? = null,
    var serviceProvider: Reference? = null,
    var diagnosis: Diagnosis? = null,
    var subjectIdentifier: String? = null,
    var practitionerIdentifier: String? = null,
    var nurseIdentifier: String? = null
) : RealmObject() {}