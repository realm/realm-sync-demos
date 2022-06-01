package com.wekanmdb.storeinventory.ui.prescription

import android.app.Activity
import android.content.Intent
import android.view.View
import androidx.activity.result.contract.ActivityResultContracts
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityHomeBinding
import com.wekanmdb.storeinventory.databinding.ActivityPrescriptionBinding
import com.wekanmdb.storeinventory.model.embededclass.Coding
import com.wekanmdb.storeinventory.model.encounter.Encounter
import com.wekanmdb.storeinventory.model.procedure.Procedure
import com.wekanmdb.storeinventory.ui.consultation.ConsultationActivity.Companion.selectedDoctor
import com.wekanmdb.storeinventory.ui.search.SearchActivity
import com.wekanmdb.storeinventory.utils.Constants
import com.wekanmdb.storeinventory.utils.Constants.Companion.DOCTOR
import com.wekanmdb.storeinventory.utils.Constants.Companion.NURSE
import com.wekanmdb.storeinventory.utils.Constants.Companion.USER_TYPE
import com.wekanmdb.storeinventory.utils.UiUtils.convertToCustomFormatDate
import io.realm.RealmList
import kotlinx.android.synthetic.main.activity_edit_prescription.*
import org.bson.types.ObjectId


class PrescriptionActivity : BaseActivity<ActivityHomeBinding>(), PrescriptionNavigator {
    companion object {

    }

    private lateinit var activityPrescriptionBinding: ActivityPrescriptionBinding
    private lateinit var prescriptionViewModel: PrescriptionViewModel
    override fun getLayoutId(): Int = R.layout.activity_prescription
    var encounterId = ObjectId()
    var encounter = Encounter()
    var name = ""
    var illness = ""
    var doctor = ""
    private var specialityCode = ""
    private var specialitySystem = ""
    var bottomSheetDialog: BottomSheetDialog? = null
    var procedure: Procedure? = null
    private lateinit var medicationAdapter: MedicationAdapter
    private lateinit var selectedMedicationAdapter: MedicationAdapter
    var selectedItems: RealmList<Coding> = RealmList()
    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityPrescriptionBinding = mViewDataBinding as ActivityPrescriptionBinding
        prescriptionViewModel =
            ViewModelProvider(this, viewModelFactory).get(PrescriptionViewModel::class.java)
        prescriptionViewModel.navigator = this
        // Receiving values from Consultation List Item
        encounterId = ObjectId(intent.getStringExtra("_id"))
        name = intent.getStringExtra("name").toString()
        illness = intent.getStringExtra("illness").toString()
        doctor = intent.getStringExtra("doctor").toString()
        //Show notes
        val userType = user?.customData?.get(USER_TYPE).toString()
        //set Ui values
        activityPrescriptionBinding.textView11.text = name
        activityPrescriptionBinding.textView12.text = doctor
        activityPrescriptionBinding.textView13.text = illness
        //Get All details
        prescriptionViewModel.getConsultation(encounterId)

