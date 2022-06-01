package com.wekanmdb.storeinventory.ui.signup

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.view.View
import androidx.activity.result.contract.ActivityResultContracts
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityWelcomeBinding
import com.wekanmdb.storeinventory.model.organization.Organization
import com.wekanmdb.storeinventory.ui.home.HomeActivity
import com.wekanmdb.storeinventory.ui.search.SearchActivity
import com.wekanmdb.storeinventory.utils.Constants
import com.wekanmdb.storeinventory.utils.Constants.Companion.NURSE
import com.wekanmdb.storeinventory.utils.Constants.Companion.USER_TYPE
import io.realm.RealmList
import kotlinx.android.synthetic.main.activity_search.*

class OrganizationUpdateActivity : BaseActivity<ActivityWelcomeBinding>() {
    companion object {
        fun getCallingIntent(context: Context): Intent {
            return Intent(context, OrganizationUpdateActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        var selectedItems: RealmList<Organization> = RealmList()
    }

    private var specialityCode = ""
    private var specialitySystem = ""
    private lateinit var selectedOrganizationListAdapter: SelectedOrganizationListAdapter
    private lateinit var activityWelcomeBinding: ActivityWelcomeBinding
    private lateinit var signupViewModel: SignupViewModel
    override fun getLayoutId(): Int = R.layout.activity_welcome

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityWelcomeBinding = mViewDataBinding as ActivityWelcomeBinding
        signupViewModel = ViewModelProvider(this).get(SignupViewModel::class.java)
        activityWelcomeBinding.signupViewModel = signupViewModel
        initAdapter()
        setOnClickListener()
        updateScree()


    }

    private fun updateScree() {
        user!!.customData[USER_TYPE]?.toString().let {
            if(it.equals(NURSE,true)){
                activityWelcomeBinding.textView.visibility= View.GONE
                activityWelcomeBinding.textView2.visibility= View.GONE
            }
        }

    }

    private fun setOnClickListener() {
        activityWelcomeBinding.textView2.setOnClickListener {
            val searchIntent = Intent(this, SearchActivity::class.java)
            searchIntent.putExtra(Constants.SEARCH_TYPE, Constants.SEARCH_CODE)
            searchIntent.putExtra(Constants.SEARCH_CATGORY, Constants.SPECIALITY)
            codeSearchLauncher.launch(searchIntent)
        }
        activityWelcomeBinding.textView37.setOnClickListener {
            val searchIntent = Intent(this, SearchActivity::class.java)
            searchIntent.putExtra(Constants.SEARCH_TYPE, Constants.SEARCH_ORG)
            organizationSearchLauncher.launch(searchIntent)
        }

        activityWelcomeBinding.textView38.setOnClickListener {

            signupViewModel.updateOrganization(
                activityWelcomeBinding.textView2.text.toString(),
                specialityCode,
                specialitySystem,
                selectedItems
            ).observe(this) {
                if (it) {
                    startActivity(HomeActivity.getCallingIntent(this))
                    finish()
                }
            }
        }
    }

    private fun initAdapter() {
        selectedOrganizationListAdapter = SelectedOrganizationListAdapter(this) {

        }
        activityWelcomeBinding.recyclerView.apply {
            layoutManager = LinearLayoutManager(this@OrganizationUpdateActivity)
            addItemDecoration(
                DividerItemDecoration(
                    this@OrganizationUpdateActivity,
                    DividerItemDecoration.VERTICAL
                )
            )
            adapter = selectedOrganizationListAdapter
        }
        addDataToAdapter()


    }

    private fun addDataToAdapter() {
        selectedOrganizationListAdapter.addData(selectedItems)
    }

    private var codeSearchLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val data: Intent? = result.data
                if (data != null) {
                    specialityCode = data.getStringExtra("code") as String
                    specialitySystem = data.getStringExtra("system") as String
                    activityWelcomeBinding.textView2.text = data.getStringExtra("data")
                }
            }
        }

    private var organizationSearchLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val data: Intent? = result.data
                if (data != null) {
                    data.getStringExtra("data")
                    val id = data.getStringExtra("id")
                    addDataToAdapter()
                }
            }
        }

}
