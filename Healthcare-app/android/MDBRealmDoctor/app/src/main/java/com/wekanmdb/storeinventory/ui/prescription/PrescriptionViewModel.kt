package com.wekanmdb.storeinventory.ui.prescription

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.condition.Condition
import com.wekanmdb.storeinventory.model.embededclass.*
import com.wekanmdb.storeinventory.model.encounter.Encounter
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import com.wekanmdb.storeinventory.model.procedure.Procedure
import com.wekanmdb.storeinventory.utils.Constants.Companion.NURSE
import io.realm.RealmList
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class PrescriptionViewModel @Inject constructor() : BaseViewModel<PrescriptionNavigator>() {
    /**
     * This getEncounter  method is used to fetch Encounter list info to view.
     */
    val encounterResponseBody = MutableLiveData<Encounter>()

    /**
     * This getCondition method is used to fetch Condition list info to view.
     */
    val conditionResponseBody = MutableLiveData<Condition?>()

    /**
     * This getProcedure method is used to fetch Procedure info to view.
     */
    val medicationAllResponseBody = MutableLiveData<Procedure?>()

    /**
     * This getPractitionerRole method is used to fetch PractitionerRole info to view the nurse list.
     */
    val nurseResponseBody = MutableLiveData<PractitionerRole?>()
    var consultationList: RealmResults<Encounter>? = null
    val response = MutableLiveData<Boolean>()
    val updateEncounter = MutableLiveData<Boolean>()
    val updateProcedure = MutableLiveData<Boolean>()
    fun getConsultation(id: ObjectId) {
        if (apprealm != null && apprealm?.isClosed == false) {
            /**
             * Selecting Encounter from Encounter collection.
             */

            val encounter = apprealm?.where<Encounter>()?.equalTo("_id", id)?.findFirst()
            if (encounter != null) {
                encounterResponseBody.postValue(apprealm!!.copyFromRealm(encounter))
            } else {
                encounterResponseBody.value = null
            }
        }
    }

    fun getConcern(_id: ObjectId?) {
        /**
         * Selecting Condition from Condition collection based on selected condition by patient.
         */

        val condition = apprealm?.where<Condition>()?.equalTo("_id", _id)?.findFirst()
        if (condition != null) {
            conditionResponseBody.postValue(apprealm!!.copyFromRealm(condition))
        } else {
            conditionResponseBody.value = null
        }
    }

    fun getAllMedicationCode(_id: ObjectId) {
        /**
         * Selecting Procedure from Procedure collection based on patient encounter.
         */
        val condition = apprealm?.where<Procedure>()?.equalTo("encounter._id", _id)?.findFirst()
        consultationList?.addChangeListener { result ->
            if (result.isNotEmpty()) {
                medicationAllResponseBody.postValue(apprealm!!.copyFromRealm(condition))
            } else {
                medicationAllResponseBody.value = null
            }
        }
        if (condition != null) {
            medicationAllResponseBody.postValue(apprealm!!.copyFromRealm(condition))
        } else {
            medicationAllResponseBody.value = null
        }
    }

    fun getNurse(_id: ObjectId) {
        /**
         * Selecting Nurse list from PractitionerRole
         */

        val nurse = apprealm?.where<PractitionerRole>()?.equalTo("practitioner._id", _id)
            ?.equalTo("code.coding.code", NURSE)?.findFirst()
        consultationList?.addChangeListener { result ->
            if (result.isNotEmpty()) {
                nurseResponseBody.postValue(apprealm!!.copyFromRealm(nurse))
            } else {
                nurseResponseBody.value = null
            }
        }

        if (nurse != null) {
            nurseResponseBody.postValue(apprealm!!.copyFromRealm(nurse))
        } else {
            nurseResponseBody.value = null
        }
    }

    fun updateMedication(procedure: Procedure?, selectedItems: RealmList<Coding>) {

        try {

            apprealm?.executeTransaction() { realm ->

                val medication = Medication()
                val codableConept = Codable_Concept()
                val medicationList: RealmList<Medication> = RealmList()
                // Adding selected Medications code to codableConept concept
                codableConept.coding.addAll(selectedItems)
                // Assigning the codableConept to medication collection
                medication.code = codableConept
                medicationList.add(medication)
                // Adding the medication collection to procedure usedReference
                procedure?.usedReference = medicationList
                //Insert the procedure
                realm.insertOrUpdate(procedure)
                response.postValue(true)
            }
        } catch (e: Exception) {
            response.postValue(false)
        }

    }

    fun updateNotes(procedure: Procedure?, notes: String, persion: String) {
        try {
            apprealm?.executeTransaction() { realm ->
                val user = user?.customData?.get("referenceId") as ObjectId

                val reference = Reference()
                reference.type = "Relative"
                reference.identifier = user
                reference.reference = "Practitioner/$persion"

                val procedureNotes = Procedure_Notes()
                procedureNotes.author = reference
                procedureNotes.text = notes

                // Checking whether notes are already available or not
                if (!procedure?.note.isNullOrEmpty() && procedure?.note?.find { it.author?.identifier == user } != null) {
                    // Update notes
                    procedure.note.find { it.author?.identifier == user }?.let {
                        it.text = notes
                    }
                } else {
                    //Adding the notes
                    procedure?.note!!.add(procedureNotes)
                }

                realm.insertOrUpdate(procedure)
                response.postValue(true)
            }
        } catch (e: Exception) {
            response.postValue(false)
        }

    }

    fun updatePractitioner(
        encounter: Encounter?,
        id: ObjectId,
        identifier: String?,
        procedure: Procedure?
    ) {


        try {

            apprealm?.executeTransaction() { realm ->

                // Create coding for nurse
                val coding = Coding()
                coding.system = "http://snomed.info/sct"
                coding.code = NURSE
                coding.display = "Nurse"

                val codingList: RealmList<Coding> = RealmList()
                codingList.add(coding)

                val codableConcept = Codable_Concept()
                codableConcept.coding = codingList

                val encounterParticipant = Encounter_Participant()
                encounterParticipant.type = codableConcept

                val reference = Reference()
                reference.reference = "Practitioner/Nurse"
                reference.identifier = id
                reference.type = "Relative"
                if (encounter?.participant?.size!! > 1) {
                    encounter.participant.forEach {
                        it.type?.coding?.forEach { coding ->
                            if (coding.code == NURSE) {
                                it.individual?.identifier = id
                            }

                        }
                    }
                } else {
                    encounterParticipant.individual = reference
                    encounter.participant.add(encounterParticipant)
                }

                encounter.nurseIdentifier=identifier
                encounter.appointment?.nurseIdentifier=identifier
               realm.insertOrUpdate(encounter)

               // updateEncounter.postValue(true)
            }

        } catch (e: Exception) {
            //updateEncounter.postValue(false)
        }

    }
    fun updateProcedure(
        identifier: String?,
        procedure: Procedure?
    ) {


        try {

            apprealm?.executeTransaction() { realm ->

                // Update nurse identifier in procedure
                procedure?.nurseIdentifier=identifier
                realm.insertOrUpdate(procedure)

                updateProcedure.postValue(true)
            }

        } catch (e: Exception) {
            updateProcedure.postValue(false)
        }

    }


}