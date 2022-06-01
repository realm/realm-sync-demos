package com.wekanmdb.storeinventory.ui.profile

import android.util.Log
import androidx.databinding.ObservableField
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.data.AppConstants
import com.wekanmdb.storeinventory.model.code.Code
import com.wekanmdb.storeinventory.model.patient.Patient
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class ProfileViewModel@Inject constructor() : BaseViewModel<ProfileNavigator>() {
    val patientResponseBody = MutableLiveData<Patient?>()
    fun getPatientInfo(id: ObjectId) {
        val patientInfo = apprealm?.where<Patient>()?.equalTo("_id",id)?.findFirst()
        if (patientInfo != null) {
                patientResponseBody.postValue(patientInfo)
            } else {
                patientResponseBody.value = null
            }
        Log.e("msg",patientInfo.toString())
    }

}