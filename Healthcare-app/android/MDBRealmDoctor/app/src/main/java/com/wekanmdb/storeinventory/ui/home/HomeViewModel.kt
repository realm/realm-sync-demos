package com.wekanmdb.storeinventory.ui.home

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import io.realm.Case
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class HomeViewModel @Inject constructor():BaseViewModel<HomeNavigator>() {
    /**
     * This getOrganization  method is used to fetch Organization list info to view.
     */
    val practitionerRoleresponseBody = MutableLiveData<List<PractitionerRole>?>()
    var practitionerList: RealmResults<PractitionerRole>? = null

    fun getPracctitionerRole(id: ObjectId) {
        if (apprealm != null && apprealm?.isClosed == false) {
            /*
            * Selecting All organization from Organization master collection*/
            practitionerList = apprealm?.where<PractitionerRole>()?.equalTo("practitioner._id", id)?.findAll()
            practitionerList?.addChangeListener { result ->
                if (result.isNotEmpty()) {
                    practitionerRoleresponseBody.postValue(apprealm!!.copyFromRealm(practitionerList))
                } else {
                    practitionerRoleresponseBody.value = null
                }
            }
            if (practitionerList?.isNotEmpty()!!) {
                practitionerRoleresponseBody.postValue(apprealm!!.copyFromRealm(practitionerList))
            } else {
                practitionerRoleresponseBody.value = null
            }
        }
    }

}