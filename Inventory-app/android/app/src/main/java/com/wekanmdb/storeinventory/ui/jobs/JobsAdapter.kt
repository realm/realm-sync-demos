package com.wekanmdb.storeinventory.ui.jobs

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.databinding.ItemJobsBinding
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.ui.editjobs.JobDetailsActivity
import com.wekanmdb.storeinventory.utils.Constants.Companion.JOB_ID
import com.wekanmdb.storeinventory.utils.UiUtils
import io.realm.RealmList
import io.realm.RealmResults

class JobsAdapter(val context: Context) : RecyclerView.Adapter<JobsAdapter.JobViewModel>() {
    private val jobsList: RealmList<Jobs>

    init {
        jobsList = RealmList<Jobs>()
    }

    fun setJobsAdapter(item: RealmResults<Jobs>) {
        if (item == null) {
            return
        }
        jobsList.clear()
        jobsList.addAll(item)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): JobViewModel {
        return JobViewModel(
            LayoutInflater.from(parent.context).inflate(R.layout.item_jobs, parent, false)
        )
    }

    override fun onBindViewHolder(holder: JobViewModel, position: Int) {
        val item: Jobs = jobsList.get(position)!!
        val binding: ItemJobsBinding = holder.getBinding()
        binding.textView15.text=UiUtils.convertToCustomFormatDate(item.pickupDatetime.toString())
        binding.textView26.text=UiUtils.convertToCustomFormatTime(item.pickupDatetime.toString())
        binding.jobs = item
    }

    override fun getItemCount(): Int {
        return jobsList.size
    }

    inner class JobViewModel(itemView: View) : RecyclerView.ViewHolder(itemView),View.OnClickListener {

        private var binding: ItemJobsBinding? = null

        init {
            binding = DataBindingUtil.bind(itemView)
            itemView.setOnClickListener(this)
        }

        fun getBinding(): ItemJobsBinding {
            return binding!!
        }

        override fun onClick(v: View?) {
            val jobDetailsIntent = Intent(context, JobDetailsActivity::class.java)
            jobDetailsIntent.putExtra(JOB_ID, jobsList.get(absoluteAdapterPosition)?._id.toString())
            context.startActivity(jobDetailsIntent)
        }

    }
}