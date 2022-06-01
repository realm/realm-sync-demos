package com.wekanmdb.storeinventory.ui.splash

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class SplashViewModel @Inject constructor(): BaseViewModel<SlashNavigator>() {

    val practitionerRoleresponseBody = MutableLiveData<RealmResults<PractitionerRole>?>()
    var practitionerList: RealmResults<PractitionerRole>? = null

    fun getPracctitionerRole(id: ObjectId) {
        if (apprealm != null && apprealm?.isClosed == false) {
            /*
            * Selecting All PractitionerRole from PractitionerRole master collection*/
            practitionerList = apprealm?.where<PractitionerRole>()?.equalTo("practitioner._id", id)?.findAll()
            practitionerList?.addChangeListener { result ->
                if (result.isNotEmpty()) {
                    practitionerRoleresponseBody.postValue(practitionerList)
                } else {
                    practitionerRoleresponseBody.value = null
                }
            }
            if (practitionerList?.isNotEmpty()!!) {
                practitionerRoleresponseBody.postValue(practitionerList)
            } else {
                practitionerRoleresponseBody.value = null
            }
        }
    }

}