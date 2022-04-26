package com.wekanmdb.storeinventory.ui.editjobs

import android.Manifest
import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.view.View
import android.widget.ArrayAdapter
import android.widget.Toast
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.model.job.ProductQuantity
import com.wekanmdb.storeinventory.model.user.Users
import com.wekanmdb.storeinventory.utils.Constants
import com.wekanmdb.storeinventory.utils.Constants.Companion.JOB_OPEN
import com.wekanmdb.storeinventory.utils.Constants.Companion.JOB_PROGRESS
import com.wekanmdb.storeinventory.utils.UiUtils.getDateYYYYmmDD
import com.wekanmdb.storeinventory.utils.UiUtils.getTimeAmPm
import io.realm.RealmList
import org.bson.types.ObjectId
import androidx.core.content.ContextCompat
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.*
import com.wekanmdb.storeinventory.databinding.ActivityDetailsJobDeliveryBinding
import com.wekanmdb.storeinventory.services.LocationService
import com.wekanmdb.storeinventory.services.LocationService.Companion.isServiceStarted
import com.wekanmdb.storeinventory.utils.Constants.Companion.JOB_COMPLETED
import kotlinx.android.synthetic.main.activity_details_job_delivery.*
import kotlinx.android.synthetic.main.common_toolbar.*
import kotlinx.android.synthetic.main.dialog_msg.*
import kotlinx.android.synthetic.main.dialog_status_option.*
import kotlinx.android.synthetic.main.dialog_status_option.done_btn
import java.util.*


/**
 * This activity is used to show JOB Details.
 * Store Admin User can Update Assignee for the Job if JOB is in open(to-do) status.
 * Delivery user can ony update Job status if it's status is not Done.
 *
 *
 */

open class DeliveryJobDetailsActivity : BaseActivity<ActivityDetailsJobDeliveryBinding>() {
    lateinit var activityDetailsJobBinding: ActivityDetailsJobDeliveryBinding
    private lateinit var jobDetailsAdapter: JobDetailsAdapter
    var currentUser: Users? = null
    var currentJob: Jobs? = null
    var mUserRole: String? = null
    var mJobStatus: String? = null
    var adapter: ArrayAdapter<String>? = null
    lateinit var jobDetailsViewModel: JobDetailsViewModel

    private val REQUEST_PERMISSION_LOCATION = 10

    override fun getLayoutId(): Int = R.layout.activity_details_job_delivery

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityDetailsJobBinding = mViewDataBinding as ActivityDetailsJobDeliveryBinding
        jobDetailsViewModel = ViewModelProvider(this, viewModelFactory).get(
            JobDetailsViewModel::class.java
        )
        activityDetailsJobBinding.jobDetailsViewModel = jobDetailsViewModel
        val jobId = intent.getStringExtra(Constants.JOB_ID)
        jobDetailsViewModel = ViewModelProvider(this).get(JobDetailsViewModel::class.java)
        val userId = user?.customData?.getString("_id")
        /**
         * getCurrentUser method gives the current logged in user.
         */
        getCurrentUser(ObjectId(userId))
        /**
         * getCurrentJob method gives the current job object which is passed to this activity.
         */
        getCurrentJob(ObjectId(jobId))
        jobDetailsAdapter = JobDetailsAdapter(this)
        activityDetailsJobBinding.listView.apply {
            layoutManager = LinearLayoutManager(this@DeliveryJobDetailsActivity)
            adapter = jobDetailsAdapter
        }

        //img_back.setTitle("Job Details")
        img_back.setOnClickListener {
            finish()
        }

        updateStatus.setOnClickListener {
            if (activityDetailsJobBinding.receivedBy.text.toString().trim().isEmpty()) {
                showMsgDialog("Enter Received by")
                return@setOnClickListener
            }
            currentJob?.status?.let { it1 -> updateStatusDialog(it1) }
        }

