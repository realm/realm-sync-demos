package com.wekanmdb.storeinventory.ui.inventory

import androidx.arch.core.executor.testing.InstantTaskExecutorRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.filters.LargeTest
import com.google.common.truth.Truth.assertThat
import com.pachai.realm.ui.utils.getOrAwaitValue
import com.wekanmdb.storeinventory.app.AppApplication
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.storerealm
import com.wekanmdb.storeinventory.data.AppPreference
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.model.storeInventory.StoreInventory
import io.realm.Realm
import io.realm.RealmConfiguration
import org.bson.types.ObjectId
import org.junit.After
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith


@RunWith(AndroidJUnit4::class)
@LargeTest
class InventoryViewModelTest {

    val inventoryViewModel = InventoryViewModel()
    var appPreference: AppPreference? = null
    var storeItem: Stores? = null
    var storeInventoryItem: StoreInventory? = null

    @Before
    @Throws(Exception::class)
    fun setUp() {
        appPreference = AppApplication.getInstance()?.getAppPreference()
        val appconfig = RealmConfiguration.Builder().name("master").build()
        val storeconfig = RealmConfiguration.Builder().name("store=613a2ccaa3a6447e678816df").build()
        apprealm = Realm.getInstance(appconfig)
        storerealm = Realm.getInstance(storeconfig)
    }

    @After
    @Throws(Exception::class)
    fun tearDown() {
        apprealm?.executeTransaction {
            storeItem?.deleteFromRealm()
        }
        storerealm?.executeTransaction {
            storeInventoryItem?.deleteFromRealm()
        }
        apprealm?.close()
        storerealm?.close()
    }

    @get:Rule
    val instantTaskExecutorRule = InstantTaskExecutorRule()

    @Test
    @Throws(Exception::class)
    fun getStore() {
        inventoryViewModel.storeId.set("613a2ccaa3a6447e678816df")
        apprealm?.executeTransaction { r: Realm ->
            val primaryKeyValue = ObjectId("613a2ccaa3a6447e678816df")
            storeItem = r.createObject(Stores::class.java, primaryKeyValue)
            storeItem?.name = "store 1"
            storeItem?.address = "store 1 address"
            storeItem?._partition = "master"
        }
        inventoryViewModel.getStore()
        val store = inventoryViewModel.storesresponseBody.getOrAwaitValue {  }
        assertThat(store?._id).isEqualTo(storeItem?._id)
    }

    @Test
    @Throws(Exception::class)
    fun getStoreFailure() {
        inventoryViewModel.storeId.set("61409900ca9ac7acaa179859")
        apprealm?.executeTransaction { r: Realm ->
            val primaryKeyValue = ObjectId("613a2ccaa3a6447e678816df")
            storeItem = r.createObject(Stores::class.java, primaryKeyValue)
            storeItem?.name = "store 1"
            storeItem?.address = "store 1 address"
            storeItem?._partition = "master"
        }
        inventoryViewModel.getStore()
        val store = inventoryViewModel.storesresponseBody.getOrAwaitValue {  }
        assertThat(store).isEqualTo(null)
    }


    @Test
    @Throws(Exception::class)
    fun getStoreError() {
        inventoryViewModel.storeId.set("61409900ca9ac7acaa179859")
        apprealm?.executeTransaction { r: Realm ->
            storeItem = r.createObject(Stores::class.java, ObjectId())
            storeItem?.name = "store 1"
            storeItem?.address = "store 1 address"
            storeItem?._partition = "master"
        }
        inventoryViewModel.getStore()
        val store = inventoryViewModel.storesresponseBody.getOrAwaitValue {  }
        assertThat(store).isEqualTo(null)
    }

    @Test
    @Throws(Exception::class)
    fun getInventoryList() {
        inventoryViewModel.storeId.set("613a2ccaa3a6447e678816df")
        storerealm?.executeTransaction { r: Realm ->
            val storeprimaryKeyValue = ObjectId("61409900ca9ac7acaa179859")
            val storeId = ObjectId("613a2ccaa3a6447e678816df")
            val productId = ObjectId("613a514d90e5f54ab3938a82")
            storeInventoryItem = r.createObject(StoreInventory::class.java, storeprimaryKeyValue)
            storeInventoryItem?.storeId =storeId
            storeInventoryItem?.productId =productId
            storeInventoryItem?.quantity = 3
            storeInventoryItem?.productName ="AmazonBasics 80cm (32 inch) HD Ready Smart LED Fire TV AB32E10SS"
            storeInventoryItem?.image ="https://dummyimage.com/200x200/000/ffffff&text=AmazonBasics 80cm (32 inch) HD Ready Smart LED Fire TV AB32E10SS"
            storeInventoryItem?._partition ="store=613a2ccaa3a6447e678816df"
        }
        inventoryViewModel.getInventoryList()
        val inventoryList = inventoryViewModel.inventoryresponseBody.getOrAwaitValue {  }
        assertThat(inventoryList?.get(0)?._id).isEqualTo(storeInventoryItem?._id)
    }


