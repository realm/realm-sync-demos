package com.wekanmdb.storeinventory.ui.createjobs

import android.app.Activity
import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.content.Intent
import android.util.Log
import android.view.View
import android.widget.*
import androidx.activity.result.contract.ActivityResultContracts
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.DialogFragment
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityCreateOrderJobBinding
import com.wekanmdb.storeinventory.databinding.ActivityCreatejobBinding
import com.wekanmdb.storeinventory.model.job.ProductQuantity
import com.wekanmdb.storeinventory.model.orders.Orders
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.model.user.Users
import com.wekanmdb.storeinventory.ui.inventory.InventoryFragment
import com.wekanmdb.storeinventory.ui.orders.OrdersFragment.Companion.selectedOerder
import com.wekanmdb.storeinventory.utils.Constants
import com.wekanmdb.storeinventory.utils.Constants.Companion.SEARCH_ASSIGNEE
import com.wekanmdb.storeinventory.utils.Constants.Companion.SEARCH_TYPE
import com.wekanmdb.storeinventory.utils.Constants.Companion.STORE_PICKUP
import com.wekanmdb.storeinventory.utils.DatePickerFragment
import com.wekanmdb.storeinventory.utils.TimePickerFragment
import com.wekanmdb.storeinventory.utils.UiUtils.showToast
import io.realm.RealmList
import kotlinx.android.synthetic.main.activity_createjob.*
import kotlinx.android.synthetic.main.common_toolbar.*
import org.bson.types.ObjectId
import java.text.SimpleDateFormat
import java.util.*

