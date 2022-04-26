package com.wekanmdb.storeinventory.ui.deliveryjob

import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.view.View
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import com.google.android.material.tabs.TabLayout
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.storerealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityDeliveryJobBinding
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.services.LocationService
import com.wekanmdb.storeinventory.ui.jobs.JobsAdapter
import com.wekanmdb.storeinventory.ui.login.LoginActivity
import com.wekanmdb.storeinventory.utils.Constants
import io.realm.RealmResults
import kotlinx.android.synthetic.main.activity_delivery_job.*
import kotlinx.android.synthetic.main.dialog_logout.textView23
import kotlinx.android.synthetic.main.dialog_logout.textView24
import org.bson.types.ObjectId

class DeliveryJobActivity : BaseActivity<ActivityDeliveryJobBinding>(), DeliveryJobNavigator {
    companion object {
        fun getCallingIntent(context: Context): Intent {
            return Intent(context, DeliveryJobActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
    }

    private lateinit var activityDeliveryJobBinding: ActivityDeliveryJobBinding
    private var jobsAdapter: JobsAdapter? = null
    private lateinit var deliveryJobViewModel: DeliveryJobViewModel
    private var selecetedTab = ""
    override fun getLayoutId(): Int = R.layout.activity_delivery_job

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityDeliveryJobBinding = mViewDataBinding as ActivityDeliveryJobBinding
        deliveryJobViewModel = ViewModelProvider(this).get(DeliveryJobViewModel::class.java)
        activityDeliveryJobBinding.deliveryJobViewModel = deliveryJobViewModel
        deliveryJobViewModel.navigator = this

        val name = user?.customData?.getString("firstName")
        val userId = user?.customData?.getString("_id")
        deliveryJobViewModel.userId.set(userId)
        et_jobsearch.text = name.toString()

        tab_job.addOnTabSelectedListener(object : TabLayout.OnTabSelectedListener {
            override fun onTabSelected(tab: TabLayout.Tab?) {
                when (tab?.position) {
                    0 -> {
                        selecetedTab = Constants.JOB_OPEN
                        deliveryJobViewModel.getDeliveryJob(selecetedTab)
                    }
                    1 -> {
                        selecetedTab = Constants.JOB_PROGRESS
                        deliveryJobViewModel.getDeliveryJob(selecetedTab)
                    }
                    2 -> {
                        selecetedTab = Constants.JOB_COMPLETED
                        deliveryJobViewModel.getDeliveryJob(selecetedTab)
                    }
                }

            }

            override fun onTabUnselected(tab: TabLayout.Tab?) {
            }

            override fun onTabReselected(tab: TabLayout.Tab?) {
            }

        })

        jobsAdapter = JobsAdapter(this, true)
        mViewDataBinding.jobsAdapter = jobsAdapter
//default selected tab
        selecetedTab = Constants.JOB_OPEN

        getJob()
        // Use the logout click
        img_logout.setOnClickListener {
            logout()
        }
    }

    // Query Realm for all DeliveryJobList
    private fun getJob() {
        deliveryJobViewModel.jobresponseBody.observe(this, { job ->
            if (job != null && job.size > 0) {
                activityDeliveryJobBinding.rvJobs.visibility = View.VISIBLE
                activityDeliveryJobBinding.emptyView.visibility = View.GONE
                setView(job)
            } else {
                activityDeliveryJobBinding.rvJobs.visibility = View.GONE
                activityDeliveryJobBinding.emptyView.visibility = View.VISIBLE
                when (tab_job.selectedTabPosition) {
                    0 -> {
                        activityDeliveryJobBinding.emptyText.text =
                            getString(R.string.no_jobs_assigned)
                    }
                    1 -> {
                        activityDeliveryJobBinding.emptyText.text = getString(R.string.no_jobs)
                    }
                    2 -> {
                        activityDeliveryJobBinding.emptyText.text = getString(R.string.no_jobs)
                    }
                }
//                showToast("No More  data")
            }
        })
        deliveryJobViewModel.getDeliveryJob(selecetedTab)
        deliveryJobViewModel.jobListener()
    }

    private fun setView(jobs: RealmResults<Jobs>?) {
        jobsAdapter!!.setJobsAdapter(jobs!!)
    }

    fun getOrderInfo(order: ObjectId): String? {
        return deliveryJobViewModel.getOrderInfo(order)
    }

    // logout fuction
    private fun logout() {
        val dialoglogout = Dialog(this, R.style.dialog_center)
        dialoglogout.setCancelable(false)
        dialoglogout.setContentView(R.layout.dialog_logout)
        dialoglogout.show()
        val no = dialoglogout.textView23
        val yes = dialoglogout.textView24
        no.setOnClickListener {
            dialoglogout.dismiss()
        }
        yes.setOnClickListener {
            user?.logOutAsync { logout ->
                LocationService.isServiceStarted = false
                stopService(Intent(this, LocationService::class.java))
                if (logout.isSuccess) {
                    apprealm?.close()
                    storerealm?.close()
                    user = null
                    startActivity(
                        LoginActivity.getCallingIntent(this)
                            .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    )
                    finish()
                    dialoglogout.dismiss()
                } else {
                    showToast("log out failed! Error: ${logout.error}")
                }
            }
        }
    }


    override fun onResume() {
        super.onResume()
        if (selecetedTab.isNotEmpty()) {
            deliveryJobViewModel.getDeliveryJob(selecetedTab)
        }
    }
}