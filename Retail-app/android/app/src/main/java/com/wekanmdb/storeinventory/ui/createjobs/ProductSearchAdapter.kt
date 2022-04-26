package com.wekanmdb.storeinventory.ui.createjobs

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.databinding.ActivityProductSearchBinding
import com.wekanmdb.storeinventory.model.storeInventory.StoreInventory
import io.realm.RealmList
import io.realm.RealmResults

/**
 * This Adapter is used to hold actual product item from realm
 * while searching in Search Activity.
 */
class ProductSearchAdapter(var context: Context): RecyclerView.Adapter<ProductSearchAdapter.ProductSearchViewHolder>(){
    private  var productList: RealmList<StoreInventory>
    init {
        productList = RealmList<StoreInventory>()
    }
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ProductSearchViewHolder {
        return ProductSearchViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.activity_product_search, parent, false)
        )
    }

    override fun onBindViewHolder(holder: ProductSearchViewHolder, position: Int) {
        val item: StoreInventory = productList.get(position)!!
        val binding: ActivityProductSearchBinding = holder.getBinding()
        binding.storeinventory = item
    }


    fun addData(ans: RealmResults<StoreInventory>){
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
        private var binding: ActivityProductSearchBinding? = null

        init {
            binding = DataBindingUtil.bind(itemView)
            itemView.setOnClickListener(this)
        }

        fun getBinding(): ActivityProductSearchBinding {
            return binding!!
        }

        override fun onClick(v: View?) {
            (context as SearchActivity).updateProduct(productList[absoluteAdapterPosition]?.productId.toString(), productList[absoluteAdapterPosition]?.productName.toString(),
                productList[absoluteAdapterPosition]?.quantity,
                productList[absoluteAdapterPosition]?.image)
        }

    }



}