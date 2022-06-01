package com.wekanmdb.storeinventory.model.encounter

import com.wekanmdb.storeinventory.model.appoinment.Appointment
import com.wekanmdb.storeinventory.model.embededclass.Diagnosis
import com.wekanmdb.storeinventory.model.embededclass.Encounter_Participant
import com.wekanmdb.storeinventory.model.embededclass.Reference
import com.wekanmdb.storeinventory.model.patient.Patient
import io.realm.RealmList;
import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey
import org.bson.types.ObjectId;
open class Encounter(
    @PrimaryKey var _id: ObjectId = ObjectId(),
    var appointment: Appointment? = null,
    var diagnosis: Diagnosis? = null,
    var identifier: String? = null,
    var nurseIdentifier: String? = null,
    var participant: RealmList<Encounter_Participant> = RealmList(),
    var practitionerIdentifier: String? = null,
    var reasonReference: Reference? = null,
    var serviceProvider: Reference? = null,
    var status: String? = null,
    var subject: Patient? = null,
    var subjectIdentifier: String? = null): RealmObject() {}