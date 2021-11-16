package com.wekanmdb.storeinventory.ui.editjobs

import android.app.Activity
import android.content.Intent
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.ColorDrawable
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.TextView
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityDetailsJobBinding
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.model.job.ProductQuantity
import com.wekanmdb.storeinventory.model.user.Users
import com.wekanmdb.storeinventory.ui.createjobs.SearchActivity
import com.wekanmdb.storeinventory.utils.Constants
import com.wekanmdb.storeinventory.utils.Constants.Companion.DELIVERY_USER_ROLE
import com.wekanmdb.storeinventory.utils.Constants.Companion.JOB_COMPLETED
import com.wekanmdb.storeinventory.utils.Constants.Companion.JOB_OPEN
import com.wekanmdb.storeinventory.utils.Constants.Companion.JOB_PROGRESS
import com.wekanmdb.storeinventory.utils.Constants.Companion.STORE_ADMIN_USER_ROLE
import com.wekanmdb.storeinventory.utils.UiUtils.getDateYYYYmmDD
import com.wekanmdb.storeinventory.utils.UiUtils.getTimeAmPm
import com.wekanmdb.storeinventory.utils.UiUtils.showToast
import io.realm.RealmList
import org.bson.types.ObjectId
import android.view.Gravity
import kotlinx.android.synthetic.main.common_toolbar.*
import java.util.*


/**
 * This activity is used to show JOB Details.
 * Store Admin User can Update Assignee for the Job if JOB is in open(to-do) status.
 * Delivery user can ony update Job status if it's status is not Done.
 *
 *
 */

class JobDetailsActivity : BaseActivity<ActivityDetailsJobBinding>() , AdapterView.OnItemSelectedListener {
    lateinit var activityDetailsJobBinding: ActivityDetailsJobBinding
    private lateinit var jobDetailsAdapter: JobDetailsAdapter
    var currentUser : Users?= null
    var currentJob : Jobs ? = null
    var mUserRole : String ? =null
    var reassignedTo : Users?=null
    var mJobStatus : String ? = null
    var adapter : ArrayAdapter<String> ?= null
    lateinit var jobDetailsViewModel: JobDetailsViewModel
    override fun getLayoutId(): Int = R.layout.activity_details_job

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityDetailsJobBinding = mViewDataBinding as ActivityDetailsJobBinding
        jobDetailsViewModel = ViewModelProvider(this, viewModelFactory).get(
            JobDetailsViewModel::class.java)
        activityDetailsJobBinding.jobDetailsViewModel = jobDetailsViewModel

        val jobId = intent.getStringExtra(Constants.JOB_ID)
        jobDetailsViewModel =  ViewModelProvider(this).get(JobDetailsViewModel::class.java)
        var userId  = user?.customData?.getString("_id")
        /**
         * getCurrentUser method gives the current logged in user.
         */
        getCurrentUser(ObjectId(userId))
        /**
         * getCurrentJob method gives the current job object which is passed to this activity.
         */
        getCurrentJob(ObjectId(jobId))


        activityDetailsJobBinding.assigneeh.setOnClickListener(){
            when(mUserRole){
                DELIVERY_USER_ROLE-> doNothing()
                STORE_ADMIN_USER_ROLE -> editAssignee()
            }

        }
        img_back.setTitle("Job Details")
        img_back.setOnClickListener {
            finish()
        }

