package com.wekanmdb.storeinventory.ui.createjobs

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.model.job.ProductQuantity
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.model.user.Users
import com.wekanmdb.storeinventory.utils.Constants.Companion.DELIVERY
import com.wekanmdb.storeinventory.utils.Constants.Companion.JOB_OPEN
import io.realm.RealmChangeListener
import io.realm.RealmList
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import java.util.*
import javax.inject.Inject

class CreateJobViewModel @Inject constructor() : BaseViewModel<CreateJobNavigator>() {

    lateinit var job : Jobs
    private val _jobCreatedStatus = MutableLiveData<String>()
    val jobCreatedStatus : MutableLiveData<String> = _jobCreatedStatus

    /**
     * This method to fetch the Store object which is used to create Job.
     */
    fun getStore(storeId: ObjectId?): MutableLiveData<Stores?> {
        val responseBody = MutableLiveData<Stores?>()
        try {
            val openTasks = apprealm?.where<Stores>()?.equalTo("_id", storeId)?.findAllAsync()
            openTasks?.addChangeListener(
                RealmChangeListener<RealmResults<Stores>> {
                    if (it.isNotEmpty()) {
                        val store: Stores? = it[0]
                        responseBody.postValue(store!!)
                    } else {
                        responseBody.value = null
                    }
                }
            )
        }
        catch (e:Exception){
            responseBody.value = null
        }
        return responseBody
    }

    /**
     * This getAssignee method is used to fetch Delivery Users to assign to Job.
     */
    fun getAssignees(userId:ObjectId) : MutableLiveData<Users>{
        val responseBody = MutableLiveData<Users>()
        try {
            val openTasks = apprealm?.where<Users>()?.equalTo("_id", userId)?.findAll()

                        val user: Users? = openTasks?.get(0)
                        responseBody.postValue(user!!)

        }
        catch (e:Exception){
            e.localizedMessage
        }
        return responseBody
    }

    /**
     * This method is to create Job with all the required objects.
     * and after successfully creating Job returning true (Boolean).
     */
    fun createJob(
        createdBy: Users,
        assignedTo: Users,
        sourceStore: Stores,
        destinationStore: Stores,
        pickupDatetime: Date,
        products: RealmList<ProductQuantity>
    ) : MutableLiveData<Boolean> {
          val response = MutableLiveData<Boolean>()
        try {


            apprealm?.executeTransaction() {
                job = Jobs()
                job._partition = "master"
                job.status = JOB_OPEN
                job.createdBy = createdBy
                job.assignedTo = assignedTo
                job.sourceStore = sourceStore
                job.destinationStore = destinationStore
                job.datetime = pickupDatetime
                job.products = products
                job.type = DELIVERY
                it.insertOrUpdate(job)
                response.postValue(true)
            }
        }
        catch (e:Exception){
            response.postValue(false)
            _jobCreatedStatus.postValue(e.localizedMessage)
        }
        return response

    }
    /**
     * This method is to create Job from orders with all the required objects.
     * and after successfully creating Job from orders  returning true (Boolean).
     */
    fun createJobFromOrder(
        createdBy: Users,
        assignedTo: Users,
        sourceStore: Stores,
        pickupDatetime: Date,
        products: RealmList<ProductQuantity>,
        orderId: ObjectId,
        jobType: String,
        dropStore: Stores?
    ) : MutableLiveData<Boolean> {
        val response = MutableLiveData<Boolean>()
        try {
            val getorderJobs = apprealm?.where<Jobs>()?.equalTo("order", orderId)?.equalTo("type", jobType)?.equalTo("sourceStore._id", sourceStore._id)?.findAll()
            if(getorderJobs.isNullOrEmpty()) {
                apprealm?.executeTransaction() {
                    job = Jobs()
                    job._partition = "master"
                    job.status = JOB_OPEN
                    job.createdBy = createdBy
                    job.assignedTo = assignedTo
                    job.sourceStore = sourceStore
                    job.datetime = pickupDatetime
                    job.products = products
                    job.order = orderId
                    job.type = jobType
                    job.destinationStore = dropStore
                    it.insert(job)
                    response.postValue(true)
                }
            }else{
                response.postValue(false)
            }
        }
        catch (e:Exception){
            response.postValue(false)
            _jobCreatedStatus.postValue(e.localizedMessage)
        }
        return response

    }

}