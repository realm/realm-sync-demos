package com.wekanmdb.storeinventory.ui.deliveryjob

import androidx.arch.core.executor.testing.InstantTaskExecutorRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.filters.LargeTest
import com.wekanmdb.storeinventory.app.AppApplication
import com.wekanmdb.storeinventory.app.apprealm
import com.google.common.truth.Truth.assertThat
import com.wekanmdb.storeinventory.data.AppPreference
import com.wekanmdb.storeinventory.model.job.Jobs
import com.wekanmdb.storeinventory.model.job.ProductQuantity
import com.wekanmdb.storeinventory.model.product.Products
import com.wekanmdb.storeinventory.model.store.Stores
import io.realm.Realm
import io.realm.RealmConfiguration
import io.realm.RealmList
import org.bson.types.ObjectId
import org.junit.After
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import java.util.*

@RunWith(AndroidJUnit4::class)
@LargeTest
class DeliveryJobViewModelTest{
    val deliveryJobViewModel = DeliveryJobViewModel()
    var appPreference: AppPreference?=null
    var storeItem: Stores? = null
    var usersItem: Users? = null
    var jobs: Jobs? = null
    var productsItem: Products? = null
    var productQuantity: RealmList<ProductQuantity>?=null

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
            storeItem?.deleteFromRealm()
            jobs?.deleteFromRealm()
            usersItem?.deleteFromRealm()
            productsItem?.deleteFromRealm()
            productQuantity?.get(0)?.deleteFromRealm()
        }

        apprealm?.close()
    }

    @get:Rule
    val instantTaskExecutorRule = InstantTaskExecutorRule()

    @Test
    @Throws(Exception::class)
    fun getDeliveryJobList() {
        deliveryJobViewModel.userId.set("613a2d496f73d28f87be859d")
        val primaryKeyValue = ObjectId("613a2d496f73d28f87be859d")
        val userPrimaryKeyValue = ObjectId("613a2d496f73d28f87be859d")
        val storePrimaryKeyValue = ObjectId("613a2ccaa3a6447e678816df")
        val productPrimaryKeyValue = ObjectId("613a2caf90e5f54ab3909c87")
        val productQuantityprimaryKeyValue = ObjectId("614088f231cdc7039fd0a90e")
        val calendar = Calendar.getInstance()
        calendar.add(Calendar.DAY_OF_YEAR, 1)
        val tomorrow = calendar.time
        apprealm?.executeTransaction { r: Realm ->
            usersItem = r.createObject(Users::class.java, userPrimaryKeyValue)
            usersItem?.email = "lsupervisor@mailinator.com"
            usersItem?.firstName = "Loganathan"
            usersItem?.lastName = "Supervisor"
            usersItem?.userRole = "store-user"
            usersItem?.stores = RealmList<Stores>(storeItem)
            usersItem?.customDataId = "612f55c00a711a565943e7c0"
            usersItem?._partition = "master"

            storeItem = r.createObject(Stores::class.java, storePrimaryKeyValue)
            storeItem?.name = "store 1"
            storeItem?.address = "store 1 address"
            storeItem?._partition = "master"

            productsItem = r.createObject(Products::class.java, productPrimaryKeyValue)
            productsItem?.name = "Mouse"
            productsItem?.detail = "Wireless Mouse"
            productsItem?.sku = 1234
            productsItem?.image = "https://dummyimage.com/200x200/000/ffffff&text=Mouse"
            productsItem?.price =20.0
            productsItem?.totalQuantity =45
            productsItem?._partition = "master"

            productQuantity?.get(0)?._id=productQuantityprimaryKeyValue
            productQuantity?.get(0)?.product=productsItem
            productQuantity?.get(0)?.quantity=1
            productQuantity?.get(0)?._partition="master"


            jobs = r.createObject(Jobs::class.java, primaryKeyValue)
            jobs?.createdBy = usersItem
            jobs?.assignedTo = usersItem
            jobs?.sourceStore = storeItem
            jobs?.destinationStore = storeItem
            jobs?.pickupDatetime = tomorrow
            jobs?.status = "done"
            jobs?.products = productQuantity
            jobs?._partition = "master"

        }
        deliveryJobViewModel.getDeliveryJob()
        val jobItem=deliveryJobViewModel.jobresponseBody.getOrAwaitValue {}
        assertThat(jobItem?.get(0)?._id).isEqualTo(jobs?._id)
    }

    @Test
    @Throws(Exception::class)
    fun getDeliveryJobListError() {
        deliveryJobViewModel.userId.set("613a2caf90e5f54ab3909c87")
        val primaryKeyValue = ObjectId("613a2d496f73d28f87be859d")
        val userPrimaryKeyValue = ObjectId("613a2d496f73d28f87be859d")
        val storePrimaryKeyValue = ObjectId("613a2ccaa3a6447e678816df")
        val productPrimaryKeyValue = ObjectId("613a2caf90e5f54ab3909c87")
        val productQuantityprimaryKeyValue = ObjectId("614088f231cdc7039fd0a90e")

        apprealm?.executeTransaction { r: Realm ->
            usersItem = r.createObject(Users::class.java, userPrimaryKeyValue)
            usersItem?.email = "lsupervisor@mailinator.com"
            usersItem?.firstName = "Loganathan"
            usersItem?.lastName = "Supervisor"
            usersItem?.userRole = "store-user"
            usersItem?.stores = storeItem
            usersItem?.customDataId = "612f55c00a711a565943e7c0"
            usersItem?._partition = "master"

            storeItem = r.createObject(Stores::class.java, storePrimaryKeyValue)
            storeItem?.name = "store 1"
            storeItem?.address = "store 1 address"
            storeItem?._partition = "master"

            productsItem = r.createObject(Products::class.java, productPrimaryKeyValue)
            productsItem?.name = "Mouse"
            productsItem?.detail = "Wireless Mouse"
            productsItem?.sku = 1234
            productsItem?.image = "https://dummyimage.com/200x200/000/ffffff&text=Mouse"
            productsItem?.price =20.0
            productsItem?.totalQuantity =45
            productsItem?._partition = "master"

            productQuantity?.get(0)?._id=productQuantityprimaryKeyValue
            productQuantity?.get(0)?.product=productsItem
            productQuantity?.get(0)?.quantity=1
            productQuantity?.get(0)?._partition="master"


            jobs = r.createObject(Jobs::class.java, primaryKeyValue)
            jobs?.createdBy = usersItem
            jobs?.assignedTo = usersItem
            jobs?.sourceStore = storeItem
            jobs?.destinationStore = storeItem
            jobs?.pickupDatetime = Date()
            jobs?.status = "done"
            jobs?.products = productQuantity
            jobs?._partition = "master"

        }
        deliveryJobViewModel.getDeliveryJob()
        val jobItem=deliveryJobViewModel.jobresponseBody.getOrAwaitValue {}
        assertThat(jobItem).isEqualTo(null)
    }


    @Test
    @Throws(Exception::class)
    fun getDeliveryJobListFailure() {
        deliveryJobViewModel.userId.set("613a2caf90e5f54ab3909c87")
        val primaryKeyValue = ObjectId("613a2d496f73d28f87be859d")
        val userPrimaryKeyValue = ObjectId("613a2d496f73d28f87be859d")
        val storePrimaryKeyValue = ObjectId("613a2ccaa3a6447e678816df")
        val productPrimaryKeyValue = ObjectId("613a2caf90e5f54ab3909c87")
        val productQuantityprimaryKeyValue = ObjectId("614088f231cdc7039fd0a90e")

        apprealm?.executeTransaction { r: Realm ->
            usersItem = r.createObject(Users::class.java, ObjectId())
            usersItem?.email = "lsupervisor@mailinator.com"
            usersItem?.firstName = "Loganathan"
            usersItem?.lastName = "Supervisor"
            usersItem?.userRole = "store-user"
            usersItem?.stores = storeItem
            usersItem?.customDataId = "612f55c00a711a565943e7c0"
            usersItem?._partition = "master"

            storeItem = r.createObject(Stores::class.java, storePrimaryKeyValue)
            storeItem?.name = "store 1"
            storeItem?.address = "store 1 address"
            storeItem?._partition = "master"

            productsItem = r.createObject(Products::class.java, productPrimaryKeyValue)
            productsItem?.name = "Mouse"
            productsItem?.detail = "Wireless Mouse"
            productsItem?.sku = 1234
            productsItem?.image = "https://dummyimage.com/200x200/000/ffffff&text=Mouse"
            productsItem?.price =20.0
            productsItem?.totalQuantity =45
            productsItem?._partition = "master"

            productQuantity?.get(0)?._id=productQuantityprimaryKeyValue
            productQuantity?.get(0)?.product=productsItem
            productQuantity?.get(0)?.quantity=1
            productQuantity?.get(0)?._partition="master"


            jobs = r.createObject(Jobs::class.java, primaryKeyValue)
            jobs?.createdBy = usersItem
            jobs?.assignedTo = usersItem
            jobs?.sourceStore = storeItem
            jobs?.destinationStore = storeItem
            jobs?.pickupDatetime = Date()
            jobs?.status = "done"
            jobs?.products = productQuantity
            jobs?._partition = "master"

        }
        deliveryJobViewModel.getDeliveryJob()
        val jobItem=deliveryJobViewModel.jobresponseBody.getOrAwaitValue {}
        assertThat(jobItem).isEqualTo(null)
    }
}