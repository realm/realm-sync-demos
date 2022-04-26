package com.wekanmdb.storeinventory.ui.orders

import androidx.databinding.ObservableField
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.model.orders.Orders
import com.wekanmdb.storeinventory.model.store.Stores
import io.realm.RealmResults
import io.realm.Sort
import io.realm.kotlin.where
import org.bson.types.ObjectId
import java.util.*
import javax.inject.Inject

class OrdersViewModel @Inject constructor() : BaseViewModel<OrdersNavigator>() {
    var storeId: ObservableField<String> = ObservableField("")
    var userId: ObservableField<String> = ObservableField("")
    var storesItemList: RealmResults<Stores>? = null
    val storesresponseBody = MutableLiveData<Stores?>()
    val ordersresponseBody = MutableLiveData<RealmResults<Orders>?>()
    var ordersList: RealmResults<Orders>? = null

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
        storesItemList?.addChangeListener { storedetails ->
            if (storedetails.isNotEmpty()) {
                val store: Stores? = storedetails[0]
                storesresponseBody.postValue(store!!)
            } else {
                storesresponseBody.value = null
            }
        }
    }


    fun getOrderList() {
        val userId = ObjectId(userId.get().toString())
        val calendar = Calendar.getInstance()

        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        ordersList = apprealm?.where<Orders>()?.equalTo("createdBy._id", userId)?.greaterThan("createdDate", calendar.time)?.sort("createdDate", Sort.ASCENDING)?.findAll()
            if (ordersList?.size!!>0) {
                ordersresponseBody.postValue(ordersList)
            } else {
                ordersresponseBody.value = null
            }
    }

    fun jobListener() {
        ordersList?.addChangeListener { jobList ->
            if (jobList.size > 0) {
                ordersresponseBody.postValue(jobList)
            } else {
                ordersresponseBody.value = null
            }
        }
    }

    fun deleteOrder(orderId: String?): MutableLiveData<Boolean> {
        val response = MutableLiveData<Boolean>()
        try {
            if (apprealm != null && !apprealm!!.isClosed) {

                apprealm?.executeTransaction {
                    apprealm!!.where<Jobs>().equalTo(Jobs::order.name, ObjectId(orderId))?.findFirst()
                        ?.deleteFromRealm()
                    apprealm!!.where<Orders>().equalTo("_id", ObjectId(orderId))?.findFirst()
                        ?.deleteFromRealm()


                    response.postValue(true)
                }
            }
        } catch (e: Exception) {
            response.postValue(false)
        }
        return response

    }
    fun addJobClick() {
        navigator.addJobClick()
    }
}