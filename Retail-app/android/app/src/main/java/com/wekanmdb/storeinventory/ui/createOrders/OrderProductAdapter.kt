package com.wekanmdb.storeinventory.ui.createOrders

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.databinding.JobproductItemBinding
import com.wekanmdb.storeinventory.ui.createjobs.JobProduct

/**
 * This is a wrapper Adapter used to hold
 * Product details.
 * This adapter is used only to show item row for products.
 */

class OrderProductAdapter(var context: Context,var onClick:(Int,JobProduct,Boolean)->Unit): RecyclerView.Adapter<OrderProductAdapter.ProductJobViewHolder>(){

    private  var jobItemList: List<JobProduct> = emptyList<JobProduct>()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ProductJobViewHolder {
        val binding = JobproductItemBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return ProductJobViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ProductJobViewHolder, position: Int) {
        with(holder){
            with(jobItemList[position]){
                binding.productName.text = this.name
                binding.quantity.text = this.quantity.toString()
                binding.productName.setOnClickListener {
                    onClick(absoluteAdapterPosition,jobItemList[position],false)

                }

                binding.removeItem.setOnClickListener(){
                    onClick(absoluteAdapterPosition,jobItemList[position],true)

                }
                binding.jobProduct=this
            }
        }
    }


    fun addData(list: ArrayList<JobProduct>){
        this.jobItemList = list
        notifyDataSetChanged()
    }
    override fun getItemCount(): Int {
        return jobItemList.size
    }

    inner  class ProductJobViewHolder(val binding: JobproductItemBinding) : RecyclerView.ViewHolder(binding.root)
}