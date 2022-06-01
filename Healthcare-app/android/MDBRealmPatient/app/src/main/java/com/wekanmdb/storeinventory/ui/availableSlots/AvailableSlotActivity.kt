package com.wekanmdb.storeinventory.ui.availableSlots

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Build
import androidx.activity.result.contract.ActivityResultContracts
import androidx.annotation.RequiresApi
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.GridLayoutManager
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayout.OnTabSelectedListener
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityAvailableSlotsBinding
import com.wekanmdb.storeinventory.ui.doctorInfo.DoctorInfoActivity
import com.wekanmdb.storeinventory.ui.listOfHospitals.ListOfHospitalsActivity
import com.wekanmdb.storeinventory.ui.search.SearchActivity
import com.wekanmdb.storeinventory.utils.Constants
import com.wekanmdb.storeinventory.utils.Constants.Companion.Data
import com.wekanmdb.storeinventory.utils.Constants.Companion.DateFormat
import com.wekanmdb.storeinventory.utils.Constants.Companion.Id
import com.wekanmdb.storeinventory.utils.Constants.Companion.Notes
import com.wekanmdb.storeinventory.utils.Constants.Companion.TimeEndForEve
import com.wekanmdb.storeinventory.utils.Constants.Companion.TimeEndForNoon
import com.wekanmdb.storeinventory.utils.Constants.Companion.TimeFormatForDoctor
import com.wekanmdb.storeinventory.utils.UiUtils
import kotlinx.android.synthetic.main.common_toolbar.*
import org.bson.types.ObjectId
import java.text.SimpleDateFormat
import java.time.LocalDateTime
import java.time.temporal.ChronoField
import java.util.*


