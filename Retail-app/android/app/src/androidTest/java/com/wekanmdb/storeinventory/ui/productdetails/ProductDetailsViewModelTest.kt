package com.wekanmdb.storeinventory.ui.productdetails

import android.content.ContentValues
import android.util.Log
import androidx.annotation.NonNull
import androidx.arch.core.executor.testing.InstantTaskExecutorRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.filters.LargeTest
import com.google.common.truth.Truth.assertThat
import com.pachai.realm.ui.utils.getOrAwaitValue
import com.wekanmdb.storeinventory.BuildConfig
import com.wekanmdb.storeinventory.app.AppApplication
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.taskApp
import com.wekanmdb.storeinventory.data.AppPreference
import com.wekanmdb.storeinventory.model.product.Products
import com.wekanmdb.storeinventory.model.store.Stores
import io.realm.Realm
import io.realm.RealmConfiguration
import io.realm.mongodb.App
import io.realm.mongodb.AppConfiguration
import org.bson.types.ObjectId
import org.junit.After
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith


@RunWith(AndroidJUnit4::class)
@LargeTest
class ProductDetailsViewModelTest{
    val productDetailsViewModel = ProductDetailsViewModel()
    var appPreference: AppPreference?=null
    var productsItem: Products? = null

    @Before
    @Throws(Exception::class)
    fun setUp() {
        appPreference= AppApplication.getInstance()?.getAppPreference()
        val config = RealmConfiguration.Builder().name("master").build()
        apprealm = Realm.getInstance(config)
    }

    @After
    @Throws(Exception::class)
    fun tearDown() {
        apprealm?.executeTransaction {
            productsItem?.deleteFromRealm()
        }
        apprealm?.close()
    }

    @get:Rule
    val instantTaskExecutorRule = InstantTaskExecutorRule()

    @Test
    @Throws(Exception::class)
    fun getProductDetail() {
        productDetailsViewModel.productId.set("613a2caf90e5f54ab3909c87")
        apprealm?.executeTransaction { r: Realm ->
            val primaryKeyValue = ObjectId("613a2caf90e5f54ab3909c87")
            productsItem = r.createObject(Products::class.java, primaryKeyValue)
            productsItem?.name = "Mouse"
            productsItem?.detail = "Wireless Mouse"
            productsItem?.sku = 1234
            productsItem?.image = "https://dummyimage.com/200x200/000/ffffff&text=Mouse"
            productsItem?.price =20.0
            productsItem?.totalQuantity =45
            productsItem?._partition = "master"
        }
        val productDetailslist=productDetailsViewModel.getProductDetails().getOrAwaitValue {}
        assertThat(productDetailslist?._id) .isEqualTo(productsItem?._id)
    }

    @Test
    @Throws(Exception::class)
    fun getProductDetailfailure() {
        productDetailsViewModel.productId.set("612f55c00a711a565943e7c0")
        apprealm?.executeTransaction { r: Realm ->
            val primaryKeyValue = ObjectId("613a2caf90e5f54ab3909c87")
            productsItem = r.createObject(Products::class.java, primaryKeyValue)
            productsItem?.name = "Mouse"
            productsItem?.detail = "Wireless Mouse"
            productsItem?.sku = 1234
            productsItem?.image = "https://dummyimage.com/200x200/000/ffffff&text=Mouse"
            productsItem?.price =20.0
            productsItem?.totalQuantity =45
            productsItem?._partition = "master"
        }
        val productDetailslist=productDetailsViewModel.getProductDetails().getOrAwaitValue {}
        assertThat(productDetailslist) .isEqualTo(null)
    }


    @Test
    @Throws(Exception::class)
    fun getProductDetailError() {
        productDetailsViewModel.productId.set("613a2caf90e5f54ab3909c87")
        apprealm?.executeTransaction { r: Realm ->
            productsItem = r.createObject(Products::class.java, ObjectId())
            productsItem?.name = "Mouse"
            productsItem?.detail = "Wireless Mouse"
            productsItem?.sku = 1234
            productsItem?.image = "https://dummyimage.com/200x200/000/ffffff&text=Mouse"
            productsItem?.price =20.0
            productsItem?.totalQuantity =45
            productsItem?._partition = "master"
        }
        val productDetailslist=productDetailsViewModel.getProductDetails().getOrAwaitValue {}
        assertThat(productDetailslist) .isEqualTo(null)
    }
}