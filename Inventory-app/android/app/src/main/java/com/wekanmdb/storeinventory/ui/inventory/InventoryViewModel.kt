package com.wekanmdb.storeinventory.ui.inventory

import androidx.databinding.ObservableField
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.storerealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.model.storeInventory.StoreInventory
import io.realm.Case
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
    val inventoryresponseBody = MutableLiveData<RealmResults<StoreInventory>?>()

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

    fun getInventoryList() {
        val storeId = ObjectId(storeId.get().toString())
        storeInventoryList = storerealm?.where<StoreInventory>()?.equalTo("storeId", storeId)?.sort("productName")?.findAll()
        if (storeInventoryList!!.size > 0) {
            inventoryresponseBody.postValue(storeInventoryList)
        } else {
            inventoryresponseBody.value = null
        }

    }

    fun inventoryListener() {
        storeInventoryList?.addChangeListener({ inventoryList ->
            if (inventoryList.size > 0) {
                inventoryresponseBody.postValue(inventoryList)
            } else {
                inventoryresponseBody.value = null
            }
        })
    }

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