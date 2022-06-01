package com.wekanmdb.storeinventory.ui.profile

import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityLoginBinding
import com.wekanmdb.storeinventory.databinding.ActivityPatientInfoBinding
import com.wekanmdb.storeinventory.databinding.PatientProfileInfoBinding
import com.wekanmdb.storeinventory.ui.patientBasicInfo.PatientInfoActivity
import com.wekanmdb.storeinventory.ui.patientBasicInfo.PatientInfoViewModel
import com.wekanmdb.storeinventory.utils.UiUtils
import kotlinx.android.synthetic.main.common_toolbar.*
import org.bson.types.ObjectId
import java.text.SimpleDateFormat


class ProfileActivity : BaseActivity<PatientProfileInfoBinding>(), ProfileNavigator {
    private lateinit var patientProfileInfoBinding: PatientProfileInfoBinding
    private lateinit var profileViewModel: ProfileViewModel
    companion object {
        fun getCallingIntent(context: Context): Intent {
            return Intent(context, ProfileActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
    }
    override fun getLayoutId(): Int = R.layout.patient_profile_info

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        val id=user?.customData?.get("referenceId") as ObjectId
        patientProfileInfoBinding = mViewDataBinding as PatientProfileInfoBinding
        profileViewModel =
            ViewModelProvider(this, viewModelFactory).get(ProfileViewModel::class.java)
        patientProfileInfoBinding.profileViewModel = profileViewModel
        profileViewModel.getPatientInfo(id)
        profileViewModel.patientResponseBody.observe(this, Observer {
            if (it != null) {
                patientProfileInfoBinding.textViewUsername.text=it.name?.text.toString()
                patientProfileInfoBinding.textviewGender.text=it.gender.toString()
                val currentDate = SimpleDateFormat("dd/MM/yyyy").format(it.birthDate)

                patientProfileInfoBinding.textviewDob.text=UiUtils.getDateFormat(it.birthDate)


            }
        })
        img_back.setOnClickListener {
            finish()
        }
    }
}