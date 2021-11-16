package com.wekanmdb.storeinventory.ui.profile

import androidx.databinding.ObservableField
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.store.Stores
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

    var storesItemList: RealmResults<Stores>? = null
    val storesresponseBody = MutableLiveData<Stores?>()

    fun getStore() {
        val storeId = ObjectId(storeId.get().toString())
        storesItemList = apprealm?.where<Stores>()?.equalTo("_id", storeId)?.findAll()
        if (storesItemList?.isNotEmpty()!!) {
            val store: Stores? = storesItemList!![0]
            storesresponseBody.postValue(store!!)
        } else {
            storesresponseBody.value = null
        }
    }

    fun storeListener() {
        storesItemList?.addChangeListener({ storedetails ->
            if (storedetails.isNotEmpty()) {
                val store: Stores? = storedetails[0]
                storesresponseBody.postValue(store!!)
            } else {
                storesresponseBody.value = null
            }
        })
    }


    fun logoutClick() {
        navigator.logoutClick()
    }
}