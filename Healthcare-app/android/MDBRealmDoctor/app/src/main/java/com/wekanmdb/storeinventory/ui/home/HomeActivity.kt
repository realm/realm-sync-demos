package com.wekanmdb.storeinventory.ui.home

import android.annotation.SuppressLint
import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.text.Editable
import android.text.TextWatcher
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.view.menu.MenuBuilder
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.ui.AppBarConfiguration
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityHomeBinding
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import com.wekanmdb.storeinventory.ui.consultation.ConsultationActivity
import com.wekanmdb.storeinventory.ui.login.LoginActivity
import com.wekanmdb.storeinventory.ui.profile.ProfileActivity
import com.wekanmdb.storeinventory.ui.signup.OrganizationUpdateActivity
import kotlinx.android.synthetic.main.activity_home.*
import kotlinx.android.synthetic.main.dialog_logout.*
import org.bson.types.ObjectId


class HomeActivity : BaseActivity<ActivityHomeBinding>(), HomeNavigator , TextWatcher {
    companion object {
        fun getCallingIntent(context: Context): Intent {
            return Intent(context, HomeActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        var orgId:ObjectId?=null
    }

    private lateinit var organizationsAdapter: OrganizationsAdapter
    private lateinit var activityHomeBinding: ActivityHomeBinding
    private lateinit var homeViewModel: HomeViewModel
    private lateinit var appBarConfiguration: AppBarConfiguration
    var practitionerList: List<PractitionerRole>? = null
    override fun getLayoutId(): Int = R.layout.activity_home

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityHomeBinding = mViewDataBinding as ActivityHomeBinding
        homeViewModel = ViewModelProvider(this, viewModelFactory).get(HomeViewModel::class.java)
        activityHomeBinding.homeViewModel = homeViewModel
        homeViewModel.navigator = this
        // make sure to set the toolbar
        setSupportActionBar(activityHomeBinding.toolbar)
        supportActionBar?.setDisplayShowTitleEnabled(false)
        activityHomeBinding.etSearch.addTextChangedListener(this)
        initAdapter()
        getOrganizations()
    }
    @SuppressLint("RestrictedApi")
    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        if (menu is MenuBuilder) menu.setOptionalIconsVisible(true)
        menuInflater.inflate(R.menu.menu_main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            R.id.doctor_info ->
            {
                startActivity(Intent(this,ProfileActivity::class.java))
            }

            R.id.logout -> logout()

        }
        return super.onOptionsItemSelected(item)
    }

    private fun getOrganizations() {
        //Checking the practitioner's organization has been added or not
        homeViewModel.getPracctitionerRole(user?.customData?.get("referenceId") as ObjectId)
        homeViewModel.practitionerRoleresponseBody.observe(this,
            { result ->
                practitionerList=result
                organizationsAdapter.addData(result)
            })


    }

    private fun initAdapter() {
        organizationsAdapter = OrganizationsAdapter(this) {
            orgId=it.organization!!._id
            startActivity( Intent(this,ConsultationActivity::class.java)
                .putExtra("_id",it.organization!!._id.toString())
                .putExtra("name",it.organization!!.name))
        }

        activityHomeBinding.orgRecycler.apply {
            layoutManager = LinearLayoutManager(this@HomeActivity)
            addItemDecoration(
                DividerItemDecoration(
                    this@HomeActivity,
                    DividerItemDecoration.VERTICAL
                )
            )
            adapter = organizationsAdapter
        }


    }

    override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {
    }

    override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
    }

    override fun afterTextChanged(s: Editable?) {
        if (s!!.isEmpty()) {
            practitionerList
        }else {
            practitionerList?.filter { it.organization!!.name!!.contains(s.toString()) }

        }.let {
            organizationsAdapter.addData(it)
        }
    }
    // logout fuction
    private fun logout() {
        val dialoglogout = Dialog(this, R.style.dialog_center)
        dialoglogout.setCancelable(false)
        dialoglogout.setContentView(R.layout.dialog_logout)
        dialoglogout.show()
        val no = dialoglogout.textView23
        val yes = dialoglogout.textView24
        no.setOnClickListener {
            dialoglogout.dismiss()
        }
        yes.setOnClickListener {
            user?.logOutAsync { logout ->
                if (logout.isSuccess) {
                    apprealm?.close()
                    user = null
                    startActivity(
                        LoginActivity.getCallingIntent(this)
                            .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    )
                    dialoglogout.dismiss()
                } else {
                    showToast("log out failed! Error: ${logout.error}")
                }
            }
        }
    }
}