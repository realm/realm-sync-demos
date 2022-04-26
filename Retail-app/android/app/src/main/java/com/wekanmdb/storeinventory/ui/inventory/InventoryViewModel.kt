package com.wekanmdb.storeinventory.ui.inventory

import androidx.databinding.ObservableField
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.storerealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.model.storeInventory.StoreInventory
import com.wekanmdb.storeinventory.model.user.Users
import io.realm.Case
import io.realm.RealmList
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class InventoryViewModel @Inject constructor() : BaseViewModel<InventoryNavigator>() {
    var storeId: ObservableField<String> = ObservableField("")
    var searchproductName: ObservableField<String> = ObservableField("")
    var storeInventoryList: RealmResults<StoreInventory>? = null
    var storesItemList: RealmResults<Stores>? = null
    val storesresponseBody = MutableLiveData<Stores?>()
    val storesList = MutableLiveData<RealmList<Stores>>()
    val inventoryresponseBody = MutableLiveData<RealmResults<StoreInventory>?>()
    /**
     * This method will gives the store details based on StoreID
     */
    fun getStore(storedetails: Stores) {
        if(apprealm != null && apprealm?.isClosed == false) {
            storesItemList = apprealm?.where<Stores>()?.equalTo("_id", storedetails._id)?.findAll()
            if (storesItemList?.isNotEmpty()!!) {
                val store: Stores? = storesItemList!![0]
                storesresponseBody.postValue(store!!)
            } else {
                storesresponseBody.value = null
            }
        }
    }
    /**
     * This method will gives the store list mapped to the user
     */
    fun getAllStores() {
        if(apprealm != null && apprealm?.isClosed == false) {
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
    /**
     * This method will gives the store inventory list based on storeID from StoreInventory collection
     */
    fun getInventoryList(storedetails: Stores) {
        storeInventoryList = storerealm?.where<StoreInventory>()?.equalTo("storeId", storedetails._id)?.sort("productName")?.findAll()
        if (!storeInventoryList.isNullOrEmpty()) {
            inventoryresponseBody.postValue(storeInventoryList)
        } else {
            inventoryresponseBody.value = null
        }

    }

    fun inventoryListener() {
        storeInventoryList?.addChangeListener { inventoryList ->
            if (inventoryList.size > 0) {
                inventoryresponseBody.postValue(inventoryList)
            } else {
                inventoryresponseBody.value = null
            }
        }
    }
    /**
     * This method will gives the store inventory list
     */
    fun getFilterSearch(): MutableLiveData<RealmResults<StoreInventory>?> {
        val responseBody = MutableLiveData<RealmResults<StoreInventory>?>()
        apprealm?.executeTransaction { transactionRealm ->
            val searchInventoryList =
                storerealm?.where<StoreInventory>()?.contains(
                    "productName",
                    searchproductName.get().toString(),
                    Case.INSENSITIVE
                )?.sort("productName")?.findAll()

            if (searchInventoryList != null) {
                responseBody.value = searchInventoryList
            } else {
                responseBody.value = null
            }
        }
        return responseBody
    }

    fun searchClick() {
        navigator.searchClick()
    }

}