package com.wekanmdb.storeinventory.ui.listOfHospitals

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
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityHospitalsBinding
import com.wekanmdb.storeinventory.model.organization.Organization
import com.wekanmdb.storeinventory.ui.consultation.ConsultationActivity
import com.wekanmdb.storeinventory.ui.login.LoginActivity
import com.wekanmdb.storeinventory.ui.patientBasicInfo.PatientInfoActivity
import com.wekanmdb.storeinventory.ui.profile.ProfileActivity
import io.realm.RealmResults
import kotlinx.android.synthetic.main.activity_hospitals.*
import kotlinx.android.synthetic.main.dialog_logout.*

class ListOfHospitalsActivity : BaseActivity<ActivityHospitalsBinding>(),
    ListOfHospitalNavigator, TextWatcher {

    private lateinit var activityHospitalsBinding: ActivityHospitalsBinding
    private lateinit var listOfHospitalViewModel: ListOfHospitalViewModel
    private lateinit var recyclerAdapterListOfHospitals: RecyclerAdapterListOfHospitals
    var organizationListRealm: RealmResults<Organization>? = null

    companion object {
        fun getCallingIntent(context: Context): Intent {
            return Intent(context, ListOfHospitalsActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
    }

    override fun getLayoutId(): Int = R.layout.activity_hospitals
    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityHospitalsBinding = mViewDataBinding as ActivityHospitalsBinding
        listOfHospitalViewModel =
            ViewModelProvider(this, viewModelFactory).get(ListOfHospitalViewModel::class.java)
        activityHospitalsBinding.listOfHospitals = listOfHospitalViewModel
        listOfHospitalViewModel.navigator = this
        listOfHospitalViewModel.getListOfHospitals()
        listOfHospitalViewModel.hospitalListResponseBody.observe(this, Observer {
            recyclerAdapterListOfHospitals.addData(it)
            organizationListRealm = it
        })
        setAdapter()
        recyclerAdapterListOfHospitals.addData(organizationListRealm)

        activityHospitalsBinding.etSearch.addTextChangedListener(this)
        setSupportActionBar(activityHospitalsBinding.toolbar)
        supportActionBar?.setDisplayShowTitleEnabled(false)
    }

    @SuppressLint("RestrictedApi")
    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        if (menu is MenuBuilder) menu.setOptionalIconsVisible(true)
        menuInflater.inflate(R.menu.menu_main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            R.id.consultation -> {
                startActivity(Intent(this, ConsultationActivity::class.java))
            }
            R.id.logout -> logout()
            R.id.profileInfo -> {
                startActivity(Intent(this, ProfileActivity::class.java))
            }
            R.id.addIllness -> {
                startActivity(Intent(this, PatientInfoActivity::class.java))
            }

        }
        return super.onOptionsItemSelected(item)
    }

    /*
    * setting recycler adapter and pass list of rganization*/
    private fun setAdapter() {
        recyclerAdapterListOfHospitals = RecyclerAdapterListOfHospitals(this)
        list_of_hospital_recycler.apply {
            layoutManager = LinearLayoutManager(this@ListOfHospitalsActivity)
            adapter = recyclerAdapterListOfHospitals
        }
    }

    override fun beforeTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
    }

    override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {

    }

    //Search bar after text change
    override fun afterTextChanged(s: Editable?) {
        if (s!!.isEmpty()) {
            organizationListRealm
        } else {
            organizationListRealm?.filter { it!!.name!!.contains(s.toString()) }

        }.let {
            recyclerAdapterListOfHospitals.addData(it)
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

    override fun onBackPressed() {
        super.onBackPressed()
        moveTaskToBack(true)
    }
}