package com.wekanmdb.storeinventory.ui.doctorInfo

import android.content.Intent
import android.graphics.Bitmap
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityDoctorInfoBinding
import com.wekanmdb.storeinventory.ui.availableSlots.AvailableSlotActivity
import com.wekanmdb.storeinventory.utils.Constants.Companion.Doctor_About
import com.wekanmdb.storeinventory.utils.Constants.Companion.Doctor_EndTime
import com.wekanmdb.storeinventory.utils.Constants.Companion.Doctor_Image
import com.wekanmdb.storeinventory.utils.Constants.Companion.Doctor_Name
import com.wekanmdb.storeinventory.utils.Constants.Companion.Doctor_Spec
import com.wekanmdb.storeinventory.utils.Constants.Companion.Doctor_Time
import kotlinx.android.synthetic.main.common_toolbar.*
import org.bson.types.ObjectId

class DoctorInfoActivity : BaseActivity<ActivityDoctorInfoBinding>() {
    private lateinit var activityDoctorInfoBinding: ActivityDoctorInfoBinding
    private lateinit var doctorInfoViewModel: DoctorInfoViewModel
    var imageBit: ArrayList<Bitmap>? = null

    companion object {
        var doctorId: ObjectId? = null
        var doctorIdentifier: String? = null
        var doctorName: String? = null
        var doctorSpec: String? = null
        var doctorAbout: String? = null
        var doctorImage: ArrayList<String>? = null
        var doctorAvailableTime: String? = null
        var doctorAvailableEndTime: String? = null

    }

    override fun getLayoutId(): Int = R.layout.activity_doctor_info

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityDoctorInfoBinding = mViewDataBinding as ActivityDoctorInfoBinding
        doctorInfoViewModel = ViewModelProvider(this, viewModelFactory).get(
            DoctorInfoViewModel::class.java
        )
        /*
        * getting data from intent*/
        doctorName = intent.getStringExtra(Doctor_Name)
        doctorSpec = intent.getStringExtra(Doctor_Spec)
        doctorAbout = intent.getStringExtra(Doctor_About)
        doctorImage = intent.getStringArrayListExtra(Doctor_Image)
        doctorAvailableTime = intent.getStringExtra(Doctor_Time)
        doctorAvailableEndTime = intent.getStringExtra(Doctor_EndTime)
        activityDoctorInfoBinding.textviewDoctorname.text = "DR.$doctorName"
        activityDoctorInfoBinding.srCardiolo.text = doctorSpec
        activityDoctorInfoBinding.textviewAboutDesc.text = doctorAbout
        img_back.setOnClickListener {
            finish()
        }
        val photoAdapter = ImageDoctorAdapter(this, doctorImage)
        activityDoctorInfoBinding.imageViewHospital.adapter = photoAdapter

        /*
        * clicking the book appointment button function to start another activity */
        activityDoctorInfoBinding.btnBookAppointment.setOnClickListener {
            val availableSlotIntent = Intent(this, AvailableSlotActivity::class.java)
            startActivity(availableSlotIntent)
        }

    }
}