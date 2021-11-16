package com.wekanmdb.storeinventory.ui.deliveryjob

import android.app.Dialog
import android.content.Context
import android.content.Intent
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.storerealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityDeliveryJobBinding
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.ui.jobs.JobsAdapter
import com.wekanmdb.storeinventory.ui.login.LoginActivity
import io.realm.RealmResults
import kotlinx.android.synthetic.main.activity_delivery_job.*
import kotlinx.android.synthetic.main.dialog_logout.*

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

        jobsAdapter = JobsAdapter(this)
        mViewDataBinding.jobsAdapter = jobsAdapter
        getJob()
        // Use the logout click
        img_logout.setOnClickListener {
            logout()
        }
    }

    // Query Realm for all DeliveryJobList
    private fun getJob() {
        deliveryJobViewModel.jobresponseBody.observe(this, { job ->
            if (job!=null && job.size > 0) {
                setView(job)
            } else {
                showToast("No More  data")
            }
        })
        deliveryJobViewModel.getDeliveryJob()
        deliveryJobViewModel.jobListener()
    }

    private fun setView(jobs: RealmResults<Jobs>?) {
        jobsAdapter!!.setJobsAdapter(jobs!!)
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

}