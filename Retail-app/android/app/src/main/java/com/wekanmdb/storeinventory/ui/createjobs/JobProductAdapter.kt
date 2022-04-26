package com.wekanmdb.storeinventory.ui.createjobs

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.databinding.JobproductItemBinding

/**
 * This is a wrapper Adapter used to hold
 * Product details.
 * This adapter is used only to show item row for products.
 */

class JobProductAdapter( var context: Context): RecyclerView.Adapter<JobProductAdapter.ProductJobViewHolder>(){

    private  var jobItemList: List<JobProduct> = emptyList<JobProduct>()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ProductJobViewHolder {
        val binding = JobproductItemBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return ProductJobViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ProductJobViewHolder, position: Int) {
        with(holder){
            with(jobItemList[position]){
                binding.jobProduct=this
                binding.quantity.text = this.quantity.toString()
                binding.productName.setOnClickListener {
                    if(context is CreateJobActivity){
                        (context as CreateJobActivity).searchProduct(absoluteAdapterPosition)
                    }
                }

                binding.removeItem.setOnClickListener(){
                    if (context is CreateJobActivity) {
                        (context as CreateJobActivity).removeItemExisting(jobItemList[position])
                    }
                }
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