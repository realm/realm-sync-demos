package com.wekanmdb.storeinventory.ui.orders

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.databinding.CreateOrderItemBinding
import com.wekanmdb.storeinventory.model.orders.Orders
import com.wekanmdb.storeinventory.utils.Constants.Companion.STORE_PICKUP
import com.wekanmdb.storeinventory.utils.UiUtils
import io.realm.RealmList
import io.realm.RealmResults

class OrdersAdapter(val context: Context, var clickListener: (Orders, Boolean) -> Unit) :
    RecyclerView.Adapter<OrdersAdapter.JobViewModel>() {
    private val ordersList: RealmList<Orders> = RealmList<Orders>()

    fun setJobsAdapter(item: RealmResults<Orders>) {
        if (item == null) {
            return
        }
        ordersList.clear()
        ordersList.addAll(item)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): JobViewModel {
        return JobViewModel(
            LayoutInflater.from(parent.context).inflate(R.layout.create_order_item, parent, false)
        )
    }

    override fun onBindViewHolder(holder: JobViewModel, position: Int) {
        val item: Orders = ordersList.get(position)!!
        val binding: CreateOrderItemBinding = holder.getBinding()
        if (item.type!!.name == STORE_PICKUP) {
            View.GONE
        } else {
            View.VISIBLE
        }.let {
            binding.textAddress.visibility=it
        }
        binding.textDate.text = UiUtils.convertToCustomFormatDate(item.createdDate.toString())
        binding.textTime.text = UiUtils.convertToCustomFormatTime(item.createdDate.toString())
        binding.orders = item
        binding.textView111.setOnClickListener {
            clickListener(item, true)
        }

    }

    override fun getItemCount(): Int {
        return ordersList.size
    }

    inner class JobViewModel(itemView: View) : RecyclerView.ViewHolder(itemView),
        View.OnClickListener {

        private var binding: CreateOrderItemBinding? = null

        init {
            binding = DataBindingUtil.bind(itemView)
            itemView.setOnClickListener(this)
        }

        fun getBinding(): CreateOrderItemBinding {
            return binding!!
        }

        override fun onClick(v: View?) {
            ordersList[absoluteAdapterPosition]?.let { clickListener(it, false) }

        }

    }
}