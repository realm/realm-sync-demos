package com.wekanmdb.storeinventory.ui.listOfHospitals

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.organization.Organization
import io.realm.RealmResults
import io.realm.kotlin.where
import javax.inject.Inject

class ListOfHospitalViewModel @Inject constructor() : BaseViewModel<ListOfHospitalNavigator>() {
    val hospitalListResponseBody = MutableLiveData<RealmResults<Organization>?>()

    //Getting List of Hospitals
    fun getListOfHospitals() {
        val hospitalList = apprealm?.where<Organization>()?.findAll()
        hospitalList?.addChangeListener { result ->
            if (result.isNotEmpty()) {
                hospitalListResponseBody.postValue(hospitalList)
            } else {
                hospitalListResponseBody.value = hospitalList
            }
        }
        if (hospitalList?.isNotEmpty() == true) {
            hospitalListResponseBody.postValue(hospitalList)
        } else {
            hospitalListResponseBody.value = hospitalList
        }
    }
}