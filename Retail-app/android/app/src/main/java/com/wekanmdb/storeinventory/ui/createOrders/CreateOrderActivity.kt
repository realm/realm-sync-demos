package com.wekanmdb.storeinventory.ui.createOrders

import android.app.Activity
import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.content.Intent
import android.util.Log
import android.view.View
import android.widget.AdapterView
import android.widget.DatePicker
import android.widget.TimePicker
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.DialogFragment
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.gms.common.api.Status
import com.google.android.gms.maps.model.LatLng
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.model.Place
import com.google.android.libraries.places.api.net.PlacesClient
import com.google.android.libraries.places.widget.AutocompleteSupportFragment
import com.google.android.libraries.places.widget.listener.PlaceSelectionListener
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityCreateNewOrderBinding
import com.wekanmdb.storeinventory.model.job.ProductQuantity
import com.wekanmdb.storeinventory.model.orders.Orders_type
import com.wekanmdb.storeinventory.model.product.Products
import com.wekanmdb.storeinventory.ui.createjobs.CreateJobActivity
import com.wekanmdb.storeinventory.ui.createjobs.JobProduct
import com.wekanmdb.storeinventory.ui.createjobs.SearchActivity
import com.wekanmdb.storeinventory.utils.Constants
import com.wekanmdb.storeinventory.utils.Constants.Companion.CASH
import com.wekanmdb.storeinventory.utils.Constants.Companion.CREDIT_CARD
import com.wekanmdb.storeinventory.utils.Constants.Companion.HOME_DELIVERY
import com.wekanmdb.storeinventory.utils.Constants.Companion.LATITUDE
import com.wekanmdb.storeinventory.utils.Constants.Companion.LONGITUDE
import com.wekanmdb.storeinventory.utils.Constants.Companion.ORDERS
import com.wekanmdb.storeinventory.utils.Constants.Companion.STORE_PICKUP
import com.wekanmdb.storeinventory.utils.DatePickerFragment
import com.wekanmdb.storeinventory.utils.TimePickerFragment
import com.wekanmdb.storeinventory.utils.UiUtils
import com.wekanmdb.storeinventory.utils.UiUtils.showToast
import io.realm.RealmList
import kotlinx.android.synthetic.main.activity_createjob.*
import kotlinx.android.synthetic.main.common_toolbar.*
import org.bson.types.ObjectId
import java.text.SimpleDateFormat
import java.util.*

