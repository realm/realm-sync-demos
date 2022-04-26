package com.wekanmdb.storeinventory.ui.createjobs

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.databinding.JobproductItemBinding
import com.wekanmdb.storeinventory.databinding.OrderJobproductItemBinding
import com.wekanmdb.storeinventory.model.job.ProductQuantity
import io.realm.RealmList

/**
 * This is a wrapper Adapter used to hold
 * Product details.
 * This adapter is used only to show item row for products.
 */

class OrderJobProductAdapter(var context: Context): RecyclerView.Adapter<OrderJobProductAdapter.ProductJobViewHolder>(){

    private  var jobItemList: List<ProductQuantity> = emptyList()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ProductJobViewHolder {
        val binding = OrderJobproductItemBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return ProductJobViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ProductJobViewHolder, position: Int) {
        with(holder){
            with(jobItemList[position]){
                binding.productQuantity=this
                binding.quantity.text = this.quantity.toString()


            }
        }
    }


    fun addData(list: RealmList<ProductQuantity>){
        this.jobItemList = list
        notifyDataSetChanged()
    }
    override fun getItemCount(): Int {
        return jobItemList.size
    }

    inner  class ProductJobViewHolder(val binding: OrderJobproductItemBinding) : RecyclerView.ViewHolder(binding.root)
}