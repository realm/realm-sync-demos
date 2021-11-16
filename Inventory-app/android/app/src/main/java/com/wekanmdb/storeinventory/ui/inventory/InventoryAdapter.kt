package com.wekanmdb.storeinventory.ui.inventory

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.databinding.ItemInventoryBinding
import com.wekanmdb.storeinventory.model.storeInventory.StoreInventory
import io.realm.RealmList
import io.realm.RealmResults

class InventoryAdapter(val context: Context, var clickInventoryItem: ClickInventoryItem) :
    RecyclerView.Adapter<InventoryAdapter.InventoryHolder>() {

    private val storeInventoryList: RealmList<StoreInventory>

    init {
        storeInventoryList = RealmList<StoreInventory>()
    }

    fun setInventoryAdapter(item: RealmResults<StoreInventory>) {
        if (item == null) {
            return
        }
        storeInventoryList.clear()
        storeInventoryList.addAll(item)
        notifyDataSetChanged()
    }

    interface ClickInventoryItem {
        fun onItemClick(productId: String, productName: String, quantity: String)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): InventoryHolder {
        return InventoryHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.item_inventory, parent, false)
        )
    }

    override fun onBindViewHolder(holder: InventoryHolder, position: Int) {
        val item: StoreInventory = storeInventoryList.get(position)!!
        val binding: ItemInventoryBinding = holder.getBinding()
        binding.textView2.text = "Stock:" + " " + item.quantity
        binding.products = item
    }

    override fun getItemCount(): Int {
        return storeInventoryList.size
    }

    inner class InventoryHolder(itemView: View) : RecyclerView.ViewHolder(itemView),
        View.OnClickListener {
        private var binding: ItemInventoryBinding? = null

        init {
            binding = DataBindingUtil.bind(itemView)
            itemView.setOnClickListener(this)
        }

        fun getBinding(): ItemInventoryBinding {
            return binding!!
        }

        override fun onClick(view: View?) {
            clickInventoryItem.onItemClick(
                storeInventoryList.get(absoluteAdapterPosition)?.productId.toString(),
                storeInventoryList.get(absoluteAdapterPosition)?.productName.toString(),
                storeInventoryList.get(absoluteAdapterPosition)?.quantity.toString()
            )

//            context.startActivity(ProductDetailsActivity.getCallingIntent(context, storeInventoryList.get(absoluteAdapterPosition)?.productId.toString(), storeInventoryList.get(absoluteAdapterPosition)?.productName.toString(),storeInventoryList.get(absoluteAdapterPosition)?.quantity.toString()))
        }
    }

}