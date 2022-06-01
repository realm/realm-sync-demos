package com.wekanmdb.storeinventory.ui.search

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.code.Code
import com.wekanmdb.storeinventory.model.condition.Condition
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class SearchActivityViewModel @Inject constructor() : BaseViewModel<SearchNavigator>() {


    val conditionsresponseBody = MutableLiveData<RealmResults<Code>?>()
    val concernResponseBody = MutableLiveData<RealmResults<Condition>?>()
    var specialityList: RealmResults<Code>? = null

    //Getting the conditions from the code by equals the conditions
    fun getAllConditions() {
        if (apprealm != null && apprealm?.isClosed == false) {
            /*
            * Selecting All conditions from Code master collection*/
            specialityList = apprealm?.where<Code>()?.equalTo("category", "conditions")?.findAll()
            specialityList?.addChangeListener { orgList ->
                if (orgList.isNotEmpty()) {
                    conditionsresponseBody.postValue(specialityList)
                } else {
                    conditionsresponseBody.value = null
                }
            }
            if (specialityList?.isNotEmpty()!!) {
                conditionsresponseBody.postValue(specialityList)
            } else {
                conditionsresponseBody.value = null
            }
        }
    }

    //get condition based on patient id
    fun getAllConcerns() {
        if (apprealm != null && apprealm?.isClosed == false) {
            /*
            * Selecting All conditions from Condition master collection */
            val id = user?.customData?.get("referenceId") as ObjectId

            val consultationList =
                apprealm?.where<Condition>()?.equalTo("subject.identifier", id)?.findAll()
            consultationList?.addChangeListener { orgList ->
                if (orgList.isNotEmpty()) {
                    concernResponseBody.postValue(consultationList)
                } else {
                    concernResponseBody.value = null
                }
            }
            if (consultationList?.isNotEmpty()!!) {
                concernResponseBody.postValue(consultationList)
            } else {
                concernResponseBody.value = null
            }
        }
    }

}


