package com.wekanmdb.storeinventory.ui.createOrders

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.databinding.OrderSummaryItemBinding
import com.wekanmdb.storeinventory.model.job.ProductQuantity
import io.realm.RealmList

/**
 * This Adapter is used to hold actual product item from realm
 * while searching in Search Activity.
 */
class ProductSummaryAdapter(var context: Context): RecyclerView.Adapter<ProductSummaryAdapter.ProductSearchViewHolder>(){
    private  var productList: RealmList<ProductQuantity> = RealmList<ProductQuantity>()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ProductSearchViewHolder {
        return ProductSearchViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.order_summary_item, parent, false)
        )
    }

    override fun onBindViewHolder(holder: ProductSearchViewHolder, position: Int) {
        val item: ProductQuantity = productList[position]!!
        val binding: OrderSummaryItemBinding = holder.getBinding()
        binding.productQty.text=item.quantity.toString()
      binding.productQuantity = item
    }


    fun addData(ans: RealmList<ProductQuantity>){
        if(productList==null){
            return
        }
        productList.clear()
        productList.addAll(ans)
        notifyDataSetChanged()
    }
    override fun getItemCount(): Int {
        return productList.size
    }

    inner  class ProductSearchViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView),View.OnClickListener{
        private var binding: OrderSummaryItemBinding? = null

        init {
            binding = DataBindingUtil.bind(itemView)
            itemView.setOnClickListener(this)
        }

        fun getBinding(): OrderSummaryItemBinding {
            return binding!!
        }

        override fun onClick(v: View?) {
        }

    }



}