class CreateOrderJobActivity : BaseActivity<ActivityCreatejobBinding>(),
    AdapterView.OnItemSelectedListener, DatePickerDialog.OnDateSetListener,
    TimePickerDialog.OnTimeSetListener {
    var jobAdapterPosition = -1
    var maxProductQuantity = -1
    var searchedProductId = ""
    var searchedProductName = ""
    var image = ""
    var jobProductList = RealmList<ProductQuantity>()
    var ownerStore: Stores? = null
    var dropStore: Stores? = null
    var assignedTo: Users? = null
    var assignedBy: Users? = null
    var jobDate: Date? = null
    var isTimeSet: Boolean = false
    var isDateSet: Boolean = false
    var calendar = Calendar.getInstance()
    private lateinit var orderJobProductAdapter: OrderJobProductAdapter
    private lateinit var createJobViewModel: CreateJobViewModel
    private lateinit var activityCreateOrderJobBinding: ActivityCreateOrderJobBinding
    override fun getLayoutId(): Int = R.layout.activity_create_order_job

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityCreateOrderJobBinding = mViewDataBinding as ActivityCreateOrderJobBinding
        createJobViewModel =
            ViewModelProvider(this, viewModelFactory).get(CreateJobViewModel::class.java)
        activityCreateOrderJobBinding.createJobViewModel = createJobViewModel
        // initializing the adapter
        setAdapter()
        // jobDate = calendar.time
        val userId = user?.customData?.getString("_id")
        // getting the assigner details to create job
        getAssignerId(ObjectId(userId))
        // setting the source store name
        var order = selectedOerder
        //init values
        updateView(order)
        activityCreateOrderJobBinding.sourcestoreh.apply {
            createJobViewModel.getStore(InventoryFragment.selectedStoreId)
                .observe(this@CreateOrderJobActivity) {
                    ownerStore = it
                    text = ownerStore?.name.toString()
                        .capitalize(Locale.US)
                }
        }

        // select assignee from search activity

        activityCreateOrderJobBinding.assigneeh.setOnClickListener() {
            val assigneeIntent = Intent(this, SearchActivity::class.java)
            assigneeIntent.putExtra(SEARCH_TYPE, SEARCH_ASSIGNEE)
            assigneeSearchLauncher.launch(assigneeIntent)
        }

        // show date picker to select a date to create jobs
        activityCreateOrderJobBinding.dateh.setOnClickListener() {
            val datePicker: DialogFragment = DatePickerFragment()
            datePicker.show(supportFragmentManager, "date picker")
        }

        // show Time picker to select a time to create jobs

        activityCreateOrderJobBinding.timeh.setOnClickListener() {
            if (isDateSet) {
                val timePicker: DialogFragment = TimePickerFragment()
                timePicker.show(supportFragmentManager, "timePicker")
            } else {
                showToast("Please select Date first", this)
            }


        }

        // onClicking createJob button create the job by calling ViewModel method
        activityCreateOrderJobBinding.createjob.setOnClickListener {
            if (assignedBy != null && isDateSet && isTimeSet && assignedTo != null && ownerStore != null && jobDate != null && jobProductList.size > 0) {
                assignedBy?.let { it1 ->
                    assignedTo?.let { it2 ->
                        ownerStore?.let { it3 ->

                            createJobViewModel.createJobFromOrder(
                                it1,
                                it2,
                                it3,
                                jobDate!!,
                                jobProductList,
                                order._id,
                                activityCreateOrderJobBinding.spinner2.selectedItem.toString(),dropStore
                            ).observe(this) {
                                if (it) {
                                    Toast.makeText(this, "Job is Created", Toast.LENGTH_SHORT)
                                        .show()
                                    finish()
                                }else{
                                    Toast.makeText(this, "Job already created", Toast.LENGTH_SHORT)
                                        .show()
                                }
                            }
                        }

                    }
                }
            } else {
                Toast.makeText(this, "Fill the all fields", Toast.LENGTH_SHORT).show()
            }
            Log.d("wekanc", "Job date is $jobDate")

        }

        initJobCreateListener()
        // img_back.title = "Create Order"
        img_back.setOnClickListener {
            finish()
        }

        activityCreateOrderJobBinding.textView68.setOnClickListener {
            finish()
        }

        // select the drop store from search activity
        activityCreateOrderJobBinding.dropstoreh.setOnClickListener() {
            if(order.type!!.name==STORE_PICKUP) {
                activityCreateOrderJobBinding.dropStoreTitle.text=resources.getString(R.string.destination_store)
                val storeSearchIntent = Intent(this, SearchActivity::class.java)
                storeSearchIntent.putExtra(SEARCH_TYPE, Constants.SEARCH_STORE)
                storeSearchLauncher.launch(storeSearchIntent)
            }
        }
    }


    private fun updateView(order: Orders) {
        jobProductList = order.products

        activityCreateOrderJobBinding.dropstoreh.text = order.type!!.address

        activityCreateOrderJobBinding.sourcestoreh.text = order.type!!.address
        orderJobProductAdapter.addData(order.products)
        orderJobProductAdapter.notifyDataSetChanged()

        val jobType = if (order.type!!.name == STORE_PICKUP) {
            activityCreateOrderJobBinding.dropStoreTitle.text=resources.getString(R.string.destination_store)
            listOf("Delivery")
        } else {
            listOf("Delivery", "Installation")
        }
        val adapter = ArrayAdapter(
            this,
            R.layout.spinner_row, jobType
        )
        activityCreateOrderJobBinding.spinner2.adapter = adapter
    }


    private fun initJobCreateListener() {
        createJobViewModel.jobCreatedStatus.observe(this) {
            // showing error while creating Job
            showToast(it)
        }
    }

    private fun getAssignerId(userId: ObjectId?) {
        if (userId != null) {
            createJobViewModel.getAssignees(userId).observe(this) {
                assignedBy = it
            }
        }

    }

    private fun setAdapter() {
        orderJobProductAdapter = OrderJobProductAdapter(this)
        activityCreateOrderJobBinding.listView.apply {
            layoutManager = LinearLayoutManager(this@CreateOrderJobActivity)
            adapter = orderJobProductAdapter
        }
    }


    private var productSearchLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val data: Intent? = result.data
                if (data != null) {
                    val id = data.getStringExtra("id")
                    val name = data.getStringExtra("name")
                    image = data.getStringExtra("image").toString()
                    val totalQuantity = data.getIntExtra("quantity", -1)
                    updateProductInputTaker(id, name, totalQuantity)

                }
            }
        }
    var storeSearchLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val data: Intent? = result.data
                if (data != null) {
                    data.getStringExtra("data")
                    val storeid = data.getStringExtra("id")

                    createJobViewModel.getStore(ObjectId(storeid)).observe(this){
                        dropStore = it
                        dropstoreh.text = dropStore?.name.toString()
                            .capitalize(Locale.US)
                    }

                }
            }
        }

    private fun updateProductInputTaker(id: String?, name: String?, totalQuantity: Int) {
        maxProductQuantity = totalQuantity
        if (name != null) {
            searchedProductName = name
        }
        if (id != null) {
            searchedProductId = id
        }
    }

    var assigneeSearchLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val data: Intent? = result.data
                if (data != null) {
                    data.getStringExtra("data")
                    val id = data.getStringExtra("id")
                    createJobViewModel.getAssignees(ObjectId(id)).observe(this) {
                        assignedTo = it
                        activityCreateOrderJobBinding.assigneeh.text =
                            assignedTo?.firstName.toString()
                                .capitalize(Locale.US)

                    }

                }
            }
        }


    override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {

    }

    override fun onNothingSelected(parent: AdapterView<*>?) {

    }

    override fun onBackPressed() {
        super.onBackPressed()
        finish()
    }

    override fun onDateSet(view: DatePicker?, year: Int, month: Int, dayOfMonth: Int) {
        calendar[Calendar.YEAR] = year
        calendar[Calendar.MONTH] = month
        calendar[Calendar.DATE] = dayOfMonth
        var months = month + 1
        var dat = "$year-$months-$dayOfMonth"
        val dateFormat = SimpleDateFormat("yyyy-mm-dd")
        jobDate = calendar.time
        Log.d("wekanc", "date after date selection : $jobDate")

        try {
            val d = dateFormat.parse(dat)
            val jobDay = dateFormat.format(d)
            activityCreateOrderJobBinding.dateh.text = jobDay
            isDateSet = true


        } catch (e: Exception) { //java.text.ParseException: Unparseable date: Geting error
            Log.d("errordroid", e.message.toString())
        }

    }

    override fun onTimeSet(view: TimePicker?, hour: Int, minute: Int) {
        var am_pm = ""
        calendar[Calendar.HOUR_OF_DAY] = hour
        calendar[Calendar.MINUTE] = minute
        jobDate = calendar.time

        Log.d("wekanc", "date after time set : $jobDate")

        if (calendar.get(Calendar.AM_PM) == Calendar.AM)
            am_pm = "AM";
        else if (calendar.get(Calendar.AM_PM) == Calendar.PM)
            am_pm = "PM";
        val strHrsToShow =
            if (calendar.get(Calendar.HOUR) === 0) "12" else calendar.get(Calendar.HOUR)
                .toString() + ""
        activityCreateOrderJobBinding.timeh.text =
            strHrsToShow + ":" + calendar.get(Calendar.MINUTE) + " " + am_pm
        isTimeSet = true


    }


}
