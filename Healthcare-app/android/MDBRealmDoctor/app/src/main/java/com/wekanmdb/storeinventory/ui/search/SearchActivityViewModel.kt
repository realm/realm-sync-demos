package com.wekanmdb.storeinventory.ui.search

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.code.Code
import com.wekanmdb.storeinventory.model.organization.Organization
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import com.wekanmdb.storeinventory.ui.home.HomeActivity.Companion.orgId
import com.wekanmdb.storeinventory.utils.Constants.Companion.NURSE
import io.realm.RealmResults
import io.realm.kotlin.where
import javax.inject.Inject

class SearchActivityViewModel @Inject constructor() : BaseViewModel<SearchNavigator>() {
    /**
     * To search stores in the search activity.
     */
    val organizationresponseBody = MutableLiveData<RealmResults<Organization>?>()
    var organizationList: RealmResults<Organization>? = null

    val specialityresponseBody = MutableLiveData<RealmResults<Code>?>()
    val practitionerresponseBody = MutableLiveData<RealmResults<PractitionerRole>?>()
    var practitionerList: RealmResults<PractitionerRole>? = null
    var specialityList: RealmResults<Code>? = null

    fun getAllOrganization() {

        if (apprealm != null && apprealm?.isClosed == false) {
            /*
            * Selecting All organization from Organization master collection*/
            organizationList = apprealm?.where<Organization>()?.findAll()
            organizationList?.addChangeListener { orgList ->
                if (orgList.isNotEmpty()) {
                    organizationresponseBody.postValue(organizationList)
                } else {
                    organizationresponseBody.value = null
                }
            }
            if (organizationList?.isNotEmpty()!!) {
                organizationresponseBody.postValue(organizationList)
            } else {
                organizationresponseBody.value = null
            }
        }
    }

    fun getAllSpeciality(category: String) {

        if (apprealm != null && apprealm?.isClosed == false) {
            /*
            * Selecting All speciality from Code master collection*/
            specialityList = apprealm?.where<Code>()?.equalTo("category", category)?.findAll()
            specialityList?.addChangeListener { orgList ->
                if (orgList.isNotEmpty()) {
                    specialityresponseBody.postValue(specialityList)
                } else {
                    specialityresponseBody.value = null
                }
            }
            if (specialityList?.isNotEmpty()!!) {
                specialityresponseBody.postValue(specialityList)
            } else {
                specialityresponseBody.value = null
            }
        }
    }

    fun getAllPractitioner() {

        if (apprealm != null && apprealm?.isClosed == false) {
            /*
            * Selecting All speciality from Code master collection*/
            practitionerList = apprealm?.where<PractitionerRole>()
                ?.equalTo("organization._id", orgId)?.equalTo("code.coding.code", NURSE)?.findAll()
            practitionerList?.addChangeListener { orgList ->
                if (orgList.isNotEmpty()) {
                    practitionerresponseBody.postValue(practitionerList)
                } else {
                    practitionerresponseBody.value = null
                }
            }
            if (practitionerList?.isNotEmpty()!!) {
                practitionerresponseBody.postValue(practitionerList)
            } else {
                practitionerresponseBody.value = null
            }
        }
    }


}


