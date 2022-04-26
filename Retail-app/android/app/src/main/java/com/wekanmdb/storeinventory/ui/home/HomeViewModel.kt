package com.wekanmdb.storeinventory.ui.home

import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.orders.Orders
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class HomeViewModel @Inject constructor():BaseViewModel<HomeNavigator>() {
    /**
     * This getOrderInfo method is used to fetch Delivery order info to view Job.
     */
    fun getOrderInfo(orderId: ObjectId) : String? {
        var order: Orders?=null
        try {
            val openTasks = apprealm?.where<Orders>()?.equalTo("_id", orderId)?.findFirst()

            order = openTasks

        }
        catch (e:Exception){
            e.localizedMessage
        }
        return order!!.type!!.address
    }
}