package com.wekanmdb.storeinventory.ui.inventory

import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.View
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.NavHostFragment
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseFragment
import com.wekanmdb.storeinventory.data.AppConstants
import com.wekanmdb.storeinventory.databinding.FragmentInventoryBinding
import com.wekanmdb.storeinventory.model.storeInventory.StoreInventory
import io.realm.RealmResults
import kotlinx.android.synthetic.main.fragment_inventory.*
import org.bson.types.ObjectId


class InventoryFragment : BaseFragment<FragmentInventoryBinding>(), InventoryNavigator,FilterInventoryAdapter.ClickInventoryItem,
    TextWatcher, InventoryAdapter.ClickInventoryItem {

    private lateinit var fragmentInventoryBinding: FragmentInventoryBinding
    private lateinit var inventoryViewModel: InventoryViewModel
    private var inventoryAdapter: InventoryAdapter? = null
    private var filterPagerAdapter: FilterInventoryAdapter? = null
    private var storeId: ObjectId? = null

    override val layoutId: Int
        get() = R.layout.fragment_inventory

    override fun initView(mRootView: View?, mViewDataBinding: ViewDataBinding?) {
        fragmentInventoryBinding = mViewDataBinding as FragmentInventoryBinding
        inventoryViewModel =
            ViewModelProvider(this, viewModelFactory).get(InventoryViewModel::class.java)
        fragmentInventoryBinding.inventoryViewModel = inventoryViewModel
        inventoryViewModel.navigator = this
        et_search.addTextChangedListener(this)

        storeId = user?.customData?.getObjectId("stores")
        inventoryViewModel.storeId.set(storeId.toString())

        inventoryAdapter = InventoryAdapter(requireContext(), this)
        mViewDataBinding.inventoryAdapter = inventoryAdapter

        filterPagerAdapter = FilterInventoryAdapter(requireContext(), this)
        rv_pager.setAdapter(filterPagerAdapter)

        getStore()
        getInventoryList()
    }

    // Query Realm for all StoreDetails
    private fun getStore() {
        inventoryViewModel.storesresponseBody.observe(this, { storedetails ->
            if (storedetails != null) {
                fragmentInventoryBinding.stores = storedetails
                fragmentInventoryBinding.executePendingBindings()
            } else {
                showToast("No more Data")
            }
        })
        inventoryViewModel.getStore()
        inventoryViewModel.storeListener()
    }

    // Query Realm for all StoreInventorylist
    private fun getInventoryList() {
        inventoryViewModel.inventoryresponseBody.observe(this, { inventoryList ->
            // Listeners will be notified when data changes
            if (inventoryList != null && inventoryList.size > 0) {
                val item = inventoryList.filter { it.quantity!! <= 5 }
                localAlert(item)
                setView(inventoryList)
            } else {
                showToast("No More  data")
            }
        })
        inventoryViewModel.getInventoryList()
        inventoryViewModel.inventoryListener()
    }

    // Query Realm for all StoreInventory less than 5 quantity
    private fun localAlert(storeInventoryitem: List<StoreInventory>) {
        if (storeInventoryitem != null && storeInventoryitem.size > 0) {
            mViewDataBinding!!.executePendingBindings()
            filterPagerAdapter!!.setBannerItemList(storeInventoryitem)
        }
    }

    private fun setView(inventoryList: RealmResults<StoreInventory>?) {
        textView31.text = "Total Items : ${inventoryList?.size}"
        inventoryAdapter!!.setInventoryAdapter(inventoryList!!)
    }

    // Query Realm for all filter in productName
    private fun filter() {
        inventoryViewModel.getFilterSearch().observe(this, { searchInventoryList ->
            setView(searchInventoryList)
        })
    }

    override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
    }

    override fun onTextChanged(s: CharSequence?, p1: Int, p2: Int, p3: Int) {
        if (s!!.length == 0) {
            getInventoryList()
            return
        }
        inventoryViewModel.searchproductName.set(s.toString())
        filter()
    }

    override fun afterTextChanged(p0: Editable?) {
    }

    // Click on serachview
    override fun searchClick() {
        tv_store_name.visibility = View.INVISIBLE
        et_search.visibility = View.VISIBLE
    }

    override fun onItemClick(productId: String, productName: String, quantity: String) {
        val bundle = Bundle()
        bundle.putString(AppConstants.PRODUCTID, productId)
        bundle.putString(AppConstants.PRODUCTNAME, productName)
        bundle.putString(AppConstants.TOTALQUANTITY, quantity)
        NavHostFragment.findNavController(requireParentFragment())
            .navigate(R.id.navigation_product_details, bundle)
    }
}