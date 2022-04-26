package com.wekanmdb.storeinventory.ui.inventory

import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.NavHostFragment
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.storerealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseFragment
import com.wekanmdb.storeinventory.data.AppConstants
import com.wekanmdb.storeinventory.databinding.FragmentInventoryBinding
import com.wekanmdb.storeinventory.databinding.StoreListBottomSheetBinding
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.model.storeInventory.StoreInventory
import com.wekanmdb.storeinventory.utils.RealmUtils
import io.realm.Realm
import io.realm.RealmResults
import kotlinx.android.synthetic.main.fragment_inventory.*
import org.bson.types.ObjectId


class InventoryFragment : BaseFragment<FragmentInventoryBinding>(), InventoryNavigator,
    FilterInventoryAdapter.ClickInventoryItem,
    TextWatcher, InventoryAdapter.ClickInventoryItem {

    private lateinit var fragmentInventoryBinding: FragmentInventoryBinding
    private lateinit var inventoryViewModel: InventoryViewModel
    private var inventoryAdapter: InventoryAdapter? = null
    private var filterPagerAdapter: FilterInventoryAdapter? = null
    private var storesAdapter: StoresAdapter? = null
    private var selectedStore: Stores? = null
    private var storesList = mutableListOf<Stores>()
    private lateinit var storeListBottomSheetBinding: StoreListBottomSheetBinding

    override val layoutId: Int
        get() = R.layout.fragment_inventory

    companion object {
        var selectedStoreId: ObjectId? = null
    }

    override fun initView(mRootView: View?, mViewDataBinding: ViewDataBinding?) {
        fragmentInventoryBinding = mViewDataBinding as FragmentInventoryBinding
        inventoryViewModel =
            ViewModelProvider(this, viewModelFactory).get(InventoryViewModel::class.java)
        fragmentInventoryBinding.inventoryViewModel = inventoryViewModel
        inventoryViewModel.navigator = this
        et_search.addTextChangedListener(this)

        inventoryAdapter = InventoryAdapter(requireContext(), this)
        mViewDataBinding.inventoryAdapter = inventoryAdapter

        getStore()

        fragmentInventoryBinding.imageView12.setOnClickListener {
            storesList.let { it1 -> storesBottomSheet(it1) }
        }
    }

    // Query Realm for all StoreDetails
    private fun getStore() {
        inventoryViewModel.getAllStores()

        inventoryViewModel.storesList.observe(this, { list ->
            if (list != null) {
                val store = if (selectedStoreId == null) {
                    list.first()
                } else {
                    list.find { it._id == selectedStoreId }
                }
                fragmentInventoryBinding.tvStoreName.text = store!!.name
                updateStore(store)
                fragmentInventoryBinding.stores = store
                fragmentInventoryBinding.executePendingBindings()
                storesList = list
            }
        })


        inventoryViewModel.storeListener()
    }

    // update store realm object
    private fun updateStore(storedetails: Stores) {

        Realm.getInstanceAsync(
            RealmUtils.getRealmconfig(
                AppConstants.INVENTORYPARTITIONVALUE + storedetails._id.toString()
            ), object : Realm.Callback() {
                override fun onSuccess(realm: Realm) {
                    storerealm = realm
                    getInventoryList(storedetails)
                }
            })
    }

    // Query Realm for all StoreInventorylist
    private fun getInventoryList(storedetails: Stores) {

        inventoryViewModel.inventoryresponseBody.observe(this, { inventoryList ->
            // Listeners will be notified when data changes
            if (inventoryList != null && inventoryList.size > 0) {
                val store = inventoryList.find { it.storeId == storedetails._id }
                if (store != null) {
                    selectedStore = storedetails
                    selectedStoreId = selectedStore!!._id

                    inventoryViewModel.storeId.set(selectedStoreId.toString())
                    fragmentInventoryBinding.tvStoreName.text = storedetails.name
                    val item = inventoryList.filter { it.quantity!! <= 5 }
                    localAlert(item)
                    setView(inventoryList)
                }
            } else {
                showToast("No More  data")
            }
        })
        inventoryViewModel.getInventoryList(storedetails)
        inventoryViewModel.inventoryListener()
    }

    // Query Realm for all StoreInventory less than 5 quantity
    private fun localAlert(storeInventoryitem: List<StoreInventory>) {

        filterPagerAdapter = FilterInventoryAdapter(requireContext(), this)
        rv_pager.adapter = filterPagerAdapter
        if (storeInventoryitem != null && storeInventoryitem.isNotEmpty()) {
            mViewDataBinding!!.executePendingBindings()
            filterPagerAdapter!!.setBannerItemList(storeInventoryitem)
        }
    }

    private fun setView(inventoryList: RealmResults<StoreInventory>?) {
        if (inventoryList?.isNotEmpty() == true)
            textView31.visibility = View.VISIBLE

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
            fragmentInventoryBinding.stores?.let {
                updateStore(it)
            }

            return
        }
        inventoryViewModel.searchproductName.set(s.toString())
        filter()
    }

    override fun afterTextChanged(p0: Editable?) {
    }

    // Click on serachview
    override fun searchClick() {

    }

    override fun onItemClick(
        inventryId: String,
        productId: String,
        productName: String,
        quantity: String
    ) {
        val bundle = Bundle()
        bundle.putString(AppConstants.STOREINVENTRYID, inventryId)
        bundle.putString(AppConstants.PRODUCTID, productId)
        bundle.putString(AppConstants.PRODUCTNAME, productName)
        bundle.putString(AppConstants.TOTALQUANTITY, quantity)
        NavHostFragment.findNavController(requireParentFragment())
            .navigate(R.id.navigation_product_details, bundle)
    }

    private fun storesBottomSheet(storesList: MutableList<Stores>) {
        storeListBottomSheetBinding =
            StoreListBottomSheetBinding.inflate(LayoutInflater.from(activity))
        val alertDialog = activity?.let { BottomSheetDialog(it) }
        alertDialog!!.setContentView(storeListBottomSheetBinding.root)
        storesAdapter = StoresAdapter(requireContext()) {
            updateStore(it)
        }
        //Sending selected store for to set selected item enabled
        storesAdapter!!.addData(storesList.filter { it.name.isNotEmpty() }, selectedStore)
        storeListBottomSheetBinding.storesList.apply {
            layoutManager = LinearLayoutManager(requireContext())
            adapter = storesAdapter
        }
        storeListBottomSheetBinding.imageView34.setOnClickListener {
            alertDialog.dismiss()
        }

        alertDialog.show()
    }


}