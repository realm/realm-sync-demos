package com.wekanmdb.storeinventory.ui.deliveryjob

import androidx.databinding.ObservableField
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.model.orders.Orders
import com.wekanmdb.storeinventory.model.user.Users
import io.realm.RealmResults
import io.realm.Sort
import io.realm.kotlin.where
import org.bson.types.ObjectId
import java.util.*
import javax.inject.Inject

class DeliveryJobViewModel @Inject constructor() : BaseViewModel<DeliveryJobNavigator>() {
    var userId: ObservableField<String> = ObservableField("")
    val jobresponseBody = MutableLiveData<RealmResults<Jobs>?>()
    var jobsList: RealmResults<Jobs>? = null
    /**
     * This function gives the job details based on job status
     */
    fun getDeliveryJob(status:String) {
        val objectId = ObjectId(userId.get().toString())
        val calendar = Calendar.getInstance()

        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)

        jobsList = apprealm?.where<Jobs>()?.equalTo("${Jobs::assignedTo.name}.${Users::_id.name}", objectId)?.greaterThan(Jobs::datetime.name, calendar.time)?.equalTo(Jobs::status.name,status)?.sort(Jobs::datetime.name, Sort.ASCENDING)?.findAll()
        if (!jobsList.isNullOrEmpty()) {
            jobresponseBody.postValue(jobsList)
        } else {
            jobresponseBody.value = null
        }

    }

    fun jobListener() {
        jobsList?.addChangeListener { inventoryList ->
            if (inventoryList.size > 0) {
                jobresponseBody.postValue(inventoryList)
            } else {
                jobresponseBody.value = null
            }
        }
    }
    /**
     * This getOrderInfo method is used to fetch Delivery order info to view Job.
     */
    fun getOrderInfo(orderId: ObjectId) : String? {
        var order: Orders?=null
        try {
            val openTasks = apprealm?.where<Orders>()?.equalTo("_id", orderId)?.findFirst()

            order = openTasks

        }
        catch (e:Exception){
            e.localizedMessage
        }
        return order!!.type!!.address
    }
}
