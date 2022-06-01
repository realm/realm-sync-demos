package com.wekanmdb.storeinventory.ui.search

import android.content.Intent
import android.util.Log
import android.view.View
import android.widget.SearchView
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivitySearchBinding
import com.wekanmdb.storeinventory.model.code.Code
import com.wekanmdb.storeinventory.model.organization.Organization
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import com.wekanmdb.storeinventory.ui.home.HomeActivity
import com.wekanmdb.storeinventory.utils.Constants.Companion.NURSE
import com.wekanmdb.storeinventory.utils.Constants.Companion.SEARCH_CATGORY
import com.wekanmdb.storeinventory.utils.Constants.Companion.SEARCH_ORG
import com.wekanmdb.storeinventory.utils.Constants.Companion.SEARCH_CODE
import com.wekanmdb.storeinventory.utils.Constants.Companion.SEARCH_PRACTITIONER
import com.wekanmdb.storeinventory.utils.Constants.Companion.SEARCH_TYPE
import io.realm.Case
import io.realm.RealmResults
import io.realm.kotlin.where
import kotlinx.android.synthetic.main.activity_search.*

/**
 * This class is used to search Product, Organization, Users
 * depending on the search type different schema object can be searched.
 */

class SearchActivity : BaseActivity<ActivitySearchBinding>() {
    private lateinit var activitySearchBinding: ActivitySearchBinding

    private lateinit var organizationSearchAdapter: OrganizationListAdapter
    private lateinit var codeListAdapter: CodeListAdapter
    private lateinit var practitionerAdapter: PractitionerAdapter
    private lateinit var searchActivityViewModel: SearchActivityViewModel
    override fun getLayoutId(): Int = R.layout.activity_search
    var category = ""
    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activitySearchBinding = mViewDataBinding as ActivitySearchBinding
        searchActivityViewModel = ViewModelProvider(this).get(SearchActivityViewModel::class.java)
        /**
         * Depending on intent value change the search type
         * eg. Organization,Code and Practitioner
         * the respective adapter &
         * add listener to search query
         */
        if (intent.extras != null) {
            val searchType = intent.getStringExtra(SEARCH_TYPE)
            category = intent.getStringExtra(SEARCH_CATGORY).toString()
            when (searchType) {

                SEARCH_ORG -> initOrganizationAdapter()
                SEARCH_CODE -> initSpecialityAdapter()
                SEARCH_PRACTITIONER -> initPractitionerAdapter()
            }
            initListeners(searchType)
        }
        activitySearchBinding.commonCreateJob.setOnClickListener {
            finish()
        }


    }

    private fun initOrganizationAdapter() {
        activitySearchBinding.add.visibility = View.VISIBLE
        organizationSearchAdapter = OrganizationListAdapter(this) {

        }
        recycler.apply {
            layoutManager = LinearLayoutManager(this@SearchActivity)
            addItemDecoration(
                DividerItemDecoration(
                    this@SearchActivity,
                    DividerItemDecoration.VERTICAL
                )
            )
            adapter = organizationSearchAdapter
        }
        //if (sourceStoreId != null) {
        addDataToOrgAdapter()
        // }
        activitySearchBinding.add.setOnClickListener {
            val output = Intent()
            setResult(RESULT_OK, output)
            finish()
        }
    }

    private fun initSpecialityAdapter() {
        codeListAdapter = CodeListAdapter(this) {

        }
        recycler.apply {
            layoutManager = LinearLayoutManager(this@SearchActivity)
            addItemDecoration(
                DividerItemDecoration(
                    this@SearchActivity,
                    DividerItemDecoration.VERTICAL
                )
            )
            adapter = codeListAdapter
        }
        addDataToSpecialityAdapter()


    }

    private fun initPractitionerAdapter() {
        practitionerAdapter = PractitionerAdapter(this) {

        }
        recycler.apply {
            layoutManager = LinearLayoutManager(this@SearchActivity)
            addItemDecoration(
                DividerItemDecoration(
                    this@SearchActivity,
                    DividerItemDecoration.VERTICAL
                )
            )
            adapter = practitionerAdapter
        }
        addDataToPractitionerAdapter()


    }


    private fun addDataToOrgAdapter() {
        searchActivityViewModel.getAllOrganization()
        searchActivityViewModel.organizationresponseBody.observe(this, Observer {
            if (it != null) {
                organizationSearchAdapter.addData(it)
            }
            Log.d("wekanc", it.toString())
        })
    }

    private fun addDataToSpecialityAdapter() {
        searchActivityViewModel.getAllSpeciality(category)
        searchActivityViewModel.specialityresponseBody.observe(this, Observer {
            if (it != null) {
                codeListAdapter.addData(it)
            }
            Log.d("wekanc", it.toString())
        })
    }

    private fun addDataToPractitionerAdapter() {
        searchActivityViewModel.getAllPractitioner()
        searchActivityViewModel.practitionerresponseBody.observe(this, Observer {
            if (it != null) {
                practitionerAdapter.addData(it)
            }
            Log.d("wekanc", it.toString())
        })
    }


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

                        SEARCH_ORG -> organizationAdapter(newText)
                        SEARCH_CODE -> codeAdapter(newText)
                        SEARCH_PRACTITIONER -> practitionerAdapter(newText)
                    }
                }
                return true
            }
        }
        )
    }


    private fun organizationAdapter(searchedItem: String) {
        val organization =
            apprealm?.where<Organization>()?.contains("name", searchedItem, Case.INSENSITIVE)
                ?.findAllAsync()
        organizationSearchAdapter.addData(organization!! as RealmResults<Organization>)
        organizationSearchAdapter.notifyDataSetChanged()
    }

    private fun codeAdapter(searchedItem: String) {
        val code =
            apprealm?.where<Code>()?.contains("name", searchedItem, Case.INSENSITIVE)
                ?.equalTo("category", category)?.findAll()
        codeListAdapter.addData(code!! as RealmResults<Code>)
        codeListAdapter.notifyDataSetChanged()
    }

    private fun practitionerAdapter(searchedItem: String) {
        val res =
            apprealm?.where<PractitionerRole>()
                ?.contains("practitioner.name.text", searchedItem, Case.INSENSITIVE)
                ?.equalTo("organization._id", HomeActivity.orgId)
                ?.equalTo("code.coding.code", NURSE)?.findAll()

        practitionerAdapter.addData(res!! as RealmResults<PractitionerRole>)
        practitionerAdapter.notifyDataSetChanged()
    }


    fun updateCode(name: String, id: String, code: String, system: String) {
        val output = Intent()
        output.putExtra("data", name)
        output.putExtra("id", id)
        output.putExtra("code", code)
        output.putExtra("system", system)
        setResult(RESULT_OK, output)
        finish()
    }

    fun updatePractitioner(name: String, id: String, identifier: String) {
        val output = Intent()
        output.putExtra("data", name)
        output.putExtra("id", id)
        output.putExtra("identifier", identifier)
        setResult(RESULT_OK, output)
        finish()
    }


}