class AvailableSlotActivity : BaseActivity<ActivityAvailableSlotsBinding>(),
    AvailableSlotNavigator {

    companion object {
        var timeslotsBookedList: MutableList<Long> = ArrayList()
    }

    private lateinit var activityAvailableSlotsBinding: ActivityAvailableSlotsBinding
    private lateinit var availableSlotViewModel: AvailableSlotViewModel

    @RequiresApi(Build.VERSION_CODES.O)
    var current: LocalDateTime = LocalDateTime.now()
    var slot: Long? = null
    private var slotPosition: Int? = 0
    private var timeSlotInterval: Int = 15
    lateinit var notes: String
    var startTime = ""
    var endTime = ""
    lateinit var conditionId: ObjectId
    lateinit var dStart: Date
    lateinit var dEnd: Date
    var formatDate = ""
    private var timeslots: MutableList<String> = ArrayList()
    private var mornTimeSlots: MutableList<TimeSlotData> = ArrayList()
    private var noonTimeSlots: MutableList<TimeSlotData> = ArrayList()
    private var eveTimeslots: MutableList<TimeSlotData> = ArrayList()

    @SuppressLint("SimpleDateFormat")
    private val df = SimpleDateFormat(TimeFormatForDoctor)
    val dEndForMorning: Date? = df.parse(TimeEndForNoon)
    val dEndForNoon: Date? = df.parse(TimeEndForEve)
    override fun getLayoutId(): Int = R.layout.activity_available_slots

    @RequiresApi(Build.VERSION_CODES.O)
    override fun initView(mViewDataBinding: ViewDataBinding?) {
        dStart =
            df.parse(DoctorInfoActivity.doctorAvailableTime?.let { UiUtils.getFormattedDate(it) })
        dEnd =
            df.parse(DoctorInfoActivity.doctorAvailableEndTime?.let { UiUtils.getFormattedDate(it) })
        activityAvailableSlotsBinding = mViewDataBinding as ActivityAvailableSlotsBinding
        activityAvailableSlotsBinding.tabLayout.addTab(
            activityAvailableSlotsBinding.tabLayout.newTab().setText(R.string.morning)
        )
        activityAvailableSlotsBinding.tabLayout.addTab(
            activityAvailableSlotsBinding.tabLayout.newTab().setText(R.string.noon)
        )
        activityAvailableSlotsBinding.tabLayout.addTab(
            activityAvailableSlotsBinding.tabLayout.newTab().setText(R.string.evening)
        )
        availableSlotViewModel = ViewModelProvider(this, viewModelFactory).get(
            AvailableSlotViewModel::class.java
        )
        //Calling the function to get condition
        availableSlotViewModel.getConditionData()
        //Calling the function to get slot data practitioner based on passing doctor ID
        DoctorInfoActivity.doctorId?.let { availableSlotViewModel.getAppointmentTimeSlotData(it) }
        img_back.setOnClickListener {
            finish()
        }


        //Showing list of illness to add by clicking concern dropdown
        activityAvailableSlotsBinding.spinnerConcern.setOnClickListener {
            val searchIntent = Intent(this, SearchActivity::class.java)
            searchIntent.putExtra(Constants.SEARCH_TYPE, Constants.SEARCH_CONCERN)
            specialitySearchLauncher.launch(searchIntent)
        }
        activityAvailableSlotsBinding.textviewDoctorName.text = DoctorInfoActivity.doctorName
        activityAvailableSlotsBinding.textviewDocspecialityName.text = DoctorInfoActivity.doctorSpec
        //Loading the doctor image using Glide
        if (DoctorInfoActivity.doctorImage?.isNotEmpty() == true) {
            UiUtils.setImageInBitmapRecycler(
                this,
                DoctorInfoActivity.doctorImage!!.first(),
                activityAvailableSlotsBinding.imageviewDoctor
            )

        }
        //Getting the current year,date and month
        activityAvailableSlotsBinding.view.setStartDate(
            current.get(ChronoField.DAY_OF_MONTH),
            current.get(ChronoField.MONTH_OF_YEAR),
            current.get(ChronoField.YEAR)
        )

        //Getting the selected date from the view
        activityAvailableSlotsBinding.view.getSelectedDate { date ->
            formatDate = SimpleDateFormat(DateFormat).format(date)
        }
        /*
        * Calculating time slots by passing start and end time*/
        calculateTime(dStart, dEndForMorning)
        val adapter = RecyclerViewAdapterTimeSlots(this)
        adapter.addData(mornTimeSlots, timeslots, timeslotsBookedList)

        val layoutManager = GridLayoutManager(this, 5)
        activityAvailableSlotsBinding.gridTime.layoutManager = layoutManager
        activityAvailableSlotsBinding.gridTime.adapter = adapter

        /*
        * Function Call when selection of tab */
        activityAvailableSlotsBinding.tabLayout.addOnTabSelectedListener(object :
            OnTabSelectedListener {
            override fun onTabSelected(tab: TabLayout.Tab) {
                when (tab.position) {
                    0 -> {
                        calculateTime(dStart, dEndForMorning)
                        adapter.addData(mornTimeSlots, timeslots, timeslotsBookedList)
                        noonTimeSlots.clear()
                        eveTimeslots.clear()
                    }

                    1 -> {
                        calculateTime(dEndForMorning, dEndForNoon)
                        adapter.addData(noonTimeSlots, timeslots, timeslotsBookedList)
                        mornTimeSlots.clear()
                        eveTimeslots.clear()
                    }

                    2 -> {
                        calculateTime(dEndForNoon, dEnd)
                        adapter.addData(eveTimeslots, timeslots, timeslotsBookedList)
                        noonTimeSlots.clear()
                        mornTimeSlots.clear()
                    }
                }
            }

            override fun onTabUnselected(tab: TabLayout.Tab) {}
            override fun onTabReselected(tab: TabLayout.Tab) {}
        })

        //Submitting data to book an appointment
        activityAvailableSlotsBinding.btnBookAppointment.setOnClickListener {
            /*
            *Checking whether fields are empty or not
            * If empty shows error msg
            * If not empty moving to another activity */
            if (formatDate.isNotEmpty()) {
                if (startTime?.isNotEmpty() && endTime?.isNotEmpty()) {
                    if (activityAvailableSlotsBinding.spinnerConcern.text.isNotEmpty()) {
                        val startTimeConv = "$formatDate $startTime"
                        val endTimeConv = "$formatDate $endTime"
                        val myStartDate = UiUtils.getDateTime(startTimeConv)
                        val myEndDate = UiUtils.getDateTime(endTimeConv)
                        val start = UiUtils.setDateTime(myStartDate)
                        val end = UiUtils.setDateTime(myEndDate)
                        /*
                        *Executing the function to submit the appointment data by passing
                        * Params Start and End time,Slot booked,notes,doctor id,condition id
                        * Back to List of hospital screen after submitted*/
                        availableSlotViewModel.submitAppointmentData(
                            activityAvailableSlotsBinding.spinnerConcern.text.toString(),
                            start,
                            end,
                            slot,
                            notes,
                            DoctorInfoActivity.doctorId,
                            DoctorInfoActivity.doctorIdentifier,
                            conditionId
                        ).observe(this) {
                            startActivity(ListOfHospitalsActivity.getCallingIntent(this@AvailableSlotActivity))
                        }

                    } else {
                        showToast(resources.getString(R.string.please_select_concern))
                    }
                } else {
                    showToast(resources.getString(R.string.please_select_slot))
                }
            } else {
                showToast(resources.getString(R.string.please_select_date))
            }
        }
    }

    //Getting Result data Back from after selecting the condition
    private var specialitySearchLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val data: Intent? = result.data
                if (data != null) {
                    activityAvailableSlotsBinding.spinnerConcern.text =
                        data.getStringExtra(Data).toString()
                    notes = data.getStringExtra(Notes).toString()
                    conditionId = ObjectId(data.getStringExtra(Id))
                }
            }
        }

    //Calculating time slots by start time and end time
    fun calculateTime(dStart: Date?, dEndForMorning: Date?) {
        val cal = Calendar.getInstance()
        cal.time = dStart
        if (dEndForMorning?.equals(df.parse(TimeEndForNoon)) == true) {
            while (cal.time.before(dEndForMorning)) {
                slotPosition = slotPosition?.inc()
                val startTime = df.format(cal.time).toString()
                cal.add(Calendar.MINUTE, timeSlotInterval)
                val endTime: String = df.format(cal.time)
                mornTimeSlots.add(TimeSlotData(start = startTime, end = endTime, id = slotPosition))

            }
        }
        if (dEndForMorning?.equals(df.parse(TimeEndForEve)) == true) {
            while (cal.time.before(dEndForNoon)) {
                slotPosition = slotPosition?.inc()
                val startTime = df.format(cal.time).toString()
                cal.add(Calendar.MINUTE, timeSlotInterval)
                val endTime: String = df.format(cal.time)
                noonTimeSlots.add(TimeSlotData(start = startTime, end = endTime, id = slotPosition))
            }
        }
        if (dStart?.equals(df.parse(TimeEndForEve)) == true) {
            while (cal.time.before(dEnd)) {
                slotPosition = slotPosition?.inc()
                val startTime = df.format(cal.time).toString()
                cal.add(Calendar.MINUTE, timeSlotInterval)
                val endTime: String = df.format(cal.time)
                eveTimeslots.add(TimeSlotData(start = startTime, end = endTime, id = slotPosition))
            }
        }
        if (df.parse("09:00 AM")?.equals(df.parse("09:00 AM")) == true) {
            while (cal.time.before(dEnd)) {
                cal.add(Calendar.MINUTE, timeSlotInterval)
                val newTime: String = df.format(cal.time)
                timeslots.add(newTime)
            }
        }
    }

    override fun nextClick() {
        this.finish()
    }

    fun updateSlot(start: String, end: String, slot: Long?) {
        startTime = start
        endTime = end
        this.slot = slot
    }

}