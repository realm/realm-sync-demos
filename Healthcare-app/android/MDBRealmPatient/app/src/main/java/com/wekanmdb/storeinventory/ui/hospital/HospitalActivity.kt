package com.wekanmdb.storeinventory.ui.hospital

import androidx.databinding.ViewDataBinding
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityHospitalInfoBinding
import com.wekanmdb.storeinventory.databinding.ActivityHospitalsBinding
import com.wekanmdb.storeinventory.utils.Constants.Companion.Hospital_Address
import com.wekanmdb.storeinventory.utils.Constants.Companion.Hospital_Desc
import com.wekanmdb.storeinventory.utils.Constants.Companion.Hospital_Name
import com.wekanmdb.storeinventory.utils.Constants.Companion.Hospital_Photo
import com.wekanmdb.storeinventory.utils.Constants.Companion.Hospital_Spec
import com.wekanmdb.storeinventory.utils.Constants.Companion.Org_Id
import kotlinx.android.synthetic.main.common_toolbar.*
import org.bson.types.ObjectId

class HospitalActivity : BaseActivity<ActivityHospitalsBinding>() {

    private lateinit var activityHospitalInfoBinding: ActivityHospitalInfoBinding
    private lateinit var hospitalViewModel: HospitalViewModel
    private lateinit var recyclerAdapterListOfDoctor: RecyclerAdapterListOfDoctor

    companion object {
        var hospitalID: ObjectId? = null
    }

    override fun getLayoutId(): Int = R.layout.activity_hospital_info
    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityHospitalInfoBinding = mViewDataBinding as ActivityHospitalInfoBinding
        hospitalViewModel = ViewModelProvider(this, viewModelFactory).get(
            HospitalViewModel::class.java
        )

        /*
        * getting data from intent by previous activity*/
        val hospitalName = intent.getStringExtra(Hospital_Name)
        val hospitalAddr = intent.getStringExtra(Hospital_Desc)
        val hospitalAbout = intent.getStringExtra(Hospital_Address)
        val hospitalPhoto = intent.getStringArrayListExtra(Hospital_Photo)
        val orgId = ObjectId(intent.getStringExtra(Org_Id))
        val spec = intent.getStringExtra(Hospital_Spec)
        //Calling function to get list of doctor by passing Organization ID
        hospitalViewModel.getDoctorList(orgId)
        hospitalID = orgId
        activityHospitalInfoBinding.textviewHospitalName.text = hospitalName
        activityHospitalInfoBinding.textviewSpecialityName.text = spec
        activityHospitalInfoBinding.textviewLocation.text = hospitalAddr
        activityHospitalInfoBinding.textviewHospitalAboutDetails.text = hospitalAbout
        //Viewpager for showing sliding image of Hospital
        val photoAdapter = hospitalPhoto?.let { ImagePagerAdapter(this, it) }
        activityHospitalInfoBinding.imageViewHospital.adapter = photoAdapter
        hospitalViewModel.doctorListResponseBody.observe(this, Observer {
            it?.let { it1 -> recyclerAdapterListOfDoctor.addData(it1, orgId) }
            recyclerAdapterListOfDoctor.notifyDataSetChanged()
        })
        img_back.setOnClickListener {
            finish()
        }
        setAdapter()
    }

    /*
    * Defining Adapter for recyclerview*/
    private fun setAdapter() {
        recyclerAdapterListOfDoctor = RecyclerAdapterListOfDoctor(this)
        activityHospitalInfoBinding.RecyclerListOfDoctor.apply {
            layoutManager = LinearLayoutManager(this@HospitalActivity)
            adapter = recyclerAdapterListOfDoctor
        }
    }
}