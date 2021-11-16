package com.wekanmdb.storeinventory.ui.editjobs

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.model.user.Users
import io.realm.RealmChangeListener
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class JobDetailsViewModel @Inject constructor()  : BaseViewModel<JobDetailsNavigator>() {
    /**
     * method to get current user logged in the app
     * to get different fields to use in Job details screen.
     */
    private val _jobUpdateStatus = MutableLiveData<String>()
    val jobUpdateStatus : MutableLiveData<String> = _jobUpdateStatus

    private val _assigneeUpdate = MutableLiveData<String>()
    val assigneeUpdate : MutableLiveData<String> = _assigneeUpdate

    fun getCurrentUser(userId: ObjectId) : MutableLiveData<Users> {
        val responseBody = MutableLiveData<Users>()
        val openTasks = apprealm?.where<Users>()?.equalTo("_id", userId)?.findAllAsync()
        openTasks?.addChangeListener(
            RealmChangeListener<RealmResults<Users>> {
                if (it.isNotEmpty()) {
                    val user : Users? = it[0]
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
    fun getCurrentJobDetails(jobId: ObjectId) : MutableLiveData<Jobs> {
        val responseBody = MutableLiveData<Jobs>()
        val openTasks = apprealm?.where<Jobs>()?.equalTo("_id", jobId)?.findAllAsync()
        openTasks?.addChangeListener(
            RealmChangeListener<RealmResults<Jobs>> {
                if (it.isNotEmpty()) {
                    val job : Jobs? = it[0]
                    responseBody.postValue(job!!)
                }
            }
        )
        return responseBody
    }

    /**
     * To get the details of Assignees for the Job.
     */
    fun getAssignees(userId:ObjectId) : MutableLiveData<Users>{
        val responseBody = MutableLiveData<Users>()
        val openTasks = apprealm?.where<Users>()?.equalTo("_id", userId)?.findAllAsync()
        openTasks?.addChangeListener(
            RealmChangeListener<RealmResults<Users>> {
                if (it.isNotEmpty()) {
                    val user : Users? = it[0]
                    responseBody.postValue(user!!)
                }
            }
        )
        return responseBody
    }

    /**
     * Store admin can update the Assignee when the Jo status is Open(to-do) only.
     */
    fun upDateJobAssignee(currentJob: Jobs?, reassignedTo: Users?):MutableLiveData<Boolean> {
        val response = MutableLiveData<Boolean>()
        try {
            apprealm?.executeTransaction() {
                currentJob?.assignedTo = reassignedTo
                response.postValue(true)
            }
        }
        catch (e:Exception){
            response.postValue(false)
            assigneeUpdate.postValue(e.localizedMessage)
        }

      return response
    }

    /**
     * Delivery User can update job status until the Job is Done.
     */
    fun updateJobStatus(currentJob: Jobs?, jobStatus: String) :MutableLiveData<Boolean> {
        val response = MutableLiveData<Boolean>()
        try {
            apprealm?.executeTransaction() {
                currentJob?.status = jobStatus
                response.postValue(true)
            }
        }
        catch (e:Exception){
            response.postValue(false)
            _jobUpdateStatus.postValue(e.localizedMessage)
        }

        return response
    }


}