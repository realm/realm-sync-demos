package com.wekanmdb.storeinventory.ui.createjobs

import android.content.ContentValues
import android.util.Log
import androidx.arch.core.executor.testing.InstantTaskExecutorRule
import com.google.common.truth.Truth.assertThat
import com.pachai.realm.ui.utils.getOrAwaitValue
import com.wekanmdb.storeinventory.BuildConfig
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.storerealm
import com.wekanmdb.storeinventory.app.taskApp
import com.wekanmdb.storeinventory.data.AppConstants
import com.wekanmdb.storeinventory.ui.createjobs.MockRealmData.createDemoAssignee
import com.wekanmdb.storeinventory.ui.createjobs.MockRealmData.createDemoInventory
import com.wekanmdb.storeinventory.ui.createjobs.MockRealmData.createDemoStore
import io.realm.Realm
import io.realm.RealmConfiguration
import io.realm.mongodb.App
import io.realm.mongodb.AppConfiguration
import org.bson.types.ObjectId
import org.junit.*
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit
import org.junit.Rule




class SearchActivityViewModelTest {
    lateinit var searchActivityViewModel: SearchActivityViewModel
    @get:Rule
    val instantTaskExecutorRule = InstantTaskExecutorRule()
    @Before
    fun setUp() {
        val config = RealmConfiguration.Builder().inMemory().name(AppConstants.PARTITIONVALUE).build()

        apprealm = Realm.getInstance(config)
        taskApp = App(
            AppConfiguration.Builder(BuildConfig.MONGODB_REALM_APP_ID)
                .defaultSyncErrorHandler { session, error ->
                    Log.e(ContentValues.TAG, "Sync error: ${error.errorMessage}")
                }
                .build())


        val configStore = RealmConfiguration.Builder().inMemory().name(AppConstants.INVENTORYPARTITIONVALUE).build()
        storerealm = Realm.getInstance(configStore)
        taskApp = App(
            AppConfiguration.Builder(BuildConfig.MONGODB_REALM_APP_ID)
                .defaultSyncErrorHandler { session, error ->
                    Log.e(ContentValues.TAG, "Sync error: ${error.errorMessage}")
                }
                .build())
        searchActivityViewModel = SearchActivityViewModel()

    }

    @Test
    fun search_destnination_store_return_True(){
         createDemoStore()
        val storeList = searchActivityViewModel.getStore(ObjectId()).getOrAwaitValue()
        assertThat(storeList?.size!!>0) .isEqualTo(true)

    }
    @Test
    fun getting_inventory_products_return_True(){
        val storeId = ObjectId()
        createDemoInventory(storeId)
        val inventoryProducst = storeId?.let { searchActivityViewModel.getProducts(it).getOrAwaitValue() }
        if (inventoryProducst != null) {
            assertThat(inventoryProducst.size>0) .isEqualTo(true)
        }

    }

    @Test
    fun getting_Delivery_Assignee_return_True(){
        createDemoAssignee()
        val deliveryUsers = searchActivityViewModel.getAssignees().getOrAwaitValue()
        assertThat(deliveryUsers?.size!!>0) .isEqualTo(true)
    }





    @After
    fun tearDown() {
        apprealm?.close()
        storerealm?.close()
    }

}