package com.wekanmdb.storeinventory.ui.consultation

import android.graphics.BitmapFactory
import android.util.Base64
import android.widget.ImageView
import android.widget.TextView
import androidx.databinding.ViewDataBinding
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivitityDoctorConsulationDetailBinding
import com.wekanmdb.storeinventory.model.organization.Organization
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import com.wekanmdb.storeinventory.model.procedure.Procedure
import io.realm.kotlin.where
import kotlinx.android.synthetic.main.common_toolbar.*
import org.bson.types.ObjectId

class ConsultationDetailActivity : BaseActivity<ActivitityDoctorConsulationDetailBinding>() {

    val addMedic: MutableList<String> = ArrayList()
    private lateinit var doctorNotesAdapter: DoctorNotesAdapter

    companion object {

        var doctorId = ObjectId()
        var orgId = ObjectId()
        var conditionID = ObjectId()
        var encounterID = ObjectId()
    }

    private lateinit var activitityDoctorConsulationDetailBinding: ActivitityDoctorConsulationDetailBinding

    override fun getLayoutId(): Int = R.layout.activitity_doctor_consulation_detail

    val id = user?.customData?.get("referenceId") as ObjectId

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activitityDoctorConsulationDetailBinding =
            mViewDataBinding as ActivitityDoctorConsulationDetailBinding

        img_back.setOnClickListener {
            finish()
        }
        val orgName = intent.getStringExtra("Org_Name")
        val slot = intent.getStringExtra("Slot")
        activitityDoctorConsulationDetailBinding.textviewHospitalName.text = orgName
        activitityDoctorConsulationDetailBinding.textviewConcernDetail.text = slot

        //Function Call for getting Organization by passing orgID
        getOrgDetails(
            orgId,
            activitityDoctorConsulationDetailBinding.textviewSpecialityName,
            activitityDoctorConsulationDetailBinding.textviewLocation
        )
        //Function Call for getting DoctorList by passing doctorId
        getDocDetails(
            doctorId,
            activitityDoctorConsulationDetailBinding.textDoctorName,
            activitityDoctorConsulationDetailBinding.textviewSpecialityName,
            activitityDoctorConsulationDetailBinding.textviewDoctorProfession,
            activitityDoctorConsulationDetailBinding.imageDoctor,
            activitityDoctorConsulationDetailBinding.textviewConcernName,
        )
        //Function Call for getting notes
        getNotes(
            activitityDoctorConsulationDetailBinding.textviewNurseNotesDetail,
            activitityDoctorConsulationDetailBinding.textviewDoctorNotesDetails
        )
    }

    private fun initConditionAdapter(recycler: RecyclerView, addMedic: MutableList<String>) {
        doctorNotesAdapter = DoctorNotesAdapter(this)
        recycler.apply {
            layoutManager = LinearLayoutManager(this@ConsultationDetailActivity)
            addItemDecoration(
                DividerItemDecoration(
                    this@ConsultationDetailActivity,
                    DividerItemDecoration.VERTICAL
                )
            )
            adapter = doctorNotesAdapter
        }
        doctorNotesAdapter.addData(addMedic)


    }

    /*
    *Getting Organization by passing id and
    * setting the data to the textview  */
    private fun getOrgDetails(
        id: ObjectId,
        textviewSpecialityName: TextView,
        textviewLocation: TextView
    ) {
        val result = apprealm?.where<Organization>()?.equalTo("_id", id)?.findAll()
        result?.forEach {
            if (it.type?.coding?.isNotEmpty() == true)
                textviewSpecialityName.text = it.type?.coding?.first()?.display
            textviewLocation.text = it.address.first()?.city.toString()
        }
    }

    /*
    *Getting Doctor by passing id and
    * setting the data to the textview  */
    private fun getDocDetails(
        id: ObjectId?,
        textDoctorName: TextView,
        textviewSpecialityName: TextView,
        textviewDoctorProfession: TextView,
        imageDoctor: ImageView,
        textviewConcernName: TextView
    ) {
        val practioner =
            apprealm?.where<PractitionerRole>()?.equalTo("practitioner._id", id)?.findAll()
        //Loop for getting doctor name,speciality,concern,image,
        practioner?.forEach {
            textDoctorName.text = it?.practitioner?.name?.text.toString()
            if (it.specialty?.coding?.isNotEmpty() == true) {
                textviewSpecialityName.text = it.specialty?.coding?.first()?.display.toString()
            }
            textviewDoctorProfession.text = it.specialty?.text?.toString()
            textviewConcernName.text = it.code?.coding?.first()?.display.toString()
            if (it?.practitioner?.photo?.isNotEmpty() == true) {
                if (it.practitioner?.photo?.first()?.data?.isNotEmpty() == true) {
                    // decode base64 string
                    val bytes: ByteArray = Base64.decode(
                        it.practitioner?.photo?.first()?.data.toString(),
                        Base64.DEFAULT
                    )
                    // Initialize bitmap
                    val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
                    // set bitmap on imageView
                    imageDoctor.setImageBitmap(bitmap)
                }
            }
        }
    }

    /*
    * Getting Doctor and Nurse Notes by passing patient id*/
    private fun getNotes(textviewNurseNotesDetail: TextView, textviewDoctorNotesDetails: TextView) {
        val result = apprealm?.where<Procedure>()?.equalTo("subject._id", id)
            ?.equalTo("encounter._id", encounterID)?.findFirst()
        result?.note?.addChangeListener { it ->
            if (result.note.isNotEmpty()) {
                result.note.forEach {
                    if (it.author?.reference.equals("Practitioner/Doctor")) {
                        textviewDoctorNotesDetails.text = it.text
                    } else {
                        textviewNurseNotesDetail.text = it.text
                    }
                }
            }
            addMedic.clear()
            result.usedReference.forEach { medic ->

                medic.code?.coding.let {
                    it?.forEach { coding ->
                        addMedic.add(coding?.display.toString())
                    }
                }

            }
            initConditionAdapter(
                activitityDoctorConsulationDetailBinding.textviewMedicPrescribed1,
                addMedic
            )
        }
        if (result?.note?.isNotEmpty() == true) {
            result.note.forEach {
                if (it.author?.reference.equals("Practitioner/Doctor")) {
                    textviewDoctorNotesDetails.text = it.text
                } else {
                    textviewNurseNotesDetail.text = it.text
                }
            }
        }
        result?.usedReference?.forEach { medic ->

            medic.code?.coding.let {
                it?.forEach { coding ->
                    addMedic.add(coding?.display.toString())
                }
            }

        }
        if (!addMedic.isNullOrEmpty()) {
            addMedic.toSet().toMutableList()
        }
        initConditionAdapter(
            activitityDoctorConsulationDetailBinding.textviewMedicPrescribed1,
            addMedic
        )
    }

}
