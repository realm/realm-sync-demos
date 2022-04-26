package com.wekanmdb.storeinventory.ui.jobs

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.databinding.ItemJobsBinding
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.ui.deliveryjob.DeliveryJobActivity
import com.wekanmdb.storeinventory.ui.editjobs.DeliveryJobDetailsActivity
import com.wekanmdb.storeinventory.ui.editjobs.JobDetailsActivity
import com.wekanmdb.storeinventory.utils.Constants
import com.wekanmdb.storeinventory.ui.home.HomeActivity
import com.wekanmdb.storeinventory.utils.Constants.Companion.JOB_ID
import com.wekanmdb.storeinventory.utils.UiUtils
import io.realm.RealmList
import io.realm.RealmResults

class JobsAdapter(val context: Context,val isDelivery: Boolean) : RecyclerView.Adapter<JobsAdapter.JobViewModel>() {
    private val jobsList: RealmList<Jobs> = RealmList<Jobs>()

    fun setJobsAdapter(item: RealmResults<Jobs>) {
        jobsList.clear()
        if (item == null) {
            notifyDataSetChanged()
            return
        }
        jobsList.addAll(item)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): JobViewModel {
        return JobViewModel(
            LayoutInflater.from(parent.context).inflate(R.layout.item_jobs, parent, false)
        )
    }

    override fun onBindViewHolder(holder: JobViewModel, position: Int) {
        val item: Jobs = jobsList[position]!!
        val binding: ItemJobsBinding = holder.getBinding()
        binding.textView15.text = UiUtils.convertToCustomFormatDate(item.datetime.toString())
        binding.textView26.text = UiUtils.convertToCustomFormatTime(item.datetime.toString())
        if (item.destinationStore == null) {
            binding.textView10.text = context.resources.getString(R.string.drop_off_address)
            if(isDelivery){
                binding.textView14.text = (context as DeliveryJobActivity).getOrderInfo(item.order!!)

            }else{
                binding.textView14.text = (context as HomeActivity).getOrderInfo(item.order!!)
            }

        } else {
            binding.textView14.text = item.destinationStore!!.name

        }
        if (item.status.equals("Done", ignoreCase = true)) {
            ContextCompat.getColor(context, R.color.green_dark)
        } else {
            ContextCompat.getColor(context, R.color.blue)
        }.let { binding.textView20.setTextColor(it) }
        binding.jobs = item
    }

    override fun getItemCount(): Int {
        return jobsList.size
    }

    fun setFilter(item: List<Jobs>) {
        jobsList.clear()
        jobsList.addAll(item)
        notifyDataSetChanged()

    }

    inner class JobViewModel(itemView: View) : RecyclerView.ViewHolder(itemView),
        View.OnClickListener {

        private var binding: ItemJobsBinding? = null

        init {
            binding = DataBindingUtil.bind(itemView)
            itemView.setOnClickListener(this)
        }

        fun getBinding(): ItemJobsBinding {
            return binding!!
        }

        override fun onClick(v: View?) {
            var jobDetailsIntent = Intent(context, JobDetailsActivity::class.java)
            if (user?.customData?.getString("userRole") == Constants.DELIVERY_USER_ROLE) {
                jobDetailsIntent = Intent(context, DeliveryJobDetailsActivity::class.java)
            }
            jobDetailsIntent.putExtra(JOB_ID, jobsList[absoluteAdapterPosition]?._id.toString())
            context.startActivity(jobDetailsIntent)
        }

    }
}