        prescriptionViewModel.encounterResponseBody.observe(this, {
            encounter = it
            getConcern(it.appointment?.reasonReference?.identifier)
            prescriptionViewModel.getAllMedicationCode(encounterId)
            activityPrescriptionBinding.textView10.text =
                convertToCustomFormatDate(encounter.appointment?.start.toString())
        })
        prescriptionViewModel.conditionResponseBody.observe(this, {

            activityPrescriptionBinding.textView15.text = it?.code?.text

        })
        activityPrescriptionBinding.imageView10.setOnClickListener {
            editPrescribe("medication", "", "Doctor")
        }
        activityPrescriptionBinding.imageView11.setOnClickListener {
            editPrescribe("notes", activityPrescriptionBinding.textView25.text.toString(),"Doctor")
        }
        activityPrescriptionBinding.imageView12.setOnClickListener {
            editPrescribe("notes", activityPrescriptionBinding.textView27.text.toString(), "Nurse")
        }
        if (userType.equals(DOCTOR, true)) {
            activityPrescriptionBinding.imageView10.visibility = View.VISIBLE
            activityPrescriptionBinding.imageView11.visibility = View.VISIBLE
            activityPrescriptionBinding.imageView12.visibility = View.INVISIBLE
            activityPrescriptionBinding.layoutSelection.visibility = View.VISIBLE
        } else {
            activityPrescriptionBinding.imageView10.visibility = View.INVISIBLE
            activityPrescriptionBinding.imageView11.visibility = View.INVISIBLE
            activityPrescriptionBinding.imageView12.visibility = View.VISIBLE
            activityPrescriptionBinding.layoutSelection.visibility = View.GONE
        }
        prescriptionViewModel.medicationAllResponseBody.observe(this, { it ->
            procedure = it
            //Check whether medication already added or not
            if (!it?.usedReference.isNullOrEmpty()) {

                // Update ui
                activityPrescriptionBinding.textView20.visibility = View.GONE
                activityPrescriptionBinding.recyclerview.visibility = View.VISIBLE
                //Update medication list


                it?.usedReference?.first()?.code?.coding?.let { it1 ->
                    selectedItems.addAll(it1)
                    selectedItems.toHashSet().toList()
                    medicationAdapter.addData(selectedItems)
                    if (selectedItems.isNullOrEmpty()) {
                        // Update ui
                        activityPrescriptionBinding.textView20.visibility = View.VISIBLE
                        activityPrescriptionBinding.recyclerview.visibility = View.GONE
                    }
                    selectedMedicationAdapter.addData(it1)
                }


                if (!procedure?.note.isNullOrEmpty()) {
                    procedure?.note?.forEach { it1 ->
                        if (it1.author?.identifier == selectedDoctor) {
                            if (it1.text.isNullOrEmpty()) {
                                "N/A"
                            } else {
                                it1.text
                            }.let { notes ->
                                activityPrescriptionBinding.textView25.text = notes
                            }

                        } else {
                            if (it1.text.isNullOrEmpty()) {
                                "N/A"
                            } else {
                                it1.text
                            }.let { notes ->
                                activityPrescriptionBinding.textView27.text = notes
                            }
                        }


                    }
                }

//get selected nurse
                encounter.participant.forEach {

                    it.individual?.identifier?.let { it1 -> prescriptionViewModel.getNurse(it1) }
                }

            } else {
                // Update ui
                activityPrescriptionBinding.textView20.visibility = View.VISIBLE
                activityPrescriptionBinding.recyclerview.visibility = View.GONE
            }
        })

        prescriptionViewModel.nurseResponseBody.observe(this, {
            if (it != null)
                activityPrescriptionBinding.textView29.text = it.practitioner?.name?.text
        })
        activityPrescriptionBinding.textView29.setOnClickListener {
            val searchIntent = Intent(this, SearchActivity::class.java)
            searchIntent.putExtra(Constants.SEARCH_TYPE, Constants.SEARCH_PRACTITIONER)
            practitionerSearchLauncher.launch(searchIntent)
        }

        initAdapter()

