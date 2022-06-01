package com.wekanmdb.storeinventory.model.procedure

import com.wekanmdb.storeinventory.model.embededclass.Medication
import com.wekanmdb.storeinventory.model.embededclass.Procedure_Notes
import com.wekanmdb.storeinventory.model.encounter.Encounter
import com.wekanmdb.storeinventory.model.patient.Patient
import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import io.realm.annotations.Required
import org.bson.types.ObjectId

open class Procedure (
    @PrimaryKey var _id: ObjectId = ObjectId(),
    var identifier: String? = null,
    var status: String? = null,
    var subject: Patient? = null,
    var encounter: Encounter? = null,
    var usedReference: RealmList<Medication> = RealmList(),
    var note: RealmList<Procedure_Notes> = RealmList(),
    var patientIdentifier: String? = null,
    var practitionerIdentifier: String? = null,
    var nurseIdentifier: String? = null
): RealmObject() {
}