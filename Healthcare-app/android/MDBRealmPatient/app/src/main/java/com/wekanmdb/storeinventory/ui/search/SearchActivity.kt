package com.wekanmdb.storeinventory.ui.search

import android.content.Intent
import android.widget.SearchView
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivitySearchBinding
import com.wekanmdb.storeinventory.model.code.Code
import com.wekanmdb.storeinventory.model.condition.Condition
import com.wekanmdb.storeinventory.utils.Constants.Companion.Code
import com.wekanmdb.storeinventory.utils.Constants.Companion.Data
import com.wekanmdb.storeinventory.utils.Constants.Companion.Id
import com.wekanmdb.storeinventory.utils.Constants.Companion.SEARCH_CONCERN
import com.wekanmdb.storeinventory.utils.Constants.Companion.SEARCH_CONDITION
import com.wekanmdb.storeinventory.utils.Constants.Companion.SEARCH_TYPE
import com.wekanmdb.storeinventory.utils.Constants.Companion.System
import io.realm.Case
import io.realm.RealmResults
import io.realm.kotlin.where
import kotlinx.android.synthetic.main.activity_search.*
import kotlinx.android.synthetic.main.common_toolbar.*
import org.bson.types.ObjectId

/**
 * This class is used to search Product, Organization, Users
 * depending on the search type different schema object can be searched.
 */

class SearchActivity : BaseActivity<ActivitySearchBinding>() {
    private lateinit var activitySearchBinding: ActivitySearchBinding

    private lateinit var conditionsListAdapter: ConditionsAdapter
    private lateinit var concernAdapter: ConcernAdapter
    private lateinit var searchActivityViewModel: SearchActivityViewModel
    override fun getLayoutId(): Int = R.layout.activity_search

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activitySearchBinding = mViewDataBinding as ActivitySearchBinding
        searchActivityViewModel = ViewModelProvider(this).get(SearchActivityViewModel::class.java)
        /**
         * Depending on intent value change the search type
         * eg. Product, Users, Organization
         * and assignee the respective adapter &
         * add listener to search query
         */
        if (intent.extras != null) {
            val searchType = intent.getStringExtra(SEARCH_TYPE)
            when (searchType) {

                SEARCH_CONDITION -> initConditionAdapter()
                SEARCH_CONCERN -> initConcernAdapter()
            }
            initListeners(searchType)
        }
        img_back.setOnClickListener {
            finish()
        }
    }

    //Initializing the recyclerview adapter in the basic patient info screen
    private fun initConditionAdapter() {
        conditionsListAdapter = ConditionsAdapter(this) {}
        recycler.apply {
            layoutManager = LinearLayoutManager(this@SearchActivity)
            addItemDecoration(
                DividerItemDecoration(
                    this@SearchActivity,
                    DividerItemDecoration.VERTICAL
                )
            )
            adapter = conditionsListAdapter
        }
        addDataToConditionsAdapter()
    }

    //Initializing the recyclerview adapter in the available slot activity
    private fun initConcernAdapter() {
        concernAdapter = ConcernAdapter(this) {

        }
        recycler.apply {
            layoutManager = LinearLayoutManager(this@SearchActivity)
            addItemDecoration(
                DividerItemDecoration(
                    this@SearchActivity,
                    DividerItemDecoration.VERTICAL
                )
            )
            adapter = concernAdapter
        }
        addDataToConcernAdapter()
    }

    //Getting condition list and pass it to the recycler adapter
    private fun addDataToConditionsAdapter() {
        searchActivityViewModel.getAllConditions()
        searchActivityViewModel.conditionsresponseBody.observe(this, Observer {
            if (it != null) {
                conditionsListAdapter.addData(it)
            }
        })
    }

    //Getting condition list and pass it to the recycler adapter
    private fun addDataToConcernAdapter() {
        searchActivityViewModel.getAllConcerns()
        searchActivityViewModel.concernResponseBody.observe(this, Observer {
            if (it != null) {
                concernAdapter.addData(it)
            }
        })
    }

    //Text change listener of SearchBar
    private fun initListeners(searchType: String?) {
        search.setOnQueryTextListener(object : SearchView.OnQueryTextListener,
            androidx.appcompat.widget.SearchView.OnQueryTextListener {
            override fun onQueryTextSubmit(query: String?): Boolean {
                query?.let {
                    // dosendBackData(it)
                }
                return true
            }

            override fun onQueryTextChange(newText: String?): Boolean {
                newText?.let {
                    when (searchType) {

                        SEARCH_CONDITION -> conditionAdapter(newText)
                        SEARCH_CONCERN -> concernAdapter()
                    }
                }
                return true
            }
        }
        )
    }

    /*
    *Equals the Searched text in the query and pass to the adapter */
    private fun conditionAdapter(searchedItem: String) {
        val code =
            apprealm?.where<Code>()?.contains("name", searchedItem, Case.INSENSITIVE)
                ?.equalTo("category", "conditions")?.findAll()
        conditionsListAdapter.addData(code!! as RealmResults<Code>)
        conditionsListAdapter.notifyDataSetChanged()
    }

    /*
    *getting condition by Equals the Patient id in the query  and pass to the adapter */
    private fun concernAdapter() {
        val id = user?.customData?.get("referenceId") as ObjectId

        val code = apprealm?.where<Condition>()?.equalTo("subject.identifier", id)?.findAll()
        concernAdapter.addData(code!! as RealmResults<Condition>)
        concernAdapter.notifyDataSetChanged()
    }

    /*
    * Passing these data back to the result activity*/
    fun updateSpeciality(name: String, code: String, system: String, id: String) {
        val output = Intent()
        output.putExtra(Data, name)
        output.putExtra(Code, code)
        output.putExtra(Id, id)
        output.putExtra(System, system)
        setResult(RESULT_OK, output)
        finish()
    }

    /*
       * Passing these data back to the result activity*/
    fun updateConcern(name: String, notes: String, id: String) {
        val output = Intent()
        output.putExtra(Data, name)
        output.putExtra(Code, notes)
        output.putExtra(Id, id)
        setResult(RESULT_OK, output)
        finish()
    }
}
