package com.wekanmdb.storeinventory.ui.productdetails

import androidx.databinding.ObservableField
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.product.Products
import org.bson.types.ObjectId
import javax.inject.Inject

class ProductDetailsViewModel @Inject constructor() : BaseViewModel<ProductDetailsNavigator>() {
    var productId: ObservableField<String> = ObservableField("")
    var totalQuantity: ObservableField<String> = ObservableField("")

    fun getProductDetails(): MutableLiveData<Products?> {
        val productId = ObjectId(productId.get().toString())
        val responseBody = MutableLiveData<Products?>()
        apprealm?.executeTransaction { transactionRealm ->
            val products = apprealm?.where(Products::class.java)?.equalTo("_id", productId)?.findFirst()
            if (products != null) {
                responseBody.value = products
            } else {
                responseBody.value = null
            }
        }
        return responseBody
    }
}