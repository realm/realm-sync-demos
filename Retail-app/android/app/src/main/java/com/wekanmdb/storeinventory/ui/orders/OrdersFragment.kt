package com.wekanmdb.storeinventory.ui.orders

import android.app.Dialog
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.view.View
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseFragment
import com.wekanmdb.storeinventory.databinding.FragmentJobsBinding
import com.wekanmdb.storeinventory.databinding.FragmentPointOfSaleBinding
import com.wekanmdb.storeinventory.model.orders.Orders
import com.wekanmdb.storeinventory.ui.createOrders.CreateOrderActivity
import com.wekanmdb.storeinventory.ui.createOrders.OrderDetailsActivity
import com.wekanmdb.storeinventory.ui.createjobs.CreateJobActivity
import com.wekanmdb.storeinventory.ui.createjobs.CreateOrderJobActivity
import com.wekanmdb.storeinventory.ui.inventory.InventoryFragment
import com.wekanmdb.storeinventory.utils.Constants
import com.wekanmdb.storeinventory.utils.Constants.Companion.HOME_DELIVERY
import io.realm.RealmResults
import kotlinx.android.synthetic.main.fragment_jobs.*
import kotlinx.android.synthetic.main.order_dialog.*

class OrdersFragment : BaseFragment<FragmentJobsBinding>(), OrdersNavigator {

    private lateinit var ordersViewModel: OrdersViewModel
    private lateinit var fragmentPointOfSaleBinding: FragmentPointOfSaleBinding
    private var ordersAdapter: OrdersAdapter? = null

    override val layoutId: Int
        get() = R.layout.fragment_point_of_sale

    override fun initView(mRootView: View?, mViewDataBinding: ViewDataBinding?) {

        fragmentPointOfSaleBinding = mViewDataBinding as FragmentPointOfSaleBinding
        ordersViewModel = ViewModelProvider(this).get(OrdersViewModel::class.java)
        fragmentPointOfSaleBinding.ordersViewModel = ordersViewModel
        ordersViewModel.navigator = this
        val storeId = InventoryFragment.selectedStoreId!!
        val userId = user?.customData?.getString("_id")
        ordersViewModel.storeId.set(storeId.toString())
        ordersViewModel.userId.set(userId.toString())

        ordersAdapter = OrdersAdapter(requireContext()) { item, openDialog ->
            if (openDialog) {
                menuDialog(item)
            } else {
                val jobDetailsIntent = Intent(context, OrderDetailsActivity::class.java)
                jobDetailsIntent.putExtra(Constants.ORDER_ID, item._id.toString())
                orderDetailsActivity.launch(jobDetailsIntent)
            }
        }
        mViewDataBinding.ordersAdapter = ordersAdapter
        getStore()
        getJobList()
    }

    // Query Realm for all Store
    private fun getStore() {
        ordersViewModel.storesresponseBody.observe(this, { storeDetails ->
            if (storeDetails != null) {
                fragmentPointOfSaleBinding.stores = storeDetails
                fragmentPointOfSaleBinding.executePendingBindings()
            } else {
             //   showToast("No more Data")
            }
        })
        //    ordersViewModel.getStore()
        ordersViewModel.storeListener()
    }

    // Query Realm for all joblist
    private fun getJobList() {
        ordersViewModel.ordersresponseBody.observe(this, { ordersList ->
            if (ordersList != null && ordersList.size > 0) {
                setView(ordersList)
                nojobsLayout.visibility = View.GONE
                rv_jobs.visibility = View.VISIBLE
            } else {
                nojobsLayout.visibility = View.VISIBLE
                rv_jobs.visibility = View.GONE
               // showToast("No More  data")
                textView34.text = "Total Items : 0"
                textView34.setBackgroundResource(R.drawable.edittext_bg_gray_corner)
            }
        })
        ordersViewModel.getOrderList()
        ordersViewModel.jobListener()
    }

    private fun setView(ordersList: RealmResults<Orders>?) {
        textView34.text = "Total Items : ${ordersList?.size}"
        textView34.setBackgroundResource(R.drawable.green_bg)
        ordersAdapter!!.setJobsAdapter(ordersList!!)
    }

    override fun addJobClick() {
        val createOrderIntent = Intent(activity, CreateOrderActivity::class.java)
        startActivity(createOrderIntent)

    }

    private fun menuDialog(order: Orders) {
        val dialog = Dialog(requireActivity(), R.style.dialog_center)
        dialog.setCancelable(true)
        dialog.setContentView(R.layout.order_dialog)
        dialog.show()
       if (order.type!!.name==HOME_DELIVERY) {
           View.VISIBLE
        } else {
           View.GONE
        }.let {
           dialog.view11.visibility=it
           dialog.textView56.visibility=it
        }
        dialog.textView57.setOnClickListener {
         //  if (order.paymentStatus.equals("Pending", ignoreCase = true)) {

            val jobDetailsIntent = Intent(context, OrderDetailsActivity::class.java)
            jobDetailsIntent.putExtra(Constants.ORDER_ID, order._id.toString())
            jobDetailsIntent.putExtra(Constants.IS_EDIT, true)
            requireContext().startActivity(jobDetailsIntent)
            dialog.dismiss()
       /*     }else{
                showToast("Edit allow only for payment pending orders")
            }*/
        }

        dialog.textView58.setOnClickListener {
            deleteOrder( order._id.toString())
            dialog.dismiss()
        }
        dialog.textView56.setOnClickListener {
            selectedOerder=order
            val createJobIntent = Intent(activity, CreateOrderJobActivity::class.java)
            startActivity(createJobIntent)
            dialog.dismiss()
        }

    }

    private var orderDetailsActivity =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == 2) {
                val data: Intent? = result.data
                if (data != null) {
                    showLoading()
                    val orderId = data.getStringExtra(Constants.ORDER_ID)
                    Handler(Looper.getMainLooper()).postDelayed({
                        deleteOrder(orderId!!)
                    }, 1000)


                }
            }
        }
    private fun deleteOrder(orderId:String){
        ordersViewModel.deleteOrder(orderId).observe(this,
            {
                if (it) {
                    getJobList()
                }
                hideLoading()
            })
    }
    companion object{
        var selectedOerder=Orders()
    }
}
