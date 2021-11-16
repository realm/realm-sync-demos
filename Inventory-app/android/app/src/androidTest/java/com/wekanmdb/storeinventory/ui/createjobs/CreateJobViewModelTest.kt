package com.wekanmdb.storeinventory.ui.createjobs

import android.content.ContentValues
import android.util.Log
import androidx.arch.core.executor.testing.InstantTaskExecutorRule
import com.google.common.truth.Truth
import com.pachai.realm.ui.utils.getOrAwaitValue
import com.wekanmdb.storeinventory.BuildConfig
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.taskApp
import com.wekanmdb.storeinventory.data.AppConstants
import com.wekanmdb.storeinventory.model.job.ProductQuantity
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.model.user.Users
import io.realm.Realm
import io.realm.RealmConfiguration
import io.realm.RealmList
import io.realm.mongodb.App
import io.realm.mongodb.AppConfiguration
import org.junit.After
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import java.util.*

class CreateJobViewModelTest {
    lateinit var createJobViewModel: CreateJobViewModel
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
        createJobViewModel = CreateJobViewModel()
    }

    @Test
    fun create_jobs_resturn_true(){
       val isJobCreated =  createJobViewModel.createJob(Users(),
           Users(), Stores(),Stores(), Date(), RealmList<ProductQuantity>()).getOrAwaitValue()
        Truth.assertThat(isJobCreated).isEqualTo(true)

    }

    @After
    fun tearDown() {
        apprealm?.close()
    }
}