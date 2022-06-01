package com.wekanmdb.storeinventory.ui.patientBasicInfo

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.condition.Condition
import com.wekanmdb.storeinventory.model.embededclass.Codable_Concept
import com.wekanmdb.storeinventory.model.embededclass.Coding
import com.wekanmdb.storeinventory.model.embededclass.Reference
import io.realm.RealmList
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class PatientInfoViewModel @Inject constructor() : BaseViewModel<PatientInfoNavigator>() {
    private lateinit var submitIllness: Condition
    private val codingList = RealmList<Coding>()
    val conditionListResponseBody = MutableLiveData<RealmResults<Condition>?>()

    /*
        *Passing conditionCode,system,notes and name for adding illness
        *  */
    fun submitIllnessCondition(
        conditionCode: String?,
        conditionID: String,
        system: String,
        notes: String?,
        name: String?
    ): MutableLiveData<Boolean> {
        val response = MutableLiveData<Boolean>()
        apprealm?.executeTransaction {
            submitIllness = Condition()
            val codingCode = Coding(system = system, code = conditionCode, display = name)
            codingList.add(codingCode)
            val codableConcept =
                codingList.let { it1 -> Codable_Concept(coding = it1, text = name) }
            val reference = Reference(
                type = "Relative",
                identifier = user?.customData?.get("referenceId") as ObjectId,
                reference = "Patient"
            )
            submitIllness.active=true
            submitIllness.code = codableConcept
            submitIllness.notes = notes
            submitIllness.subject = reference
            submitIllness.subjectIdentifier = user?.customData?.get("uuid") as String
            it.insert(submitIllness)
            response.postValue(true)
        }
        return response
    }

    //getting list of condition based on patient Id
    fun getConditionListToFilter() {
        val conditionList = apprealm?.where<Condition>()
            ?.equalTo("subject.identifier", user?.customData?.get("referenceId") as ObjectId)
            ?.findAll()
        conditionList?.addChangeListener { result ->
            if (result.isNotEmpty()) {
                conditionListResponseBody.postValue(conditionList)
            } else {
                conditionListResponseBody.value = conditionList
            }

        }
        if (conditionList?.isNotEmpty() == true) {
            conditionListResponseBody.postValue(conditionList)
        } else {
            conditionListResponseBody.value = conditionList
        }
    }

    fun nextClick() {
        navigator.nextClick()
    }

    fun addIllnessClick() {
        navigator.addIllnessClick()
    }

    fun removeAddedCondition(string: String) {
        navigator.removeAddedCondition(string)
    }
}