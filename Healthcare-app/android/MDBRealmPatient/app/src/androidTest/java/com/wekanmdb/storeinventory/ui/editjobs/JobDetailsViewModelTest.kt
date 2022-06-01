package com.wekanmdb.storeinventory.ui.editjobs

import android.content.ContentValues
import android.util.Log
import androidx.arch.core.executor.testing.InstantTaskExecutorRule
import com.google.common.truth.Truth
import com.pachai.realm.ui.utils.getOrAwaitValue
import com.wekanmdb.storeinventory.BuildConfig
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.taskApp
import com.wekanmdb.storeinventory.data.AppConstants
import com.wekanmdb.storeinventory.model.user.Users
import com.wekanmdb.storeinventory.ui.createjobs.MockRealmData.createDummyJob
import com.wekanmdb.storeinventory.utils.Constants.Companion.JOB_PROGRESS
import io.realm.Realm
import io.realm.RealmConfiguration
import io.realm.mongodb.App
import io.realm.mongodb.AppConfiguration
import org.junit.Assert.*

import org.junit.After
import org.junit.Before
import org.junit.Rule
import org.junit.Test

class JobDetailsViewModelTest {
    lateinit var jobDetailsViewModel: JobDetailsViewModel
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
        jobDetailsViewModel = JobDetailsViewModel()
    }

    @Test
    fun update_job_assignee_return_True(){
        val job = createDummyJob().getOrAwaitValue()
        val assigneeUpdated = jobDetailsViewModel.upDateJobAssignee(job, Users()).getOrAwaitValue()
        Truth.assertThat(assigneeUpdated).isEqualTo(true)
    }
    @Test
    fun update_JOb_Status_return_True(){
        val job = createDummyJob().getOrAwaitValue()
        val jobStatusUpdated = jobDetailsViewModel.updateJobStatus(
            job,
            JOB_PROGRESS,
            false,""
        ).getOrAwaitValue()
        Truth.assertThat(jobStatusUpdated).isEqualTo(true)
    }

    @After
    fun tearDown() {
        apprealm?.close()
    }
}