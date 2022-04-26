package com.wekanmdb.storeinventory.ui.createjobs

import android.content.Intent
import android.util.Log
import android.widget.SearchView
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.storerealm
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivitySearchBinding
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.model.storeInventory.StoreInventory
import com.wekanmdb.storeinventory.model.user.Users
import com.wekanmdb.storeinventory.ui.inventory.InventoryFragment.Companion.selectedStoreId
import com.wekanmdb.storeinventory.utils.Constants.Companion.DELIVERY_USER_ROLE
import com.wekanmdb.storeinventory.utils.Constants.Companion.SEARCH_ASSIGNEE
import com.wekanmdb.storeinventory.utils.Constants.Companion.SEARCH_PRODUCT
import com.wekanmdb.storeinventory.utils.Constants.Companion.SEARCH_STORE
import com.wekanmdb.storeinventory.utils.Constants.Companion.SEARCH_TYPE
import io.realm.Case
import io.realm.RealmResults
import io.realm.kotlin.where
import kotlinx.android.synthetic.main.activity_search.*
import org.bson.types.ObjectId

/**
 * This class is used to search Product, Stores, Users
 * depending on the search type different schema object can be searched.
 */

class SearchActivity : BaseActivity<ActivitySearchBinding>() {
    private lateinit var activitySearchBinding: ActivitySearchBinding
    private lateinit var productSearchAdapter: ProductSearchAdapter
    private lateinit var assigneeSearchAdapter : AssigneeSearchAdapter
    private lateinit var storeSearchAdapter: StoreSearchAdapter
    private lateinit var searchActivityViewModel: SearchActivityViewModel
    private lateinit var storeId: ObjectId
    override fun getLayoutId(): Int = R.layout.activity_search

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activitySearchBinding = mViewDataBinding as ActivitySearchBinding
        searchActivityViewModel = ViewModelProvider(this, viewModelFactory).get(SearchActivityViewModel::class.java)
        activitySearchBinding.searchActivityViewModel = searchActivityViewModel
        /**
         * Depending on intent value change the search type
         * eg. Product, Users, Stores
         * and assignee the respective adapter &
         * add listener to search query
         */
        storeId = selectedStoreId!!
        if(intent.extras!=null){
            val searchType = intent.getStringExtra(SEARCH_TYPE)
            when(searchType){
                SEARCH_PRODUCT-> initProductAdapter()
                SEARCH_ASSIGNEE-> initAssigneeAdapter()
                SEARCH_STORE-> initStoreAdapter()
            }
            initListeners(searchType)
        }
        activitySearchBinding.commonCreateJob.setOnClickListener {
            finish()
        }


    }

    private fun initStoreAdapter() {
        searchame.text="Select Store"
        storeSearchAdapter= StoreSearchAdapter(this)
        recycler.apply {
            layoutManager = LinearLayoutManager(this@SearchActivity)
            addItemDecoration(DividerItemDecoration(this@SearchActivity, DividerItemDecoration.VERTICAL))
            adapter = storeSearchAdapter
        }
        val sourceStoreId =selectedStoreId
       if (sourceStoreId != null) {
            addDataToStoreAdapter(sourceStoreId)
        }
        searchActivityViewModel.storeListListener()
    }

    private fun addDataToStoreAdapter(sourceStoreId:ObjectId) {
        searchActivityViewModel.getStore(sourceStoreId).observe(this){
            if (it != null) {
                storeSearchAdapter.addData(it)
            }
            Log.d("wekanc", it.toString())
        }

    }

    private fun initAssigneeAdapter() {
        searchame.text="Select User"
        assigneeSearchAdapter= AssigneeSearchAdapter(this)
        recycler.apply {
            layoutManager = LinearLayoutManager(this@SearchActivity)
            addItemDecoration(DividerItemDecoration(this@SearchActivity, DividerItemDecoration.VERTICAL))
            adapter = assigneeSearchAdapter
        }
        addDataToAssigneeAdapter()
        searchActivityViewModel.assigneeListListener()
    }

    private fun addDataToAssigneeAdapter() {
        searchActivityViewModel.getAssignees().observe(this){
            if (it != null) {
                assigneeSearchAdapter.addData(it)
            }
            Log.d("wekanc", it.toString())
        }
    }

    private fun initProductAdapter() {
        searchame.text="Select Product"
        productSearchAdapter= ProductSearchAdapter(this)
        recycler.apply {
            layoutManager = LinearLayoutManager(this@SearchActivity)
       //     addItemDecoration(DividerItemDecoration(this@SearchActivity, DividerItemDecoration.VERTICAL))
            adapter = productSearchAdapter
        }
        addDataToProductAdapter()
        searchActivityViewModel.storeInventoryListListener()
    }

    private fun addDataToProductAdapter() {

        searchActivityViewModel.getProducts(storeId!!).observe(this){
            if (it != null) {
                productSearchAdapter.addData(it)
            }
        }
    }



    private fun initListeners(searchType: String?) {
        search.setOnQueryTextListener(object : SearchView.OnQueryTextListener, androidx.appcompat.widget.SearchView.OnQueryTextListener {
            override fun onQueryTextSubmit(query: String?): Boolean {
                query?.let {
                   // dosendBackData(it)
                }
                return true
            }

            override fun onQueryTextChange(newText: String?): Boolean {
                newText?.let {
                    when(searchType){
                        SEARCH_PRODUCT-> listenProductAdapter(newText,storeId)
                        SEARCH_ASSIGNEE-> listenAssigneeAdapter(newText)
                        SEARCH_STORE-> listenStoreAdapter(newText)
                    }
                }
                return true
            }
        }
        )
    }

    private fun listenAssigneeAdapter(searchedItem: String) {
        val users =
            apprealm?.where<Users>()?.equalTo("userRole", DELIVERY_USER_ROLE)
                ?.contains("firstName", searchedItem,Case.INSENSITIVE)
                ?.findAllAsync()
        assigneeSearchAdapter.addData(users!! as RealmResults<Users>)
        assigneeSearchAdapter.notifyDataSetChanged()
    }

    private fun listenStoreAdapter(searchedItem: String) {
        val stores =
            apprealm?.where<Stores>()?.contains("name", searchedItem,Case.INSENSITIVE)?.notEqualTo("_id", storeId)?.findAllAsync()
        storeSearchAdapter.addData(stores!! as RealmResults<Stores>)
        storeSearchAdapter.notifyDataSetChanged()
    }

    private fun listenProductAdapter(searchedItem: String, storeId: ObjectId) {
        val storeInventoryList =
            storerealm?.where<StoreInventory>()?.equalTo("storeId", storeId)?.contains("productName", searchedItem,Case.INSENSITIVE)?.findAllAsync()
        productSearchAdapter.addData(storeInventoryList!! as RealmResults<StoreInventory>)
        productSearchAdapter.notifyDataSetChanged()
    }

    fun updateProduct(id: String, name: String?, totalQuantity: Int?, image: String?, ) {
        val output = Intent()
        output.putExtra("id",id)
        output.putExtra("name",name)
        output.putExtra("quantity",totalQuantity)
        output.putExtra("image",image)
        setResult(RESULT_OK,output)
        finish()
    }
    fun updateAssignee(name: String, assigneeId: String){
        val output = Intent()
        output.putExtra("data",name)
        output.putExtra("id",assigneeId)
        setResult(RESULT_OK,output)
        finish()
    }
    fun updateStore(name: String, storeId: String){
        val output = Intent()
        output.putExtra("data",name)
        output.putExtra("id",storeId)
        setResult(RESULT_OK,output)
        finish()
    }


}
