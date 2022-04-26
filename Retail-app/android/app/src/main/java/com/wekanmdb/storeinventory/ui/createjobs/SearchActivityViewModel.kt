package com.wekanmdb.storeinventory.ui.createjobs

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.storerealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.model.storeInventory.StoreInventory
import com.wekanmdb.storeinventory.model.user.Users
import com.wekanmdb.storeinventory.utils.Constants.Companion.DELIVERY_USER_ROLE
import io.realm.RealmChangeListener
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class SearchActivityViewModel @Inject constructor() : BaseViewModel<SearchNavigator>(){
    /**
     * To search stores in the search activity.
     */
    // variables for store search
    var responseBodyStores = MutableLiveData<RealmResults<Stores>?>()
    var storeList : RealmResults<Stores>?=null

    // variables for assignee search
    val responseBodyAssignees = MutableLiveData<RealmResults<Users>?>()
    var assigneeList : RealmResults<Users>?=null

    // variables for Inventory Product search
    var responseBodyInventoryList = MutableLiveData<RealmResults<StoreInventory>?>()
    var storeInventoryList : RealmResults<StoreInventory>?=null



    fun getStore(sourceStoreid:ObjectId): MutableLiveData<RealmResults<Stores>?> {
        try {
            storeList = apprealm?.where<Stores>()?.notEqualTo("_id",sourceStoreid)?.findAll()
            if(storeList?.isNotEmpty()!!){
                responseBodyStores.postValue(storeList!!)
            }
            else{
                responseBodyStores.postValue(null)
            }
        }
        catch (e:Exception){
            responseBodyStores.postValue(null)
        }
        return responseBodyStores
    }

    fun storeListListener(){
        try {
            storeList?.addChangeListener { storList ->
                if (storList.isNotEmpty()) {
                    responseBodyStores.postValue(storList!!)
                } else {
                    responseBodyStores.value = null
                }
            }
        }
        catch (e:Exception){
            e.localizedMessage
        }
    }

    /**
     * method to get all delivery users to assign to job.
     */
    fun getAssignees() : MutableLiveData<RealmResults<Users>?>{
        try {
            assigneeList = apprealm?.where<Users>()?.equalTo("userRole", DELIVERY_USER_ROLE)
                ?.findAll()
            if (assigneeList?.isNotEmpty()!!) {
                responseBodyAssignees.postValue(assigneeList!!)
            } else {
                responseBodyAssignees.postValue(null)
            }
        }
        catch (e:Exception){
            responseBodyAssignees.postValue(null)
        }

        return responseBodyAssignees
    }


    fun assigneeListListener(){
        try {
            assigneeList?.addChangeListener { assigneeList ->
                if (assigneeList.isNotEmpty()) {
                    responseBodyAssignees.postValue(assigneeList)
                } else {
                    responseBodyAssignees.value = null
                }
            }
        }
        catch (e:Exception){
            e.localizedMessage
        }
    }

    /**
     * Getting the products from Inventory store of the current store admin which to be
     * transit to another store (Destination Store).
     */
    fun getProducts(storeId: ObjectId): MutableLiveData<RealmResults<StoreInventory>?> {
       try {
           storeInventoryList =
               storerealm?.where<StoreInventory>()?.equalTo("storeId", storeId)?.sort("productName")
                   ?.findAll()

           if (storeInventoryList?.isNotEmpty()!!) {
               responseBodyInventoryList.postValue(storeInventoryList)
           } else {
               responseBodyInventoryList.postValue(null)
           }
       }
       catch (e:Exception){
           responseBodyInventoryList.postValue(null)
       }

        return responseBodyInventoryList
    }

    fun storeInventoryListListener(){
        try {

            storeInventoryList?.addChangeListener { invList ->
                if (invList.isNotEmpty()) {
                    responseBodyInventoryList.postValue(invList)
                } else {
                    responseBodyInventoryList.value = null
                }
            }
        }
        catch (e:Exception){
            e.localizedMessage
            responseBodyInventoryList.value = null
        }
    }


}


