package com.wekanmdb.storeinventory.ui.patientBasicInfo

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.view.Menu
import android.view.MenuItem
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.view.menu.MenuBuilder
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityPatientInfoBinding
import com.wekanmdb.storeinventory.model.condition.Condition
import com.wekanmdb.storeinventory.ui.consultation.ConsultationActivity
import com.wekanmdb.storeinventory.ui.listOfHospitals.ListOfHospitalsActivity
import com.wekanmdb.storeinventory.ui.login.LoginActivity
import com.wekanmdb.storeinventory.ui.profile.ProfileActivity
import com.wekanmdb.storeinventory.ui.search.SearchActivity
import com.wekanmdb.storeinventory.utils.Constants
import com.wekanmdb.storeinventory.utils.Constants.Companion.Code
import com.wekanmdb.storeinventory.utils.Constants.Companion.Data
import com.wekanmdb.storeinventory.utils.Constants.Companion.Id
import com.wekanmdb.storeinventory.utils.Constants.Companion.System
import com.wekanmdb.storeinventory.utils.UiUtils
import io.realm.kotlin.where
import kotlinx.android.synthetic.main.activity_patient_info.*
import kotlinx.android.synthetic.main.common_toolbar.*
import kotlinx.android.synthetic.main.dialog_logout.*
import org.bson.types.ObjectId


class PatientInfoActivity : BaseActivity<ActivityPatientInfoBinding>(), PatientInfoNavigator {

    companion object {
        fun getCallingIntent(context: Context): Intent {
            return Intent(context, PatientInfoActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
    }

    var illnessConditionList = ArrayList<ConditionModel>()
    var illnessConditionLists = ArrayList<String>()
    private lateinit var recylerAdapter: RecyclerAddIllnessList
    var conditionModel = java.util.ArrayList<ConditionModel>()
    private lateinit var activityPatientInfoBinding: ActivityPatientInfoBinding
    private lateinit var patientInfoViewModel: PatientInfoViewModel
    override fun getLayoutId(): Int = R.layout.activity_patient_info
    private var conditionID = ""
    private var system = ""
    private var conditionCode: String? = null
    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityPatientInfoBinding = mViewDataBinding as ActivityPatientInfoBinding
        patientInfoViewModel =
            ViewModelProvider(this, viewModelFactory).get(PatientInfoViewModel::class.java)
        activityPatientInfoBinding.patientInfoViewModel = patientInfoViewModel
        patientInfoViewModel.navigator = this
        patientInfoViewModel.getConditionListToFilter()
        //Click  add illness condition
        activityPatientInfoBinding.spinnerIllness.setOnClickListener {
            val searchIntent = Intent(this, SearchActivity::class.java)
            searchIntent.putExtra(Constants.SEARCH_TYPE, Constants.SEARCH_CONDITION)
            specialitySearchLauncher.launch(searchIntent)
        }
        patientInfoViewModel.conditionListResponseBody.observe(this, {
            it?.forEach { res ->
                res.code?.coding?.forEach { coding ->
                    coding.display?.let { it1 -> illnessConditionLists.add(it1) }
                }
            }

        })
        setSupportActionBar(activityPatientInfoBinding.toolbar)
        supportActionBar?.setDisplayShowTitleEnabled(false)
        img_back.setOnClickListener {
            finish()
        }
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
            R.id.profileInfo -> startActivity(ProfileActivity.getCallingIntent(this@PatientInfoActivity))
            R.id.addIllness -> startActivity(getCallingIntent(this@PatientInfoActivity))
        }
        return super.onOptionsItemSelected(item)
    }

    //getting result back(condition,code,display ) from search activity
    private var specialitySearchLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val data: Intent? = result.data
                if (data != null) {
                    conditionID = data.getStringExtra(Id).toString()
                    conditionCode = data.getStringExtra(Code).toString()
                    system = data.getStringExtra(System).toString()
                    activityPatientInfoBinding.spinnerIllness.text =
                        data.getStringExtra(Data).toString()
                }
            }
        }

    //Next Click for List of Hospitals
    override fun nextClick() {
        if (illnessConditionList.isNullOrEmpty()) {
            showToast("Please select the illness")
        } else {
            startActivity(ListOfHospitalsActivity.getCallingIntent(this))
        }
    }

    //add illness button click
    override fun addIllnessClick() {
        recylerAdapter = RecyclerAddIllnessList(this)
        val conditionItem = ConditionModel(
            activityPatientInfoBinding.spinnerIllness.text.toString(),
            activityPatientInfoBinding.textviewMedicNames.text.toString()
        )
        if (activityPatientInfoBinding.spinnerIllness.text.isNullOrEmpty() && activityPatientInfoBinding.textviewMedicNames.text.isNullOrEmpty()) {
            showToast("Please select the illness")
        } else {
            //checking if already added item is exist or not
            if (!UiUtils.itemAlreadyExist(conditionItem, illnessConditionLists)) {
                illnessConditionList.add(conditionItem)
                conditionModel.add(conditionItem)
                recylerAdapter.addData(illnessConditionList)
                recylerAdapter.notifyDataSetChanged()

                recycler_illnessList.apply {
                    layoutManager = LinearLayoutManager(this@PatientInfoActivity)
                    adapter = recylerAdapter
                }
                //Submitting Illness Condition
                patientInfoViewModel.submitIllnessCondition(
                    conditionCode,
                    conditionID,
                    system,
                    activityPatientInfoBinding.textviewMedicNames.text.toString(),
                    activityPatientInfoBinding.spinnerIllness.text as String?
                ).observe(this) {
                    Toast.makeText(this, "Added", Toast.LENGTH_SHORT).show()
                }

                activityPatientInfoBinding.spinnerIllness.text = ""
                activityPatientInfoBinding.textviewMedicNames.text.clear()

            } else {
                showToast("This item already selected")
            }
        }
    }


    override fun removeAddedCondition(string: String) {
        apprealm?.executeTransaction { realm ->
            val conditionList = realm.where<Condition>()
                .equalTo("subject.identifier", user?.customData?.get("referenceId") as ObjectId)
                .findAll()
            conditionList?.forEach {
                if (it.isValid) {
                    if (it.code?.coding!!.isNotEmpty()) {
                        if (it?.code?.coding?.first()?.display.equals(string)) {
                            it.deleteFromRealm()
                        }
                    }
                }
            }
        }
    }


    // logout function
    private fun logout() {
        val dialogLogout = Dialog(this, R.style.dialog_center)
        dialogLogout.setCancelable(false)
        dialogLogout.setContentView(R.layout.dialog_logout)
        dialogLogout.show()
        val no = dialogLogout.textView23
        val yes = dialogLogout.textView24
        no.setOnClickListener {
            dialogLogout.dismiss()
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
                    dialogLogout.dismiss()
                } else {
                    showToast("log out failed! Error: ${logout.error}")
                }
            }
        }
    }
}