        activityPrescriptionBinding.imageView9.setOnClickListener {
            finish()
        }
    }

    private fun initAdapter() {
        medicationAdapter = MedicationAdapter(this, false) {
            selectedItems.remove(it)
            (bottomSheetDialog!!.recyclerviewMeication?.adapter as MedicationAdapter).notifyDataSetChanged()

        }
        selectedMedicationAdapter = MedicationAdapter(this, true) {

        }
        val llm = LinearLayoutManager(this)
        activityPrescriptionBinding.recyclerview.layoutManager = llm
        activityPrescriptionBinding.recyclerview.adapter = selectedMedicationAdapter

    }

    private fun getConcern(identifier: ObjectId?) {

        prescriptionViewModel.getConcern(identifier)
    }

    private fun editPrescribe(role: String, notes: String, notesCreated: String) {


        bottomSheetDialog = BottomSheetDialog(this)
        bottomSheetDialog?.setContentView(R.layout.activity_edit_prescription)
        bottomSheetDialog!!.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        if (role == "medication") {
            bottomSheetDialog!!.textView21.visibility = View.INVISIBLE
            bottomSheetDialog!!.cardView.visibility = View.GONE
        } else {
            bottomSheetDialog!!.textView19.visibility = View.GONE
            bottomSheetDialog!!.recyclerviewMeication.visibility = View.GONE
            bottomSheetDialog!!.textView16.visibility = View.GONE
        }
        if (user?.customData?.get(USER_TYPE).toString().equals(NURSE,true)) {
            bottomSheetDialog!!.textView21.text="Nurse Notes"
        }
        bottomSheetDialog!!.editTextTextPersonName2.setText(notes)

        bottomSheetDialog!!.imageView9.setOnClickListener {
            bottomSheetDialog!!.dismiss()
        }
        bottomSheetDialog!!.textView16.setOnClickListener {
            val searchIntent = Intent(this, SearchActivity::class.java)
            searchIntent.putExtra(Constants.SEARCH_TYPE, Constants.SEARCH_CODE)
            searchIntent.putExtra(Constants.SEARCH_CATGORY, Constants.MEDICATION_CODE)
            codeSearchLauncher.launch(searchIntent)
        }

        bottomSheetDialog!!.imageView13.setOnClickListener {
            bottomSheetDialog!!.editTextTextPersonName2.setText("")
        }


        bottomSheetDialog!!.textView30.setOnClickListener {
            if (role == "medication") {

                // if (!selectedItems.isNullOrEmpty()) {
                prescriptionViewModel.updateMedication(procedure, selectedItems)

                prescriptionViewModel.response.observe(this, {
                    if (it) {
                        selectedItems.clear()
                        bottomSheetDialog!!.dismiss()
                    }
                })
                //}
            } else {

                // updating doctor notes
                prescriptionViewModel.updateNotes(
                    procedure,
                    bottomSheetDialog!!.editTextTextPersonName2.text.toString(),notesCreated
                )
                prescriptionViewModel.response.observe(this, {
                    if (it) {
                        bottomSheetDialog!!.dismiss()
                    }
                })
            }
            prescriptionViewModel.getAllMedicationCode(encounterId)
        }


        val llm = LinearLayoutManager(this)
        bottomSheetDialog!!.recyclerviewMeication.layoutManager = llm
        bottomSheetDialog!!.recyclerviewMeication.adapter = medicationAdapter


        bottomSheetDialog!!.show()
    }

    private var codeSearchLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val data: Intent? = result.data
                if (data != null) {
                    specialityCode = data.getStringExtra("code") as String
                    specialitySystem = data.getStringExtra("system") as String
                    data.getStringExtra("data")
                    if (selectedItems.find { it.code == specialityCode } != null) {
                        showToast("Already available")
                    } else {
                        val coding = Coding()
                        coding.code = specialityCode
                        coding.system = specialitySystem
                        coding.display = data.getStringExtra("data") as String
                        selectedItems.add(coding)
                        selectedItems.toHashSet().toList()
                        medicationAdapter.addData(selectedItems)
                        if (selectedItems.isNullOrEmpty()) {
                            // Update ui
                            activityPrescriptionBinding.textView20.visibility = View.VISIBLE
                            activityPrescriptionBinding.recyclerview.visibility = View.GONE
                        }
                    }
                }
            }
        }


    private var practitionerSearchLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val data: Intent? = result.data
                if (data != null) {
                    prescriptionViewModel.updateProcedure(data.getStringExtra("identifier"),procedure
                    )

                    prescriptionViewModel.updateProcedure.observe(this, {
                     if(it){
                         prescriptionViewModel.updatePractitioner(
                             encounter,
                             ObjectId(data.getStringExtra("id")),data.getStringExtra("identifier"),procedure
                         )
                        }

                    })


                    activityPrescriptionBinding.textView29.text =
                        data.getStringExtra("data") as String
                }
            }
        }

}