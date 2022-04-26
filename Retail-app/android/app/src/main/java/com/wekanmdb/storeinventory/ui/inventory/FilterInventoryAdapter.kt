package com.wekanmdb.storeinventory.ui.inventory

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.viewpager.widget.PagerAdapter
import androidx.viewpager.widget.ViewPager
import com.bumptech.glide.Glide
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.model.storeInventory.StoreInventory
import kotlinx.android.synthetic.main.item_filter_inventory.view.*
import java.util.*

class FilterInventoryAdapter(val context: Context, var clickInventoryItem: ClickInventoryItem) :
    PagerAdapter() {

    companion object {
        var context: Context? = null
    }

    private var storeInventoryList: MutableList<StoreInventory>? = ArrayList()

    fun setBannerItemList(item: List<StoreInventory>) {
        if (item == null) return
        storeInventoryList!!.clear()
        storeInventoryList!!.addAll(item)
        notifyDataSetChanged()
    }

    interface ClickInventoryItem {
        fun onItemClick(
            inventryId: String,
            productId: String,
            productName: String,
            quantity: String
        )
    }


    override fun getCount(): Int {
        return storeInventoryList!!.size
    }

    override fun instantiateItem(container: ViewGroup, position: Int): Any {
        val layoutInflater =
            context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val view: View = layoutInflater.inflate(R.layout.item_filter_inventory, container, false)
        val item: StoreInventory = storeInventoryList?.get(position)!!
        view.textView32.text = item.productName
        view.textView36.text = "Only " + item.quantity + " Remaining"
        view.setOnClickListener {
            clickInventoryItem.onItemClick(
                storeInventoryList!![position]._id.toString(),
                storeInventoryList!![position].productId.toString(),
                storeInventoryList!![position].productName.toString(),
                storeInventoryList!![position].quantity.toString()
            )
        }
        Glide.with(context)
            .load(item.image).fitCenter()
            .into(view.imageView2)
        container.addView(view)
        return view
    }

    override fun isViewFromObject(view: View, `object`: Any): Boolean {
        return view === `object`
    }

    override fun destroyItem(container: View, position: Int, `object`: Any) {
        (container as ViewPager).removeView(`object` as View?)
    }
}