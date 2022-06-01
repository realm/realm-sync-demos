package com.wekanmdb.storeinventory.ui.hospital

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class HospitalViewModel @Inject constructor() : BaseViewModel<HospitalNavigator>() {

    val doctorListResponseBody = MutableLiveData<RealmResults<PractitionerRole>?>()

    //Getting Doctor List By passing Organization id and code equals to doctor
    fun getDoctorList(id: ObjectId) {
        val doctorList = apprealm?.where<PractitionerRole>()?.equalTo("organization._id", id)
            ?.equalTo("code.coding.code", "doctor")?.findAll()

        doctorList?.addChangeListener { result ->
            if (result.isNotEmpty()) {
                doctorListResponseBody.postValue(doctorList)
            } else {
                doctorListResponseBody.value = doctorList
            }
        }
        if (!doctorList.isNullOrEmpty()) {
            doctorListResponseBody.postValue(doctorList)
        } else {
            doctorListResponseBody.value = doctorList
        }

    }
}