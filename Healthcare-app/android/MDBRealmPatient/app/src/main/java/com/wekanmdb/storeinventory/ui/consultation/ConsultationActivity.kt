package com.wekanmdb.storeinventory.ui.consultation

import android.os.Build
import androidx.annotation.RequiresApi
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityConsultationListBinding
import com.wekanmdb.storeinventory.model.encounter.Encounter
import com.wekanmdb.storeinventory.utils.Constants.Companion.DateTimeFormat
import com.wekanmdb.storeinventory.utils.Constants.Companion.TimeFormat
import kotlinx.android.synthetic.main.activity_consultation_list.*
import kotlinx.android.synthetic.main.common_toolbar.*
import org.bson.types.ObjectId
import java.text.SimpleDateFormat
import java.util.*

class ConsultationActivity : BaseActivity<ActivityConsultationListBinding>() {

    companion object {
        var slottime: Date? = null
        var AppointmentId: ObjectId? = null
    }

    override fun getLayoutId(): Int = R.layout.activity_consultation_list
    private lateinit var activityConsultationListBinding: ActivityConsultationListBinding
    private lateinit var consultationViewModel: ConsultationViewModel
    private lateinit var recyclerUpcomingAdapter: RecyclerUpcomingAdapter
    private lateinit var recyclerPastAdapter: RecyclerPastAdapter
    private var upcoming: ArrayList<Encounter>? = ArrayList()
    private var past: ArrayList<Encounter>? = ArrayList()
    var currentdate: String? = null

    @RequiresApi(Build.VERSION_CODES.O)
    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityConsultationListBinding = mViewDataBinding as ActivityConsultationListBinding
        consultationViewModel =
            ViewModelProvider(this, viewModelFactory).get(ConsultationViewModel::class.java)
        activityConsultationListBinding.consultation = consultationViewModel
        //Calling the function to get all booked appointments
        consultationViewModel.getConsultationDataList()

        //Getting response from of all condition
        consultationViewModel.consultationResponseBody.observe(this, Observer { it ->
            it?.forEach {
                val now = Date(System.currentTimeMillis())
                val date = SimpleDateFormat(TimeFormat).format(now)
                val upcomingDate = SimpleDateFormat(TimeFormat).format(it.appointment?.start)
                currentdate = SimpleDateFormat(DateTimeFormat).format(now)

                //comparing the current date and upcoming
                if (date.toInt() <= upcomingDate.toInt()) {
                    upcoming?.add(it)
                } else {
                    past?.add(it)
                }
            }
            /*
            * Setting Upcoming appointment in recyclerview*/
            if (upcoming?.isNotEmpty()!!) {
                recyclerUpcomingAdapter.addData(upcoming!!)
            }
            /*
            * Setting Past appointment in recyclerview*/
            if (past?.isNotEmpty()!!) {
                recyclerPastAdapter.addData(past!!)
            }
            recyclerUpcomingAdapter.notifyDataSetChanged()
            recyclerPastAdapter.notifyDataSetChanged()

        })

        setAdapter()
        img_back.setOnClickListener {
            finish()
        }
    }

    /*
    * adapter for upcoming and past recyclerview*/
    private fun setAdapter() {
        this.recyclerUpcomingAdapter = RecyclerUpcomingAdapter(this)
        recycler_upcoming_cons.apply {
            layoutManager = LinearLayoutManager(
                this@ConsultationActivity,
                LinearLayoutManager.HORIZONTAL,
                false
            )
            adapter = this@ConsultationActivity.recyclerUpcomingAdapter
        }
        this.recyclerPastAdapter = RecyclerPastAdapter(this)
        recycler_pastList.apply {
            layoutManager = LinearLayoutManager(this@ConsultationActivity)
            adapter = this@ConsultationActivity.recyclerPastAdapter
        }

    }
}