class CreateOrderActivity : BaseActivity<ActivityCreateNewOrderBinding>(),
    AdapterView.OnItemSelectedListener, DatePickerDialog.OnDateSetListener,
    TimePickerDialog.OnTimeSetListener {
    var jobAdapterPosition = -1
    var maxProductQuantity = -1
    var searchedProductId = ""
    var searchedProductName = ""
    var image = ""
    var jobProductList = ArrayList<JobProduct>()
    var orderDate: Date? = null
    var isTimeSet: Boolean = false
    var isDateSet: Boolean = false
    var calendar = Calendar.getInstance()
    private var placesClient: PlacesClient? = null
    private var latitude=0.0
    private var longitude=0.0
    private lateinit var jobProductAdapter: OrderProductAdapter
    private lateinit var createOrderViewModel: CreateOrderViewModel
    private lateinit var activityCreateNewOrderBinding: ActivityCreateNewOrderBinding
    override fun getLayoutId(): Int = R.layout.activity_create_new_order

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityCreateNewOrderBinding = mViewDataBinding as ActivityCreateNewOrderBinding
        createOrderViewModel =
            ViewModelProvider(this, viewModelFactory).get(CreateOrderViewModel::class.java)
        activityCreateNewOrderBinding.createOrderViewModel = createOrderViewModel

        val apiKey = getString(R.string.api_key)
        // Setup Places Client
        if (!Places.isInitialized()) {
            Places.initialize(
                applicationContext,
                apiKey
            )
        }
        placesClient = Places.createClient(applicationContext)
        //initializing the Places autocomplete
        initAutoCompleteTextView()
        // initializing the adapter
        setAdapter()
        orderDate = calendar.time

        activityCreateNewOrderBinding.textOrderId.text = System.currentTimeMillis().toString()
        // show date picker to select a date to create jobs
        activityCreateNewOrderBinding.textDate.setOnClickListener() {
            val datePicker: DialogFragment = DatePickerFragment()
            datePicker.show(supportFragmentManager, "date picker")
        }

        // show Time picker to select a time to create jobs

        activityCreateNewOrderBinding.textTime.setOnClickListener() {
            if (isDateSet) {
                val timePicker: DialogFragment = TimePickerFragment()
                timePicker.show(supportFragmentManager, "timePicker")
            } else {
                showToast("Please select Date first", this)
            }


        }
        activityCreateNewOrderBinding.storePickup.setOnClickListener {
            activityCreateNewOrderBinding.textView84.visibility=View.GONE
            activityCreateNewOrderBinding. address.visibility=View.GONE
        }
        activityCreateNewOrderBinding.homeDelivery.setOnClickListener {
            activityCreateNewOrderBinding.textView84.visibility=View.VISIBLE
            activityCreateNewOrderBinding. address.visibility=View.VISIBLE
        }
        // onClicking createJob button create the job by calling ViewModel method
        activityCreateNewOrderBinding.textNext.setOnClickListener {
            val orderID = activityCreateNewOrderBinding.textOrderId.text
            val cusName = activityCreateNewOrderBinding.editCustomerName.text
            val cusEmail = activityCreateNewOrderBinding.editCustomerEmail.text
            val pickupType = when {
                activityCreateNewOrderBinding.storePickup.isChecked -> {
                    STORE_PICKUP
                }
                activityCreateNewOrderBinding.homeDelivery.isChecked -> {
                    HOME_DELIVERY
                }
                else -> {
                    ""
                }
            }
            val payType = when {
                activityCreateNewOrderBinding.cash.isChecked -> {
                    "Cash"
                }
                activityCreateNewOrderBinding.creditCard.isChecked -> {
                    CREDIT_CARD
                }
                else -> {
                    ""
                }
            }

            val productList = UiUtils.getRealmProductList(jobProductList)

            if (!orderID.isNullOrEmpty() && !cusName.isNullOrEmpty() && !cusEmail.isNullOrEmpty() && orderDate != null && pickupType.isNotEmpty() && payType.isNotEmpty() && productList.size > 0) {
                selectedProducts = productList
                val orders = CreateOrder(
                    address = activityCreateNewOrderBinding.editCustomerAddress.text.toString(),
                    name = pickupType,
                    paymentType = payType,
                    orderId = orderID as String,
                    customerName = cusName.toString(),
                    createdDate = orderDate as Date,
                    customerEmail = cusEmail.toString(),
                    paymentStatus = "Pending"
                )

                val createJobIntent = Intent(this, CreateOrderSummaryActivity::class.java)
                createJobIntent.putExtra(ORDERS, orders)
                createJobIntent.putExtra(LATITUDE, latitude)
                createJobIntent.putExtra(LONGITUDE, longitude)
                createOrderSummaryActivityLauncher.launch(createJobIntent)

            } else {
                Toast.makeText(this, "Fill the all fields", Toast.LENGTH_SHORT).show()
            }


        }

        activityCreateNewOrderBinding.textAddProducts.setOnClickListener {
            val inputQuantityString = activityCreateNewOrderBinding.textQty.text.toString().trim()
            var inputQuantity = 1
            if (!inputQuantityString.contentEquals("") && !inputQuantityString.isNullOrBlank()) {
                inputQuantity = UiUtils.getNumber(inputQuantityString)
            }

            if (searchedProductName.isNullOrEmpty() && searchedProductId.isNullOrEmpty()) {
                showToast("Please Select Product")

            } else {
                if (inputQuantity <= maxProductQuantity) {
                    val productItem = JobProduct(
                        searchedProductId,
                        inputQuantity,
                        searchedProductName,
                        maxProductQuantity,image
                    )
                    if (!UiUtils.itemAlreadyExist(productItem, jobProductList)) {
                        jobProductList.add(productItem)
                        jobProductAdapter.addData(jobProductList)
                        jobProductAdapter.notifyDataSetChanged()
                        searchedProductId = ""
                        searchedProductName = ""
                        maxProductQuantity = -1
                        activityCreateNewOrderBinding.textAddProduct.text = ""
                        activityCreateNewOrderBinding.textQty.text.clear()
                    } else {
                        showToast("This item already selected")
                    }


                } else {
                    showToast("Maximum Product Quantity Exceeds")
                }
            }

        }

        img_back.setOnClickListener {
            finish()
        }
        activityCreateNewOrderBinding.textAddProduct.setOnClickListener {
            val productSearchIntent = Intent(this, SearchActivity::class.java)
            productSearchIntent.putExtra(Constants.SEARCH_TYPE, Constants.SEARCH_PRODUCT)
            productSearchLauncher.launch(productSearchIntent)
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
        orderDate = calendar.time
        Log.d("wekanc", "date after date selection : $orderDate")

        try {
            val d = dateFormat.parse(dat)
            val jobDay = dateFormat.format(d)
            activityCreateNewOrderBinding.textDate.text = jobDay
            isDateSet = true


        } catch (e: Exception) { //java.text.ParseException: Unparseable date: Geting error
            Log.d("errordroid", e.message.toString())
        }

    }

    override fun onTimeSet(view: TimePicker?, hour: Int, minute: Int) {
        var am_pm = ""
        calendar[Calendar.HOUR_OF_DAY] = hour
        calendar[Calendar.MINUTE] = minute
        orderDate = calendar.time

        Log.d("wekanc", "date after time set : $orderDate")

        if (calendar.get(Calendar.AM_PM) == Calendar.AM)
            am_pm = "AM";
        else if (calendar.get(Calendar.AM_PM) == Calendar.PM)
            am_pm = "PM";
        val strHrsToShow =
            if (calendar.get(Calendar.HOUR) === 0) "12" else calendar.get(Calendar.HOUR)
                .toString() + ""
        activityCreateNewOrderBinding.textTime.text =
            strHrsToShow + ":" + calendar.get(Calendar.MINUTE) + " " + am_pm
        isTimeSet = true


    }

    var createOrderSummaryActivityLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == 2) {
                finish()
            }
        }
    private var productSearchLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val data: Intent? = result.data
                if (data != null) {
                    val id = data.getStringExtra("id")
                    val name = data.getStringExtra("name")
                    val totalQuantity = data.getIntExtra("quantity", -1)
                     image = data.getStringExtra("image").toString()
                    updateProductInputTaker(id, name, totalQuantity)

                }
            }
        }

    private fun updateProductInputTaker(id: String?, name: String?, totalQuantity: Int) {
        maxProductQuantity = totalQuantity
        if (name != null) {
            searchedProductName = name
        }
        activityCreateNewOrderBinding.textAddProduct.text = name
        if (id != null) {
            searchedProductId = id
        }
    }

    private fun setAdapter() {
        jobProductAdapter = OrderProductAdapter(this){position,jobProduct,isRemove->

            if(isRemove){
                removeItemExisting(jobProduct)
            }else{
                searchProduct(position)
            }

        }
        activityCreateNewOrderBinding.recyclerView2.apply {
            layoutManager = LinearLayoutManager(this@CreateOrderActivity)
            adapter = jobProductAdapter
        }
    }

    fun removeItemExisting(item: JobProduct) {
        jobProductList.remove(item)
        jobProductAdapter.notifyDataSetChanged()
    }
    fun searchProduct(position: Int) {
        jobAdapterPosition = position
        val productSearchIntent = Intent(this, SearchActivity::class.java)
        productSearchIntent.putExtra(Constants.SEARCH_TYPE, Constants.SEARCH_PRODUCT)
        productSearchLauncher.launch(productSearchIntent)
    }


    private fun initAutoCompleteTextView() {

        try {

            // Initialize the AutocompleteSupportFragment.
            val autocompleteFragment =
                supportFragmentManager.findFragmentById(R.id.autocomplete_fragment)
                        as AutocompleteSupportFragment

            // Specify the types of place data to return.
            autocompleteFragment.setPlaceFields(
                listOf(
                    Place.Field.ID,
                    Place.Field.NAME,
                    Place.Field.ADDRESS,
                    Place.Field.LAT_LNG
                )
            )
            // Set up a PlaceSelectionListener to handle the response.

            autocompleteFragment.setOnPlaceSelectedListener(object : PlaceSelectionListener {
                override fun onPlaceSelected(place: Place) {
                    activityCreateNewOrderBinding.editCustomerAddress.text=place.address
                    latitude=place.latLng!!.latitude
                    longitude=place.latLng!!.longitude

                }


                override fun onError(p0: Status) {
                }


            })


        } catch (e: Exception) {

        }
    }
    companion object {
        var selectedProducts = RealmList<ProductQuantity>()
    }

    override fun onResume() {
        super.onResume()
        val date = Calendar.getInstance().time
        val df = SimpleDateFormat("yyyy-MM-dd")
        val tf = SimpleDateFormat("hh:mm a")
        activityCreateNewOrderBinding.textDate.text = df.format(date)
        isDateSet = true
        activityCreateNewOrderBinding.textTime.text =tf.format(date)
        isTimeSet = true
    }
}