    @Test
    @Throws(Exception::class)
    fun getInventoryListFailure() {
        inventoryViewModel.storeId.set("613a514d90e5f54ab3938a82")
        storerealm?.executeTransaction { r: Realm ->
            val storeprimaryKeyValue = ObjectId("61409900ca9ac7acaa179859")
            val storeId = ObjectId("613a2ccaa3a6447e678816df")
            val productId = ObjectId("613a514d90e5f54ab3938a82")
            storeInventoryItem = r.createObject(StoreInventory::class.java, storeprimaryKeyValue)
            storeInventoryItem?.storeId =storeId
            storeInventoryItem?.productId =productId
            storeInventoryItem?.quantity = 3
            storeInventoryItem?.productName ="AmazonBasics 80cm (32 inch) HD Ready Smart LED Fire TV AB32E10SS"
            storeInventoryItem?.image ="https://dummyimage.com/200x200/000/ffffff&text=AmazonBasics 80cm (32 inch) HD Ready Smart LED Fire TV AB32E10SS"
            storeInventoryItem?._partition ="store=613a2ccaa3a6447e678816df"
        }
        inventoryViewModel.getInventoryList()
        val inventoryList = inventoryViewModel.inventoryresponseBody.getOrAwaitValue {  }
        assertThat(inventoryList).isEqualTo(null)
    }


    @Test
    @Throws(Exception::class)
    fun getInventoryListError() {
        inventoryViewModel.storeId.set("613a514d90e5f54ab3938a82")
        storerealm?.executeTransaction { r: Realm ->
            val storeId = ObjectId("613a2ccaa3a6447e678816df")
            val productId = ObjectId("613a514d90e5f54ab3938a82")
            storeInventoryItem = r.createObject(StoreInventory::class.java, ObjectId())
            storeInventoryItem?.storeId =storeId
            storeInventoryItem?.productId =productId
            storeInventoryItem?.quantity = 3
            storeInventoryItem?.productName ="AmazonBasics 80cm (32 inch) HD Ready Smart LED Fire TV AB32E10SS"
            storeInventoryItem?.image ="https://dummyimage.com/200x200/000/ffffff&text=AmazonBasics 80cm (32 inch) HD Ready Smart LED Fire TV AB32E10SS"
            storeInventoryItem?._partition ="store=613a2ccaa3a6447e678816df"
        }
        inventoryViewModel.getInventoryList()
        val inventoryList = inventoryViewModel.inventoryresponseBody.getOrAwaitValue {  }
        assertThat(inventoryList).isEqualTo(null)
    }

    @Test
    @Throws(Exception::class)
    fun getInventorySearch() {
        inventoryViewModel.searchproductName.set("Am")
        storerealm?.executeTransaction { r: Realm ->
            val storeprimaryKeyValue = ObjectId("61409900ca9ac7acaa179859")
            val storeId = ObjectId("613a2ccaa3a6447e678816df")
            val productId = ObjectId("613a514d90e5f54ab3938a82")
            storeInventoryItem = r.createObject(StoreInventory::class.java, storeprimaryKeyValue)
            storeInventoryItem?.storeId =storeId
            storeInventoryItem?.productId =productId
            storeInventoryItem?.quantity = 3
            storeInventoryItem?.productName ="AmazonBasics 80cm (32 inch) HD Ready Smart LED Fire TV AB32E10SS"
            storeInventoryItem?.image ="https://dummyimage.com/200x200/000/ffffff&text=AmazonBasics 80cm (32 inch) HD Ready Smart LED Fire TV AB32E10SS"
            storeInventoryItem?._partition ="store=613a2ccaa3a6447e678816df"
        }
        val inventoryList = inventoryViewModel.getFilterSearch().getOrAwaitValue {  }
        assertThat(inventoryList?.get(0)?._id).isEqualTo(storeInventoryItem?._id)
    }

    @Test
    @Throws(Exception::class)
    fun getInventorySearchError() {
        inventoryViewModel.searchproductName.set("Am")
        storerealm?.executeTransaction { r: Realm ->
            val storeprimaryKeyValue = ObjectId("61409900ca9ac7acaa179859")
            val storeId = ObjectId("613a2ccaa3a6447e678816df")
            val productId = ObjectId("613a514d90e5f54ab3938a82")
            storeInventoryItem = r.createObject(StoreInventory::class.java, storeprimaryKeyValue)
            storeInventoryItem?.storeId =storeId
            storeInventoryItem?.productId =productId
            storeInventoryItem?.quantity = 3
            storeInventoryItem?.productName =""
            storeInventoryItem?.image ="https://dummyimage.com/200x200/000/ffffff&text=AmazonBasics 80cm (32 inch) HD Ready Smart LED Fire TV AB32E10SS"
            storeInventoryItem?._partition ="store=613a2ccaa3a6447e678816df"
        }
        val inventoryList = inventoryViewModel.getFilterSearch().getOrAwaitValue {  }
        assertThat(inventoryList?.size).isEqualTo(0)
    }


}