package com.wekanmdb.storeinventory.ui.jobs

import android.content.Intent
import android.view.View
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseFragment
import com.wekanmdb.storeinventory.databinding.FragmentJobsBinding
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.ui.createjobs.CreateJobActivity
import io.realm.RealmResults
import kotlinx.android.synthetic.main.fragment_jobs.*

class JobsFragment : BaseFragment<FragmentJobsBinding>(), JobsNavigator {

    private lateinit var jobsViewModel: JobsViewModel
    private lateinit var fragmentJobsBinding: FragmentJobsBinding
    private var jobsAdapter: JobsAdapter? = null

    override val layoutId: Int
        get() = R.layout.fragment_jobs

    override fun initView(mRootView: View?, mViewDataBinding: ViewDataBinding?) {

        fragmentJobsBinding = mViewDataBinding as FragmentJobsBinding
        jobsViewModel = ViewModelProvider(this).get(JobsViewModel::class.java)
        fragmentJobsBinding.jobsViewModel = jobsViewModel
        jobsViewModel.navigator = this
        val storeId = user?.customData?.getObjectId("stores")
        val userId = user?.customData?.getString("_id")
        jobsViewModel.storeId.set(storeId.toString())
        jobsViewModel.userId.set(userId.toString())

        jobsAdapter = JobsAdapter(requireContext())
        mViewDataBinding.jobsAdapter = jobsAdapter
        getStore()
        getJobList()
    }

    // Query Realm for all Store
    private fun getStore() {
        jobsViewModel.storesresponseBody.observe(this, { storeDetails ->
            if (storeDetails != null) {
                fragmentJobsBinding.stores = storeDetails
                fragmentJobsBinding.executePendingBindings()
            } else {
                showToast("No more Data")
            }
        })
        jobsViewModel.getStore()
        jobsViewModel.storeListener()
    }

    // Query Realm for all joblist
    private fun getJobList() {
        jobsViewModel.jobresponseBody.observe(this, { jobList ->
            if (jobList != null && jobList.size > 0) {
                setView(jobList)
            } else {
                showToast("No More  data")
            }
        })
        jobsViewModel.getJobList()
        jobsViewModel.jobListener()
    }

    private fun setView(jobList: RealmResults<Jobs>?) {
        textView34.text = "Total Items : ${jobList?.size}"
        jobsAdapter!!.setJobsAdapter(jobList!!)
    }

    override fun addJobClick() {
        val createJobIntent = Intent(activity, CreateJobActivity::class.java)
        startActivity(createJobIntent)
    }
}
