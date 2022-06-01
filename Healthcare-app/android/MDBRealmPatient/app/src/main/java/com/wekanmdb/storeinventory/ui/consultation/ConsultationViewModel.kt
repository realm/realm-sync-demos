package com.wekanmdb.storeinventory.ui.consultation

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.encounter.Encounter
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class ConsultationViewModel @Inject constructor() : BaseViewModel<ConsultationNavigator>() {
    val consultationResponseBody = MutableLiveData<RealmResults<Encounter>?>()
    val id = user?.customData?.get("referenceId") as ObjectId

    //getting all consultations based on the patient id
    fun getConsultationDataList() {

        val consultationList = apprealm?.where<Encounter>()?.equalTo(
            "subject._id", id
        )?.findAll()
        consultationList?.addChangeListener { result ->
            if (result.isNotEmpty()) {
                consultationResponseBody.postValue(consultationList)
            } else {
                consultationResponseBody.value = consultationList
            }
        }
        if (!consultationList.isNullOrEmpty()) {
            consultationResponseBody.postValue(consultationList)
        } else {
            consultationResponseBody.value = consultationList
        }
    }

}