package com.wekanmdb.storeinventory.utils

import android.content.ContentValues.TAG
import android.util.Log
import com.wekanmdb.storeinventory.app.key
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.model.job.ProductQuantity
import com.wekanmdb.storeinventory.model.orders.Orders
import com.wekanmdb.storeinventory.model.product.Products
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.model.storeInventory.StoreInventory
import com.wekanmdb.storeinventory.model.user.Users
import io.realm.mongodb.sync.SyncConfiguration
import java.util.*

object RealmUtils {
    fun getRealmconfig (partitionValue: String): SyncConfiguration {
        val config = SyncConfiguration.Builder(user, partitionValue)
            .allowQueriesOnUiThread(true)
            .allowWritesOnUiThread(true)
            .errorHandler { session, error ->
                Log.e(TAG, "Sync error: ${error.errorMessage}")
            }
            .waitForInitialRemoteData()
            .initialData {
                it.where(Users::class.java)
                it.where(Products::class.java)
                it.where(Stores::class.java)
                it.where(Jobs::class.java)
                it.where(ProductQuantity::class.java)
                it.where(StoreInventory::class.java)
                it.where(Orders::class.java)
            }
            .encryptionKey(key)
            .build()

        Arrays.fill(key, 0.toByte())
        return config
    }
}