        initListener()
    }

    private fun initListener() {
        jobDetailsViewModel.jobUpdateStatus.observe(this){
            showToast(it)
        }
        jobDetailsViewModel.assigneeUpdate.observe(this){
            showToast(it)
        }
    }

    private fun editAssignee() {
        if(mJobStatus?.contentEquals(JOB_OPEN) == true){
            val assigneeIntent = Intent(this, SearchActivity::class.java)
            assigneeIntent.putExtra(Constants.SEARCH_TYPE, Constants.SEARCH_ASSIGNEE)
            assigneeSearchLauncher.launch(assigneeIntent)
        }
        else{
            showToast("Job is not Open",this)
        }

    }
    var assigneeSearchLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val data: Intent? = result.data
                if (data != null) {
                    data.getStringExtra("data")
                    val id = data.getStringExtra("id")
                    jobDetailsViewModel.getAssignees(ObjectId(id)).observe(this){
                        reassignedTo = it
                        activityDetailsJobBinding.assigneeh.text = reassignedTo?.firstName + " "+reassignedTo?.lastName
                        updateJobAssignee(reassignedTo)

                    }

                }
            }
        }

    private fun updateJobAssignee(reassignedTo: Users?) {
        jobDetailsViewModel.upDateJobAssignee(currentJob,reassignedTo).observe(this){
            if(it){
                Toast.makeText(this,"Assignee Updated Successfully",Toast.LENGTH_SHORT).show()
            }
        }

    }

    private fun upDateJobStatus(jobStatus: String) {
        jobDetailsViewModel.updateJobStatus(currentJob,jobStatus).observe(this){
            if(it){
                showToast("Job Status Updated Successfully",this)
            }
        }
    }

    private fun doNothing() {
        // can change design later
    }


    private fun getCurrentJob(jobId: ObjectId) {
        jobDetailsViewModel.getCurrentJobDetails(jobId).observe(this){
            currentJob = it
            mJobStatus = it.status
            setSelectionSpinner(mJobStatus!!)
            currentJob?.let { job-> initUiView(job) }
            currentJob?.let { job->job.products }?.let { productList->initJobDetailsAdapter(productList) }
        }
    }

    private fun setSelectionSpinner(mJobStatus: String) {
        val dropdown = activityDetailsJobBinding.jobStatus
        dropdown.setOnItemSelectedListener(null)
        when(mJobStatus){
            JOB_OPEN -> {
                dropdown.post(Runnable { adapter?.let { dropdown.setSelection(it.getPosition(JOB_OPEN),false)
                dropdown.setOnItemSelectedListener(this@JobDetailsActivity)
                } })
            }
            JOB_PROGRESS->{
                dropdown.post(Runnable { adapter?.let { dropdown.setSelection(it.getPosition(JOB_PROGRESS),false)
                    dropdown.setOnItemSelectedListener(this@JobDetailsActivity)
                } })

            }
            JOB_COMPLETED->{
                dropdown.post(Runnable { adapter?.let { dropdown.setSelection(it.getPosition(JOB_COMPLETED),false) } })
            }

        }
        if(mJobStatus == JOB_COMPLETED){
            dropdown.isEnabled = false
        }

    }

    private fun initUiView(job: Jobs) {
        activityDetailsJobBinding.sourcestoreh.text = job.sourceStore?.name.toString()
            .capitalize(Locale.US)
        activityDetailsJobBinding.dropstoreh.text = job.destinationStore?.name.toString()
            .capitalize(Locale.US)
        activityDetailsJobBinding.dateh.text = getDateYYYYmmDD(job.pickupDatetime)
        activityDetailsJobBinding.timeh.text = getTimeAmPm(job.pickupDatetime)
        activityDetailsJobBinding.assigneeh.text = job.assignedTo?.firstName.toString() .capitalize(Locale.US)+" "+job.assignedTo?.lastName.toString() .capitalize(Locale.US)

    }

    private fun getCurrentUser(userid: ObjectId) {
        jobDetailsViewModel.getCurrentUser(userid).observe(this){
            currentUser = it
            mUserRole = it.userRole
            initJobStatusSpinner()
        }
    }

    private fun initJobDetailsAdapter(productList: RealmList<ProductQuantity>) {

        jobDetailsAdapter= JobDetailsAdapter(this)
        activityDetailsJobBinding.listView.apply {
            layoutManager = LinearLayoutManager(this@JobDetailsActivity)
            adapter = jobDetailsAdapter
        }
        jobDetailsAdapter.addData(productList)

    }


    private fun initJobStatusSpinner() {
        val dropdown = activityDetailsJobBinding.jobStatus
        val items = arrayOf(JOB_OPEN, JOB_PROGRESS,JOB_COMPLETED)
//         adapter  =
//            ArrayAdapter<String>(this, R.layout.spinner_item, items)
//
        // initialize an array adapter for spinner
         adapter = object: ArrayAdapter<String>(
            this,
            android.R.layout.simple_spinner_dropdown_item,
            items
        ){
            override fun getDropDownView(
                position: Int,
                convertView: View?,
                parent: ViewGroup
            ): View {
                val view: TextView = super.getDropDownView(
                    position,
                    convertView,
                    parent
                ) as TextView



                // spinner item text alignment center
                view.textAlignment = View.TEXT_ALIGNMENT_CENTER

                return view
            }

            override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
                val v = super.getView(position, convertView, parent)
                (v as TextView).textAlignment = View.TEXT_ALIGNMENT_CENTER
                (v as TextView).textSize = 15f
                val lparams = ViewGroup.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT
                )
                v.setLayoutParams(lparams)
                return v

            }
        }
        dropdown.adapter = adapter
        when(mUserRole){
            DELIVERY_USER_ROLE-> {
                activityDetailsJobBinding.assigneeh.visibility=View.GONE
                activityDetailsJobBinding.assigneeTitle.visibility=View.GONE
                dropdown.isEnabled = true
            }
            else -> dropdown.isEnabled = false

        }

    }

    override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {

            val selectedItemText = parent?.getItemAtPosition(position) as String
            when(selectedItemText){
                JOB_PROGRESS -> upDateJobStatus(JOB_PROGRESS)
                JOB_COMPLETED -> upDateJobStatus(JOB_COMPLETED)
                JOB_OPEN-> upDateJobStatus(JOB_OPEN)
            }

    }


    override fun onNothingSelected(parent: AdapterView<*>?) {
       // nothing to do
    }

    override fun onBackPressed() {
        super.onBackPressed()
        finish()
    }




}