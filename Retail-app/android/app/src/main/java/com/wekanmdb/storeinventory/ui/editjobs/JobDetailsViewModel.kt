package com.wekanmdb.storeinventory.ui.editjobs

import android.util.Log
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.data.AppConstants
import com.wekanmdb.storeinventory.model.job.Job_Location
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.model.orders.Order_Location
import com.wekanmdb.storeinventory.model.orders.Orders
import com.wekanmdb.storeinventory.model.storeInventory.StoreInventory
import com.wekanmdb.storeinventory.model.user.Users
import com.wekanmdb.storeinventory.utils.Constants.Companion.JOB_COMPLETED
import com.wekanmdb.storeinventory.utils.Constants.Companion.JOB_PROGRESS
import com.wekanmdb.storeinventory.utils.RealmUtils
import io.realm.Realm
import io.realm.RealmChangeListener
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class JobDetailsViewModel @Inject constructor() : BaseViewModel<JobDetailsNavigator>() {
    /**
     * method to get current user logged in the app
     * to get different fields to use in Job details screen.
     */
    private val _jobUpdateStatus = MutableLiveData<String>()
    val jobUpdateStatus: MutableLiveData<String> = _jobUpdateStatus

    private val _assigneeUpdate = MutableLiveData<String>()
    val assigneeUpdate: MutableLiveData<String> = _assigneeUpdate

    fun getCurrentUser(userId: ObjectId): MutableLiveData<Users> {
        val responseBody = MutableLiveData<Users>()
        val openTasks = apprealm?.where<Users>()?.equalTo("_id", userId)?.findAllAsync()
        openTasks?.addChangeListener(
            RealmChangeListener<RealmResults<Users>> {
                if (it.isNotEmpty()) {
                    val user: Users? = it[0]
                    responseBody.postValue(user!!)
                }
            }
        )
        return responseBody
    }

    /**
     * To get the current Job object and showing it's status
     * and other fields in Job details screen.
     */
    fun getCurrentJobDetails(jobId: ObjectId): MutableLiveData<Jobs> {
        val responseBody = MutableLiveData<Jobs>()
        val openTasks = apprealm?.where<Jobs>()?.equalTo("_id", jobId)?.findAllAsync()
        openTasks?.addChangeListener(
            RealmChangeListener<RealmResults<Jobs>> {
                if (it.isNotEmpty()) {
                    val job: Jobs? = it[0]
                    responseBody.postValue(job!!)
                }
            }
        )
        return responseBody
    }

    /**
     * To get the details of Assignees for the Job.
     */
    fun getAssignees(userId: ObjectId): MutableLiveData<Users> {
        val responseBody = MutableLiveData<Users>()
        val openTasks = apprealm?.where<Users>()?.equalTo("_id", userId)?.findAllAsync()
        openTasks?.addChangeListener(
            RealmChangeListener<RealmResults<Users>> {
                if (it.isNotEmpty()) {
                    val user: Users? = it[0]
                    responseBody.postValue(user!!)
                }
            }
        )
        return responseBody
    }

    /**
     * Store admin can update the Assignee when the Jo status is Open(to-do) only.
     */
    fun upDateJobAssignee(currentJob: Jobs?, reassignedTo: Users?): MutableLiveData<Boolean> {
        val response = MutableLiveData<Boolean>()
        try {
            apprealm?.executeTransaction() {
                currentJob?.assignedTo = reassignedTo
                response.postValue(true)
            }
        } catch (e: Exception) {
            response.postValue(false)
            assigneeUpdate.postValue(e.localizedMessage)
        }

        return response
    }

    /**
     * Delivery User can update job status until the Job is Done.
     */
    fun updateJobStatus(
        currentJob: Jobs?,
        jobStatus: String,
        inprogress_to_todo: Boolean,
        receivedBy: String
    ): MutableLiveData<Boolean> {
        val response = MutableLiveData<Boolean>()
        try {
            apprealm?.executeTransaction() {
                currentJob?.status = jobStatus
                currentJob?.receivedBy = receivedBy

            }
            if (inprogress_to_todo) {
                /**
                 * Creating realm instance for the source store.
                 * Delivery User update job status from In-progress to DOTO state We are adding the reduced Store inventory stock .
                 *
                 */
                Realm.getInstanceAsync(
                    RealmUtils.getRealmconfig(
                        AppConstants.INVENTORYPARTITIONVALUE + currentJob!!.sourceStore!!._id.toString()
                    ), object : Realm.Callback() {
                        override fun onSuccess(realm: Realm) {
                            realm.executeTransaction { it ->
                                val inventry = it.where(StoreInventory::class.java)
                                    ?.equalTo(
                                        StoreInventory::storeId.name,
                                        currentJob.sourceStore!!._id
                                    )?.findAll()
                                if (inventry != null) {
                                    currentJob.products.forEach { productQty ->
                                        val storeInventory =
                                            inventry.find { it.productId == productQty.product!!._id }
                                        if (storeInventory != null) {
                                            storeInventory.quantity = storeInventory.quantity?.plus(
                                                productQty.quantity
                                            )
                                        }
                                    }
                                }
                            }
                            realm.close()
                        }
                    })

            } else if (jobStatus == JOB_PROGRESS) {
                /**
                 * Creating realm instance for the source store.
                 * Delivery User update job status from  DOTO to In-progress state We are reducing Store inventory stock .
                 *
                 */
                Realm.getInstanceAsync(
                    RealmUtils.getRealmconfig(
                        AppConstants.INVENTORYPARTITIONVALUE + currentJob!!.sourceStore!!._id.toString()
                    ), object : Realm.Callback() {
                        override fun onSuccess(realm: Realm) {
                            realm.executeTransaction { it ->
                                val inventry = it.where(StoreInventory::class.java)
                                    ?.equalTo(
                                        StoreInventory::storeId.name,
                                        currentJob.sourceStore!!._id
                                    )?.findAll()
                                if (inventry != null) {
                                    currentJob.products.forEach { productQty ->
                                        val storeInventory =
                                            inventry.find { it.productId == productQty.product!!._id }
                                        if (storeInventory != null) {
                                            storeInventory.quantity =
                                                storeInventory.quantity?.minus(
                                                    productQty.quantity
                                                )
                                        }
                                    }
                                }
                            }
                            realm.close()
                        }
                    })

            } else if (jobStatus == JOB_COMPLETED && currentJob!!.destinationStore != null) {

                /**
                 * Creating realm instance for the destination store.
                 * Delivery User update job status from  In-progress  to done state We are adding destination Store inventory stock .
                 *
                 */
                Realm.getInstanceAsync(
                    RealmUtils.getRealmconfig(
                        AppConstants.INVENTORYPARTITIONVALUE + currentJob!!.destinationStore!!._id.toString()
                    ), object : Realm.Callback() {
                        override fun onSuccess(realm: Realm) {
                            realm.executeTransaction { it ->
                                val inventry = it.where(StoreInventory::class.java)
                                    ?.equalTo(
                                        StoreInventory::storeId.name,
                                        currentJob.destinationStore!!._id
                                    )?.findAll()
                                if (!inventry.isNullOrEmpty()) {
                                    currentJob.products.forEach { productQty ->
                                        val storeInventory =
                                            inventry.find { it.productId == productQty.product!!._id }
                                        if (storeInventory != null) {
                                            storeInventory.quantity = storeInventory.quantity?.plus(
                                                productQty.quantity
                                            )
                                        } else {
                                            /**
                                             * If the inventory not available in the destination store inserting the new store inventory.
                                             *
                                             */
                                            currentJob.products.forEach { productQty ->
                                                val storeInventry = StoreInventory()
                                                storeInventry.image = productQty.product!!.image
                                                storeInventry.productId = productQty.product!!._id
                                                storeInventry.productName =
                                                    productQty.product!!.name
                                                storeInventry.quantity = productQty.quantity
                                                storeInventry.storeId =
                                                    currentJob.destinationStore!!._id
                                                storeInventry._partition =
                                                    "store=${currentJob.destinationStore!!._id}"
                                                it.insertOrUpdate(storeInventry)
                                            }
                                        }
                                    }
                                } else {
                                    /**
                                     * If the inventory not available in the destination store inserting the new store inventory.
                                     *
                                     */
                                    currentJob.products.forEach { productQty ->
                                        val storeInventry = StoreInventory()
                                        storeInventry.image = productQty.product!!.image
                                        storeInventry.productId = productQty.product!!._id
                                        storeInventry.productName = productQty.product!!.name
                                        storeInventry.quantity = productQty.quantity
                                        storeInventry.storeId = currentJob.destinationStore!!._id
                                        storeInventry._partition = "store=${currentJob.destinationStore!!._id}"
                                        it.insertOrUpdate(storeInventry)
                                    }

                                }
                            }
                            realm.close()
                        }
                    })

            }
            response.postValue(true)
        } catch (e: Exception) {
            response.postValue(false)
            _jobUpdateStatus.postValue(e.localizedMessage)
        }

        return response
    }

    fun updateLocation(
        currentJob: Jobs?,
        latitude: Double,
        longitude: Double
    ): MutableLiveData<Boolean> {
        val response = MutableLiveData<Boolean>()
        try {
            apprealm?.executeTransaction() {
                currentJob?.location = Job_Location(
                    latitude = latitude,
                    longitude = longitude
                )
            }
            response.postValue(true)
        } catch (e: Exception) {
            assigneeUpdate.postValue(e.localizedMessage)
        }
        return response
    }

    /**
     * This getOrderInfo method is used to fetch Delivery order info to view Job.
     */
    fun getOrderInfo(userId: ObjectId): String? {
        var order: Orders? = null
        try {
            val openTasks = apprealm?.where<Orders>()?.equalTo("_id", userId)?.findFirst()

            order = openTasks

        } catch (e: Exception) {
            e.localizedMessage
        }
        return order!!.type!!.address
    }
}