package com.wekanmdb.storeinventory.ui.createOrders

import android.view.View
import android.widget.Toast
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityOrderSummaryBinding
import com.wekanmdb.storeinventory.model.user.Users
import com.wekanmdb.storeinventory.ui.createOrders.CreateOrderActivity.Companion.selectedProducts
import com.wekanmdb.storeinventory.utils.Constants.Companion.LATITUDE
import com.wekanmdb.storeinventory.utils.Constants.Companion.LONGITUDE
import com.wekanmdb.storeinventory.utils.Constants.Companion.ORDERS
import com.wekanmdb.storeinventory.utils.Constants.Companion.STORE_PICKUP
import com.wekanmdb.storeinventory.utils.UiUtils
import kotlinx.android.synthetic.main.common_toolbar.*
import org.bson.types.ObjectId
import java.util.*

class CreateOrderSummaryActivity : BaseActivity<ActivityOrderSummaryBinding>() {


    private lateinit var createOrderViewModel: CreateOrderViewModel
    private lateinit var activityOrderSummaryBinding: ActivityOrderSummaryBinding
    override fun getLayoutId(): Int = R.layout.activity_order_summary
    var assignedBy: Users? = null
    private lateinit var orderProductAdapter: ProductSummaryAdapter
    private var latitude=0.0
    private var longitude=0.0
    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityOrderSummaryBinding = mViewDataBinding as ActivityOrderSummaryBinding
        createOrderViewModel =
            ViewModelProvider(this, viewModelFactory).get(CreateOrderViewModel::class.java)
        activityOrderSummaryBinding.createOrderViewModel = createOrderViewModel
        val userId = user?.customData?.getString("_id")
        // getting the assigner details to create job
        getAssignerId(ObjectId(userId))
        // initializing the adapter
        setAdapter()
        orderProductAdapter.addData(selectedProducts)
        val orders: CreateOrder? = intent.getParcelableExtra(ORDERS)
         latitude = intent.getDoubleExtra(LATITUDE,0.0)
         longitude = intent.getDoubleExtra(LONGITUDE,0.0)
        initUiView(orders)

        img_back.setOnClickListener {
            finish()
        }
        activityOrderSummaryBinding.textView104.setOnClickListener {
            createOrderViewModel.createOrder(
                orders, assignedBy, selectedProducts,latitude,longitude
            ).observe(this) {
                Toast.makeText(this, "Order is Created", Toast.LENGTH_SHORT).show()
                setResult(2)
                finish()

            }
        }
        img_back.setOnClickListener {
            finish()
        }
    }

    private fun initUiView(orders: CreateOrder?) {
        if (orders!!.name == STORE_PICKUP) {
            activityOrderSummaryBinding.textView92.visibility = View.GONE
        }
        activityOrderSummaryBinding.textView91.text = orders!!.name
        activityOrderSummaryBinding.textView92.text = orders.address
        activityOrderSummaryBinding.textView94.text =
            UiUtils.convertToCustomFormatDate(orders.createdDate.toString())
        activityOrderSummaryBinding.textView95.text =
            UiUtils.convertToCustomFormatTime(orders.createdDate.toString())
        activityOrderSummaryBinding.textView98.text = orders.customerName
        activityOrderSummaryBinding.textView100.text = orders.customerEmail
        activityOrderSummaryBinding.textView103.text = orders.paymentType
    }

    private fun setAdapter() {
        orderProductAdapter = ProductSummaryAdapter(this)
        activityOrderSummaryBinding.recyclerView2.apply {
            layoutManager = LinearLayoutManager(this@CreateOrderSummaryActivity)
            adapter = orderProductAdapter
        }
    }

    private fun getAssignerId(userId: ObjectId?) {
        if (userId != null) {
            createOrderViewModel.getAssignees(userId).observe(this) {
                assignedBy = it
            }
        }

    }

    override fun onBackPressed() {
        super.onBackPressed()
        finish()
    }


}
