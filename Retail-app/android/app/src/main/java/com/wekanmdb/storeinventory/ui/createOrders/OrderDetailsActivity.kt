package com.wekanmdb.storeinventory.ui.createOrders

import android.app.Activity
import android.content.Intent
import android.view.View
import androidx.activity.result.contract.ActivityResultContracts
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityOrderDetailsBinding
import com.wekanmdb.storeinventory.databinding.ActivityOrderSummaryBinding
import com.wekanmdb.storeinventory.model.orders.Orders
import com.wekanmdb.storeinventory.model.user.Users
import com.wekanmdb.storeinventory.ui.createjobs.JobProduct
import com.wekanmdb.storeinventory.ui.createjobs.SearchActivity
import com.wekanmdb.storeinventory.utils.Constants
import com.wekanmdb.storeinventory.utils.UiUtils
import kotlinx.android.synthetic.main.common_toolbar.*
import org.bson.types.ObjectId
import java.util.*
import kotlin.collections.ArrayList

class OrderDetailsActivity : BaseActivity<ActivityOrderSummaryBinding>(), CreateOrderNavigator {


    private lateinit var createOrderViewModel: CreateOrderViewModel
    private lateinit var activityOrderDetailsBinding: ActivityOrderDetailsBinding
    override fun getLayoutId(): Int = R.layout.activity_order_details
    var assignedBy: Users? = null
    private lateinit var productSummaryAdapter: ProductSummaryAdapter
    private lateinit var orderProductAdapter: OrderProductAdapter
    private var productList: ArrayList<JobProduct> = ArrayList()
    var myOrder: Orders? = null
    var isEdit = false
    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityOrderDetailsBinding = mViewDataBinding as ActivityOrderDetailsBinding
        createOrderViewModel =
            ViewModelProvider(this, viewModelFactory).get(CreateOrderViewModel::class.java)
        activityOrderDetailsBinding.createOrderViewModel = createOrderViewModel
        val orderId = intent.getStringExtra(Constants.ORDER_ID)
        isEdit = intent.getBooleanExtra(Constants.IS_EDIT, false)
        // getting the assigner details to create job
        getOrders(ObjectId(orderId))
        // initializing the adapter
        setAdapter()



        img_back.setOnClickListener {
            finish()
        }
        activityOrderDetailsBinding.textView104.setOnClickListener {
            if (activityOrderDetailsBinding.textView104.text == "DELETE") {
                val bundle = Intent()
                bundle.putExtra(Constants.ORDER_ID, orderId)
                setResult(2, bundle)
                finish()

            } else {
                val productsList = UiUtils.getRealmProductList(productList)
                createOrderViewModel.updateProducts(myOrder, productsList).observe(this,
                    {
                        if (it) {
                            finish()
                        }

                    })
            }
        }

        activityOrderDetailsBinding.textView112.setOnClickListener {
            openEditMode()

        }
        activityOrderDetailsBinding.textAddProduct.setOnClickListener {
            val productSearchIntent = Intent(this, SearchActivity::class.java)
            productSearchIntent.putExtra(Constants.SEARCH_TYPE, Constants.SEARCH_PRODUCT)
            productSearchLauncher.launch(productSearchIntent)
        }
        activityOrderDetailsBinding.textAddProducts.setOnClickListener {
            val inputQuantityString = activityOrderDetailsBinding.textQty.text.toString().trim()
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
                        maxProductQuantity, image
                    )
                    if (!UiUtils.itemAlreadyExist(productItem, productList)) {
                        productList.add(productItem)
                        orderProductAdapter.addData(productList)
                        orderProductAdapter.notifyDataSetChanged()
                        searchedProductId = ""
                        searchedProductName = ""
                        maxProductQuantity = -1
                        activityOrderDetailsBinding.textAddProduct.text = ""
                        activityOrderDetailsBinding.textQty.text.clear()
                    } else {
                        showToast("This item already selected")
                    }


                } else {
                    showToast("Maximum Product Quantity Exceeds")
                }
            }

        }
    }

    private fun initUiView(order: Orders?) {
        activityOrderDetailsBinding.apply {
            orders = order

            orderNumber = "Order#${order!!.orderId}"
            date = UiUtils.convertToCustomFormatDate(order.createdDate.toString())
            time = UiUtils.convertToCustomFormatTime(order.createdDate.toString())
        }
        myOrder = order
        order!!.products.forEach {
            productList.add(
                JobProduct(
                    id = it.product!!._id.toString(),
                    quantity = it.quantity,
                    name = it.product!!.name,
                    totalQuantity = 0,
                    image = it.product!!.image
                )
            )
        }

        productSummaryAdapter.addData(order.products)
        if (order.paymentStatus.equals("Pending", ignoreCase = true)) {
            View.VISIBLE
        } else {
            View.INVISIBLE
        }.let {
            activityOrderDetailsBinding.textView112.visibility = it
        }

        if (order.type!!.name == Constants.STORE_PICKUP) {
            activityOrderDetailsBinding.textView92.visibility = View.GONE
        }

        if (isEdit) {
            openEditMode()
        }

    }

    private fun openEditMode() {
        activityOrderDetailsBinding.editProduct.visibility = View.VISIBLE
        activityOrderDetailsBinding.textView112.visibility = View.INVISIBLE
        activityOrderDetailsBinding.textView104.text = "Update"
        setEditProductAdapter()
    }

    private fun setAdapter() {
        productSummaryAdapter = ProductSummaryAdapter(this)
        activityOrderDetailsBinding.productList.apply {
            layoutManager = LinearLayoutManager(this@OrderDetailsActivity)
            adapter = productSummaryAdapter
        }
    }

    private fun getOrders(userId: ObjectId?) {
        if (userId != null) {
            createOrderViewModel.getOrders(userId).observe(this) {

                initUiView(it)
            }
        }

    }

    override fun onBackPressed() {
        super.onBackPressed()
        finish()
    }


    private fun setEditProductAdapter() {
        orderProductAdapter = OrderProductAdapter(this) { position, jobProduct, isRemove ->
            if (isRemove) {
                removeItemExisting(jobProduct)
            }
        }
        activityOrderDetailsBinding.productList.apply {
            layoutManager = LinearLayoutManager(this@OrderDetailsActivity)
            adapter = orderProductAdapter
        }
        orderProductAdapter.addData(productList)
        orderProductAdapter.notifyDataSetChanged()
    }

    private fun removeItemExisting(item: JobProduct) {
        productList.remove(item)
        orderProductAdapter.notifyDataSetChanged()
    }

    var image = ""
    var maxProductQuantity = -1
    var searchedProductId = ""
    var searchedProductName = ""
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
        activityOrderDetailsBinding.textAddProduct.text = name
        if (id != null) {
            searchedProductId = id
        }
    }

}
