package com.wekanmdb.storeinventory.ui.deliveryjob

import androidx.databinding.ObservableField
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.job.Jobs
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

    fun getDeliveryJob() {
        val objectId = ObjectId(userId.get().toString())
        val calendar = Calendar.getInstance()

        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)

        jobsList = apprealm?.where<Jobs>()?.equalTo("assignedTo._id", objectId)?.greaterThan("pickupDatetime", calendar.time)?.sort("pickupDatetime", Sort.ASCENDING)?.findAll()
        if (jobsList?.size!! > 0) {
            jobresponseBody.postValue(jobsList)
        } else {
            jobresponseBody.value = null
        }

    }

    fun jobListener() {
        jobsList?.addChangeListener({ inventoryList ->
            if (inventoryList.size > 0) {
                jobresponseBody.postValue(inventoryList)
            } else {
                jobresponseBody.value = null
            }
        })
    }

}
