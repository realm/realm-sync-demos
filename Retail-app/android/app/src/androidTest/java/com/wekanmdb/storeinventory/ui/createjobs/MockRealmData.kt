package com.wekanmdb.storeinventory.ui.createjobs

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.storerealm
import com.wekanmdb.storeinventory.data.AppConstants
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.model.job.ProductQuantity
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.model.storeInventory.StoreInventory
import com.wekanmdb.storeinventory.model.user.Users
import com.wekanmdb.storeinventory.utils.Constants
import io.realm.RealmList
import org.bson.types.ObjectId
import java.util.*
import java.util.concurrent.CountDownLatch

/**
 * Test util class to test realm query
 * These are mock data to play around with in memory realm.
 */
object MockRealmData {
     fun createDemoStore() {
         var storeId : ObjectId ? = null
        apprealm?.executeTransaction(){
            var store = Stores()
            store._partition="master"
            store.address="testAddress"
            store.name = "testStore"
            it.insert(store)
        }

    }

     fun createDemoInventory(storeId: ObjectId?) {
        storerealm?.executeTransaction(){
            var storeInventory = StoreInventory()
            storeInventory.storeId=storeId
            storeInventory._partition= AppConstants.INVENTORYPARTITIONVALUE
            storeInventory.image=""
            storeInventory.productId= ObjectId()
            storeInventory.productName="testProduct"
            storeInventory.quantity=2
            it.insert(storeInventory)
        }
    }

    fun createDemoAssignee(){
        apprealm?.executeTransaction(){
            var user = Users()
            user._partition="master"
            user.customDataId=""
            user.email = "abc@demo.com"
            user.firstName="demo"
            user.lastName="delivery"
            user.stores= Stores()
            user.userRole= Constants.DELIVERY_USER_ROLE
            it.insert(user)
        }
    }
    fun createDummyJob(): MutableLiveData<Jobs> {
        var response = MutableLiveData<Jobs>()
        apprealm?.executeTransaction(){
            var job = Jobs()
            job._partition="master"
            job.status = Constants.JOB_OPEN
            job.createdBy = Users()
            job.assignedTo = Users()
            job.sourceStore = Stores()
            job.destinationStore = Stores()
            job.pickupDatetime = Date()
            job.products = RealmList<ProductQuantity>()
            it.insert(job)
            response.postValue(job)
        }
        return response
    }
}