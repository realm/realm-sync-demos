package com.wekanmdb.storeinventory.ui.profile

import androidx.databinding.ObservableField
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.model.user.Users
import io.realm.RealmList
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class ProfileViewModel@Inject constructor() : BaseViewModel<ProfileNavigator>() {
    var storeId: ObservableField<String> = ObservableField("")
    var firstName: ObservableField<String> = ObservableField("")
    var lastName: ObservableField<String> = ObservableField("")
    var email: ObservableField<String> = ObservableField("")
    var role: ObservableField<String> = ObservableField("")
    val storesList = MutableLiveData<RealmList<Stores>>()
    var storesItemList: RealmResults<Stores>? = null
    val storesresponseBody = MutableLiveData<Stores?>()

    fun getStore() {
        val storeId = ObjectId(storeId.get().toString())
        /* Fetching currently selected store info*/
        storesItemList = apprealm?.where<Stores>()?.equalTo("_id", storeId)?.findAll()
        if (storesItemList?.isNotEmpty()!!) {
            val store: Stores? = storesItemList!![0]
            storesresponseBody.postValue(store!!)
        } else {
            storesresponseBody.value = null
        }
    }
    fun getAllStores() {
        if(apprealm != null && apprealm?.isClosed == false) {
            /*Getting the users stores list*/
            val usersList=   apprealm?.where<Users>()?.equalTo("_id", ObjectId(user?.customData?.getString("_id")))?.findFirst()

            if (!usersList?.stores.isNullOrEmpty()) {
                storesList.postValue(usersList?.stores!!)

            }



        }
    }

    fun storeListener() {
        storesItemList?.addChangeListener { storedetails ->
            if (storedetails.isNotEmpty()) {
                val store: Stores? = storedetails[0]
                storesresponseBody.postValue(store!!)
            } else {
                storesresponseBody.value = null
            }
        }
    }


    fun logoutClick() {
        navigator.logoutClick()
    }
}