        initListener()
    }


    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_PERMISSION_LOCATION) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                isServiceStarted=true
                Intent(this, LocationService::class.java).also { intent ->
                    startService(intent)
                }
            } else {
                Toast.makeText(
                    this@DeliveryJobDetailsActivity,
                    "Permission Denied",
                    Toast.LENGTH_SHORT
                ).show()
            }
        }
    }

    private fun checkPermissionForLocation(context: Context): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {

            if (context.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) ==
                PackageManager.PERMISSION_GRANTED
            ) {
                true
            } else {
                // Show the permission request
                ActivityCompat.requestPermissions(
                    this, arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION),
                    REQUEST_PERMISSION_LOCATION
                )
                false
            }
        } else {
            true
        }
    }

    private fun initListener() {
        jobDetailsViewModel.jobUpdateStatus.observe(this) {
            showToast(it)
        }
        jobDetailsViewModel.assigneeUpdate.observe(this) {
            showToast(it)
        }
    }


    private fun updateJobAssignee(reassignedTo: Users?) {
        jobDetailsViewModel.upDateJobAssignee(currentJob, reassignedTo).observe(this) {
            if (it) {
                Toast.makeText(this, "Assignee Updated Successfully", Toast.LENGTH_SHORT).show()
            }
        }

    }

    private fun upDateJobStatus(jobStatus: String, inprogress_to_todo: Boolean) {
        jobDetailsViewModel.updateJobStatus(
            currentJob,
            jobStatus,
            inprogress_to_todo,
            activityDetailsJobBinding.receivedBy.text.toString()
        ).observe(this) {
            if (it) {
                showMsgDialog("Job Status Updated Successfully")
            }
        }
    }



    private fun getCurrentJob(jobId: ObjectId) {
        jobDetailsViewModel.getCurrentJobDetails(jobId).observe(this) {
            currentJob = it
            mJobStatus = it.status
            currentJob?.let { job -> initUiView(job) }
            currentJob?.let { job -> job.products }?.let { productList -> initJobDetailsAdapter(productList) }
        }
    }

    private fun initUiView(job: Jobs) {
        activityDetailsJobBinding.sourcestoreh.text = job.sourceStore?.name.toString()
            .capitalize(Locale.US)
        if (job.destinationStore == null) {
            activityDetailsJobBinding.destStoreTitle.text =
                resources.getString(R.string.drop_off_address)
            jobDetailsViewModel.getOrderInfo(job.order!!)
        } else {
            job.destinationStore?.name.toString()

        }.let {
            activityDetailsJobBinding.dropstoreh.text = it!!.capitalize(Locale.US)
        }
        activityDetailsJobBinding.dateh.text = getDateYYYYmmDD(job.datetime)
        activityDetailsJobBinding.timeh.text = getTimeAmPm(job.datetime)
        activityDetailsJobBinding.status.text = job.status
        if (job.status.equals("Done", ignoreCase = true)) {
            activityDetailsJobBinding.receivedBy.isEnabled = false
            activityDetailsJobBinding.updateStatus.visibility = View.INVISIBLE
            ContextCompat.getColor(this, R.color.green_dark)
        } else {
            ContextCompat.getColor(this, R.color.blue)
        }.let { activityDetailsJobBinding.status.setTextColor(it) }
        job.receivedBy?.let {
            activityDetailsJobBinding.receivedBy.setText(it)
        }
    }

    private fun getCurrentUser(userid: ObjectId) {
        jobDetailsViewModel.getCurrentUser(userid).observe(this) {
            currentUser = it
            mUserRole = it.userRole
        }
    }

    private fun initJobDetailsAdapter(productList: RealmList<ProductQuantity>) {


        jobDetailsAdapter.addData(productList)

    }

    private fun showMsgDialog(text: String) {
        val dialog = Dialog(this, R.style.dialog_center)
        dialog.setCancelable(true)
        dialog.setContentView(R.layout.dialog_msg)
        dialog.show()
        val msg = dialog.msg
        val ok_btn = dialog.ok_btn
        ok_btn.setOnClickListener {
            dialog.dismiss()
        }
        msg.text = text
    }

    // updateStatus function
    private fun updateStatusDialog(status: String) {
        var selectedStatus = status
        val dialoglogout = Dialog(this, R.style.dialog_center)
        dialoglogout.setCancelable(true)
        dialoglogout.setContentView(R.layout.dialog_status_option)
        dialoglogout.show()
        val optDone = dialoglogout.opt_done
        val optProgress = dialoglogout.opt_progress
        val optTodo = dialoglogout.opt_todo
        val done = dialoglogout.done_btn
        var inprogressToTodo = false
        when (selectedStatus) {
            JOB_OPEN -> {
                optProgress.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg)
                optDone.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg)
                optTodo.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg_selected)
                optTodo.setTextColor(ContextCompat.getColor(this,R.color.white))
                optProgress.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button),
                    null,
                    null,
                    null
                )
                optDone.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button),
                    null,
                    null,
                    null
                )
                optTodo.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button_selected),
                    null,
                    null,
                    null
                )
            }
            JOB_PROGRESS -> {
                optProgress.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg_selected)
                optDone.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg)
                optTodo.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg)
                optProgress.setTextColor(ContextCompat.getColor(this,R.color.white))
                optProgress.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button_selected),
                    null,
                    null,
                    null
                )
                optDone.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button),
                    null,
                    null,
                    null
                )
                optTodo.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button),
                    null,
                    null,
                    null
                )
            }
            JOB_COMPLETED -> {
                optProgress.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg)
                optDone.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg_selected)
                optTodo.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg)
                optDone.setTextColor(ContextCompat.getColor(this,R.color.white))
                optProgress.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button),
                    null,
                    null,
                    null
                )
                optDone.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button_selected),
                    null,
                    null,
                    null
                )
                optTodo.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button),
                    null,
                    null,
                    null
                )
            }
        }
        done.setOnClickListener {
            if (selectedStatus == status) {
                showToast("Please change the status.")
            } else {
                if (currentJob!!.destinationStore == null) {
                    if(checkPermissionForLocation(this)) {
                        if (selectedStatus == JOB_PROGRESS && !isServiceStarted) {
                            isServiceStarted = true
                            Intent(this, LocationService::class.java).also { intent ->
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                    startForegroundService(intent)
                                } else {
                                    startService(intent)
                                }
                            }
                        }
                        if (selectedStatus == JOB_COMPLETED) {
                            isServiceStarted = false
                            stopService(Intent(this, LocationService::class.java))

                        }
                        upDateJobStatus(selectedStatus, inprogressToTodo)
                        dialoglogout.dismiss()
                    }
                }else{
                    upDateJobStatus(selectedStatus, inprogressToTodo)
                    dialoglogout.dismiss()
                }
            }
        }
        optTodo.setOnClickListener {
            if (status == JOB_PROGRESS || status == JOB_OPEN) {
                if (status == JOB_PROGRESS) {
                    inprogressToTodo = true
                }
                optProgress.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg)
                optDone.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg)
                optTodo.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg_selected)

                optProgress.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button),
                    null,
                    null,
                    null
                )
                optDone.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button),
                    null,
                    null,
                    null
                )
                optTodo.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button_selected),
                    null,
                    null,
                    null
                )
                selectedStatus = JOB_OPEN
            }
        }
        optProgress.setOnClickListener {
            if (status == JOB_OPEN||status == JOB_PROGRESS ) {
                inprogressToTodo = false
                optProgress.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg_selected)
                optDone.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg)
                optTodo.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg)

                optProgress.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button_selected),
                    null,
                    null,
                    null
                )
                optDone.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button),
                    null,
                    null,
                    null
                )
                optTodo.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button),
                    null,
                    null,
                    null
                )
                selectedStatus = JOB_PROGRESS
            }
        }
        optDone.setOnClickListener {
            if (status == JOB_PROGRESS) {
                inprogressToTodo = false
                optProgress.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg)
                optDone.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg_selected)
                optTodo.background = ContextCompat.getDrawable(this,R.drawable.radio_button_bg)


                optProgress.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button),
                    null,
                    null,
                    null
                )
                optDone.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button_selected),
                    null,
                    null,
                    null
                )
                optTodo.setCompoundDrawablesWithIntrinsicBounds(
                    ContextCompat.getDrawable(this,R.drawable.radio_button),
                    null,
                    null,
                    null
                )
                selectedStatus = JOB_COMPLETED
            }
        }
    }

    override fun onBackPressed() {
        super.onBackPressed()
        finish()
    }

}