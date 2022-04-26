package com.wekanmdb.storeinventory.ui.createOrders

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.model.job.ProductQuantity
import com.wekanmdb.storeinventory.model.orders.Order_Location
import com.wekanmdb.storeinventory.model.orders.Orders
import com.wekanmdb.storeinventory.model.orders.Orders_type
import com.wekanmdb.storeinventory.model.user.Users
import com.wekanmdb.storeinventory.utils.Constants.Companion.HOME_DELIVERY
import io.realm.RealmChangeListener
import io.realm.RealmList
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class CreateOrderViewModel @Inject constructor() : BaseViewModel<CreateOrderNavigator>() {

    lateinit var createOrder: Orders
    private val _jobCreatedStatus = MutableLiveData<String>()
    val jobCreatedStatus: MutableLiveData<String> = _jobCreatedStatus

    /**
     * This method to fetch the Store object which is used to create Job.
     */
    fun getOrders(orderId: ObjectId?): MutableLiveData<Orders?> {
        val responseBody = MutableLiveData<Orders?>()
        try {
            val openTasks = apprealm?.where<Orders>()?.equalTo("_id", orderId)?.findAllAsync()
            openTasks?.addChangeListener(
                RealmChangeListener<RealmResults<Orders>> {
                    if (it.isNotEmpty()) {
                        val order: Orders? = it[0]
                        responseBody.postValue(order!!)
                    } else {
                        responseBody.value = null
                    }
                }
            )
        } catch (e: Exception) {
            responseBody.value = null
        }
        return responseBody
    }

    /**
     * This getAssignee method is used to fetch Delivery Users to assign to Job.
     */
    fun getAssignees(userId: ObjectId): MutableLiveData<Users> {
        val responseBody = MutableLiveData<Users>()
        try {
            val openTasks = apprealm?.where<Users>()?.equalTo("_id", userId)?.findAll()
            val user: Users? = openTasks?.get(0)
            responseBody.postValue(user!!)

        } catch (e: Exception) {
            e.localizedMessage
        }
        return responseBody
    }

    /**
     * This method is to create order with all the required objects.
     * and after successfully creating order returning true (Boolean).
     */
    fun createOrder(
        order: CreateOrder?,
        assignedBy: Users?,
        selectedProducts: RealmList<ProductQuantity>,
        latitude: Double,
        longitude: Double
    ): MutableLiveData<Boolean> {
        val response = MutableLiveData<Boolean>()
        try {


            apprealm?.executeTransaction() {
                createOrder = Orders()
                createOrder._partition = "master"
                createOrder.type = Orders_type(
                    address = order?.address!!,
                    name = order.name!!
                )
                createOrder.paymentType = order.paymentType.toString()
                createOrder.orderId = order.orderId.toString()
                createOrder.customerName = order.customerName.toString()
                createOrder.createdDate = order.createdDate!!
                createOrder.customerEmail = order.customerEmail.toString()
                createOrder.createdBy = assignedBy
                createOrder.products = selectedProducts
                createOrder.paymentStatus = "Paid"
                if(order.name==HOME_DELIVERY){
                    createOrder.location = Order_Location(
                        latitude = latitude,
                        longitude = longitude
                    )
                }
                it.insert(createOrder)
                response.postValue(true)
            }
        } catch (e: Exception) {
            response.postValue(false)
            _jobCreatedStatus.postValue(e.localizedMessage)
        }
        return response

    }
    /**
     * update the products to the created order
     */
    fun updateProducts(
        order: Orders?,
        selectedItems: RealmList<ProductQuantity>
    ): MutableLiveData<Boolean> {
        val response = MutableLiveData<Boolean>()
        try {

            apprealm?.executeTransaction() {
                    val updatedProducts = RealmList<ProductQuantity>()
                    selectedItems.forEach { item ->
                        updatedProducts.add(it.copyToRealm(item))
                    }
                    order!!.products = updatedProducts



                response.postValue(true)
            }
        } catch (e: Exception) {
            response.postValue(false)
        }
        return response

    }


}