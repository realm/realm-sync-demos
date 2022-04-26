package com.wekanmdb.storeinventory.ui.jobs

import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseFragment
import com.wekanmdb.storeinventory.databinding.FilterJobBinding
import com.wekanmdb.storeinventory.databinding.FragmentJobsBinding
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.ui.createjobs.CreateJobActivity
import com.wekanmdb.storeinventory.utils.Constants.Companion.JOB_COMPLETED
import com.wekanmdb.storeinventory.utils.Constants.Companion.JOB_OPEN
import com.wekanmdb.storeinventory.utils.Constants.Companion.JOB_PROGRESS
import io.realm.RealmResults
import kotlinx.android.synthetic.main.fragment_jobs.*
import android.widget.AdapterView
import com.wekanmdb.storeinventory.ui.inventory.InventoryFragment


class JobsFragment : BaseFragment<FragmentJobsBinding>(), JobsNavigator {

    private lateinit var jobsViewModel: JobsViewModel
    private lateinit var fragmentJobsBinding: FragmentJobsBinding
    private var jobsAdapter: JobsAdapter? = null
    private  var jobsList: RealmResults<Jobs>?=null
    private lateinit var filterJobBinding: FilterJobBinding
    override val layoutId: Int
        get() = R.layout.fragment_jobs
    private var filterStatus = ""
    private var filterType = ""
    private val DEFAULT_TYPE = "Choose the Type"
    override fun initView(mRootView: View?, mViewDataBinding: ViewDataBinding?) {

        fragmentJobsBinding = mViewDataBinding as FragmentJobsBinding
        jobsViewModel = ViewModelProvider(this).get(JobsViewModel::class.java)
        fragmentJobsBinding.jobsViewModel = jobsViewModel
        jobsViewModel.navigator = this
        val userId = user?.customData?.getString("_id")
        jobsViewModel.storeId.set(InventoryFragment.selectedStoreId.toString())
        jobsViewModel.userId.set(userId.toString())
        jobsAdapter = JobsAdapter(requireContext(), false)
        mViewDataBinding.jobsAdapter = jobsAdapter
        getStore()
        getJobList()

        fragmentJobsBinding.imageView19.setOnClickListener {
            storesBottomSheet()
        }
    }

    // Query Realm for all Store
    private fun getStore() {
        jobsViewModel.storesresponseBody.observe(this, { storeDetails ->
            if (storeDetails != null) {
                fragmentJobsBinding.stores = storeDetails
                fragmentJobsBinding.executePendingBindings()
            }
        })
        jobsViewModel.getStore()
        jobsViewModel.storeListener()
    }

    // Query Realm for all joblist
    private fun getJobList() {
        jobsViewModel.jobresponseBody.observe(this, { jobList ->
            if (jobList != null && jobList.size > 0) {
                jobsList = jobList
                setView(jobList)
                nojobsLayout.visibility = View.GONE
                rv_jobs.visibility = View.VISIBLE
            } else {
                nojobsLayout.visibility = View.VISIBLE
                rv_jobs.visibility = View.GONE

            }
        })
        jobsViewModel.getJobList()
        jobsViewModel.jobListener()
    }

    private fun setView(jobList: RealmResults<Jobs>?) {
        textView34.text = "Total Items : ${jobList?.size}"
        textView34.setBackgroundResource(R.drawable.green_bg)
        jobsAdapter!!.setJobsAdapter(jobList!!)
    }

    override fun addJobClick() {
        val createJobIntent = Intent(activity, CreateJobActivity::class.java)
        startActivity(createJobIntent)
    }

    private fun storesBottomSheet() {
        filterJobBinding = FilterJobBinding.inflate(LayoutInflater.from(activity))
        val alertDialog = activity?.let { BottomSheetDialog(it) }
        alertDialog!!.setContentView(filterJobBinding.root)


        filterJobBinding.imageView34.setOnClickListener {
            alertDialog.dismiss()
        }


        filterJobBinding.todo.setOnClickListener {
            filterStatus = JOB_OPEN
            setFilterResult()

        }
        filterJobBinding.inprogress.setOnClickListener {
            filterStatus = JOB_PROGRESS
            setFilterResult()
        }
        filterJobBinding.done.setOnClickListener {
            filterStatus = JOB_COMPLETED
            setFilterResult()
        }
        setJobTypeAdapter()
        alertDialog.show()
    }

    private fun setFilterResult() {
        val result = if (filterStatus.isNotEmpty() && filterType.isNotEmpty()) {
            jobsList?.filter { it.status == filterStatus && it.assignedTo?.firstName == filterType }
        } else if (filterType.isNotEmpty()) {
            jobsList?.filter { it.type == filterType }
        } else if (filterStatus.isNotEmpty()) {
            jobsList?.filter { it.status == filterStatus }
        } else {
            jobsList?.filter { it.status.isNotEmpty() }
        }
        if (result.isNullOrEmpty()) {
            nojobsLayout.visibility = View.VISIBLE
            rv_jobs.visibility = View.GONE
        } else {
            nojobsLayout.visibility = View.GONE
            rv_jobs.visibility = View.VISIBLE
            jobsAdapter!!.setFilter(result)
        }
    }

    private fun setJobTypeAdapter() {
        val jobType = mutableListOf(DEFAULT_TYPE)
        jobsList?.forEach {
            it.type?.let { it1 -> jobType.add(it1) }
        }
        val distinct = LinkedHashSet(jobType).toMutableList()
        val spinnerAdapter = activity?.let { SpinnerAdapter(it, distinct) }
        filterJobBinding.spinner.adapter = spinnerAdapter

        filterJobBinding.spinner.onItemSelectedListener =
            object : AdapterView.OnItemSelectedListener {
                override fun onItemSelected(
                    parent: AdapterView<*>,
                    view: View,
                    position: Int,
                    id: Long
                ) {
                   val res = parent.getItemAtPosition(position) as String
                    filterType =if(res==DEFAULT_TYPE)"" else res

                    setFilterResult()
                }

                override fun onNothingSelected(parent: AdapterView<*>?) {}
            }
    }
}
