package com.wekanmdb.storeinventory.ui.productdetails

import androidx.databinding.ObservableField
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.storerealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.product.Products
import com.wekanmdb.storeinventory.model.storeInventory.StoreInventory
import org.bson.types.ObjectId
import javax.inject.Inject

class ProductDetailsViewModel @Inject constructor() : BaseViewModel<ProductDetailsNavigator>() {
    var productId: ObservableField<String> = ObservableField("")
    var inventryId: ObservableField<String> = ObservableField("")
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

    fun getInventryDetails(): MutableLiveData<StoreInventory?> {
        val inventryId = ObjectId(inventryId.get().toString())
        val responseBody = MutableLiveData<StoreInventory?>()
        storerealm?.executeTransaction { it ->
            val inventry = it.where(StoreInventory::class.java)?.equalTo("_id", inventryId)?.findFirst()
            if (inventry != null) {
                responseBody.value = inventry
            } else {
                responseBody.value = null
            }
        }
        return responseBody
    }

    fun updateInventryStock(stock: Int) : MutableLiveData<Boolean> {
        val inventryId = ObjectId(inventryId.get().toString())
        val response = MutableLiveData<Boolean>()
        try {

            storerealm?.executeTransaction {
                /* Updating the selected store inventory stocks */
                val storeInventory = it.where(StoreInventory::class.java)?.equalTo("_id", inventryId)?.findFirst()
                if (storeInventory != null) {
                    storeInventory.quantity=stock

                }
                it.insertOrUpdate(storeInventory)
            }
        }
        catch (e:Exception){
            response.postValue(false)
        }
        return response

    }
    fun updateMasterStock(quantity: Int) : MutableLiveData<Boolean> {
        val productId = ObjectId(productId.get().toString())
        val response = MutableLiveData<Boolean>()
        try {

            apprealm?.executeTransaction {
                /* Updating the Master products stock */
                    val product = it.where(Products::class.java)?.equalTo("_id", productId)?.findFirst()
                    if (product != null) {
                        product.totalQuantity= quantity.toLong()
                        it.insertOrUpdate(product)
                    }

            }
        }
        catch (e:Exception){
            response.postValue(false)
        }
        return response

    }

}