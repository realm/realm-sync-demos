package com.wekanmdb.storeinventory.ui.consultation

import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.text.Editable
import android.text.TextWatcher
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.ui.AppBarConfiguration
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityConsultationBinding
import com.wekanmdb.storeinventory.databinding.ActivityHomeBinding
import com.wekanmdb.storeinventory.model.encounter.Encounter
import com.wekanmdb.storeinventory.ui.prescription.PrescriptionActivity
import com.wekanmdb.storeinventory.utils.UiUtils.convertToFilterDate
import kotlinx.android.synthetic.main.activity_home.*
import kotlinx.android.synthetic.main.dialog_logout.*
import kotlinx.android.synthetic.main.filter_dialog.*
import kotlinx.android.synthetic.main.profile_pic_dialog.*
import org.bson.types.ObjectId
import java.util.*


class ConsultationActivity : BaseActivity<ActivityHomeBinding>(), ConsultationNavigator,
    TextWatcher {
    companion object {
        fun getCallingIntent(context: Context): Intent {
            return Intent(context, ConsultationActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        var selectedDoctor = ObjectId()
    }

    private lateinit var consultationAdapter: ConsultationAdapter
    private lateinit var activityConsultationBinding: ActivityConsultationBinding
    private lateinit var consultationViewModel: ConsultationViewModel
    private lateinit var appBarConfiguration: AppBarConfiguration
    var consultationsList: List<Encounter>? = null
    var orgName = ""
    var orgId = ""
    var isSelectedYesterday=false
    var isSelectedToday=false
    var isSelectedTomorrow=false
    override fun getLayoutId(): Int = R.layout.activity_consultation

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityConsultationBinding = mViewDataBinding as ActivityConsultationBinding
        consultationViewModel =
            ViewModelProvider(this, viewModelFactory).get(ConsultationViewModel::class.java)
        consultationViewModel.navigator = this
        activityConsultationBinding.etSearch.addTextChangedListener(this)
        orgId = intent.getStringExtra("_id").toString()
        orgName = intent.getStringExtra("name").toString()
        activityConsultationBinding.textView3.text = orgName
        initAdapter()
        getConsultations(orgId)

        activityConsultationBinding.imageView20.setOnClickListener {
            finish()
        }

        activityConsultationBinding.imageView2.setOnClickListener {
            filterDialog()
        }
    }

    private fun getConsultations(orgId: String?) {
        val user = user?.customData?.get("referenceId") as ObjectId
        consultationViewModel.getConsultation(ObjectId(orgId), user)
        consultationViewModel.consultationresponseBody.observe(this,
            { result ->
                consultationsList = result
                consultationAdapter.addData(result)
            })


    }

    private fun initAdapter() {
        consultationAdapter = ConsultationAdapter(this) { encounter, illness, doctor, doctorCode ->
            if (!doctorCode.isNullOrEmpty()) {
                selectedDoctor = ObjectId(doctorCode)
                startActivity(
                    Intent(this, PrescriptionActivity::class.java)
                        .putExtra("_id", encounter._id.toString())
                        .putExtra("name", encounter.subject?.name?.text)
                        .putExtra("illness", illness)
                        .putExtra("doctor", doctor)
                )
            } else {
                showToast("Invalid data")
            }

        }
        activityConsultationBinding.consultationRecycler.apply {
            layoutManager = LinearLayoutManager(this@ConsultationActivity)
            addItemDecoration(
                DividerItemDecoration(
                    this@ConsultationActivity,
                    DividerItemDecoration.VERTICAL
                )
            )
            adapter = consultationAdapter
        }


    }

    override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {
    }

    override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
    }

    override fun afterTextChanged(s: Editable?) {
        if (s!!.isEmpty()) {
            consultationsList
        } else {
            consultationsList?.filter { it.subject!!.name!!.text!!.contains(s.toString()) }

        }.let {
            consultationAdapter.addData(it)
        }
    }

    private fun filterDialog() {
        val dialog = Dialog(this, R.style.dialog_center)
        dialog.setCancelable(true)
        dialog.setContentView(R.layout.filter_dialog)

        dialog.textView41.setOnClickListener {
            validateCheckbox(dialog)


            dialog.dismiss()
        }
        dialog.show()

    }

    private fun validateCheckbox(dialog: Dialog) {
        val user = user?.customData?.get("referenceId") as ObjectId
        if (dialog.checkBox.isChecked && dialog.checkBox2.isChecked && dialog.checkBox3.isChecked) {
            consultationsList?.filter {
                convertToFilterDate(it.appointment?.start.toString()) == convertToFilterDate(
                    today().toString()
                ) || convertToFilterDate(it.appointment?.start.toString()) == convertToFilterDate(
                    tomorrow().toString()
                ) || convertToFilterDate(it.appointment?.start.toString()) == convertToFilterDate(
                    yesterday().toString()
                )
            }.let {
                consultationAdapter.addData(it)
            }
        } else if (!dialog.checkBox.isChecked && dialog.checkBox2.isChecked && dialog.checkBox3.isChecked) {

            consultationsList?.filter {
                convertToFilterDate(it.appointment?.start.toString()) == convertToFilterDate(
                    today().toString()
                ) || convertToFilterDate(it.appointment?.start.toString()) == convertToFilterDate(
                    tomorrow().toString()
                )
            }.let {
                consultationAdapter.addData(it)
            }
        } else if (dialog.checkBox.isChecked && !dialog.checkBox2.isChecked && dialog.checkBox3.isChecked) {

            consultationsList?.filter {
                convertToFilterDate(it.appointment?.start.toString()) == convertToFilterDate(
                    yesterday().toString()
                ) || convertToFilterDate(it.appointment?.start.toString()) == convertToFilterDate(
                    tomorrow().toString()
                )
            }.let {
                consultationAdapter.addData(it)
            }

        } else if (dialog.checkBox.isChecked && dialog.checkBox2.isChecked && !dialog.checkBox3.isChecked) {
            consultationsList?.filter {
                convertToFilterDate(it.appointment?.start.toString()) == convertToFilterDate(
                    yesterday().toString()
                ) || convertToFilterDate(it.appointment?.start.toString()) == convertToFilterDate(
                    today().toString()
                )
            }.let {
                consultationAdapter.addData(it)
            }

            consultationViewModel.getConsultationFilter(ObjectId(orgId), user, yesterday(), today())
        } else if (dialog.checkBox.isChecked && !dialog.checkBox2.isChecked && !dialog.checkBox3.isChecked) {
            consultationsList?.filter {
                convertToFilterDate(it.appointment?.start.toString()) == convertToFilterDate(
                    yesterday().toString()
                )
            }.let {
                consultationAdapter.addData(it)
            }

        } else if (!dialog.checkBox.isChecked && dialog.checkBox2.isChecked && !dialog.checkBox3.isChecked) {
            consultationsList?.filter {
                convertToFilterDate(it.appointment?.start.toString()) == convertToFilterDate(
                    today().toString()
                )
            }.let {
                consultationAdapter.addData(it)
            }

        } else if (!dialog.checkBox.isChecked && !dialog.checkBox2.isChecked && dialog.checkBox3.isChecked) {
            consultationsList?.filter {
                convertToFilterDate(it.appointment?.start.toString()) == convertToFilterDate(
                    tomorrow().toString()
                )
            }.let {
                consultationAdapter.addData(it)
            }

        }
    }

    private fun yesterday(): Date {
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        calendar.add(Calendar.DATE, -1)
        return calendar.time
    }

    private fun today(): Date {
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        calendar.add(Calendar.DATE, 0)
        return calendar.time
    }

    private fun tomorrow(): Date {
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        calendar.add(Calendar.DATE, +1)
        return calendar.time
    }
}