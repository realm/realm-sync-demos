package com.wekanmdb.storeinventory.app

import android.content.ContentValues
import android.util.Log
import com.bugfender.sdk.Bugfender
import com.wekanmdb.storeinventory.BuildConfig
import com.wekanmdb.storeinventory.data.AppConstants
import com.wekanmdb.storeinventory.data.AppPreference
import com.wekanmdb.storeinventory.di.component.DaggerAppComponent
import com.wekanmdb.storeinventory.utils.EncrytionUtils.getExistingKey
import com.wekanmdb.storeinventory.utils.RealmUtils.getRealmconfig
import dagger.android.AndroidInjector
import dagger.android.DaggerApplication
import io.realm.Realm
import io.realm.log.LogLevel
import io.realm.log.RealmLog
import io.realm.mongodb.App
import io.realm.mongodb.AppConfiguration
import io.realm.mongodb.User
import org.bson.types.ObjectId

lateinit var taskApp: App
 var apprealm: Realm?=null
 var storerealm: Realm?=null
var key: ByteArray? = null
var user: User? = null
class AppApplication : DaggerApplication() {
    private var appPreference: AppPreference? = null

    private val applicationInjector = DaggerAppComponent.builder().application(this).build()
    override fun applicationInjector(): AndroidInjector<out DaggerApplication> = applicationInjector

    companion object {
        var appController: AppApplication? = null

        @Synchronized
        fun getInstance(): AppApplication? {
            return appController
        }
    }

    override fun onCreate() {
        super.onCreate()
        //Initialize crash analytics
        Bugfender.init(this, "pkzBwEADsoIM3huVlRztbvFwfZlSAzts", BuildConfig.DEBUG)
        Bugfender.enableCrashReporting()
        // Initialize Realm (just once per application)
        Realm.init(this)
        appController = this
        appPreference = AppPreference(this)

        // Get a Realm instance for this thread
        taskApp = App(
            AppConfiguration.Builder(BuildConfig.MONGODB_REALM_APP_ID)
                .defaultClientResetHandler { session, error ->
                    Log.e(ContentValues.TAG, "Sync error: ${error.errorMessage}")
                }
                .build())

            key = getExistingKey(appPreference!!)
            user = taskApp.currentUser()
        /**
         * Creating instance for realm for both partitions(Master & Store)
         */
            if (key != null && user!=null) {
                Realm.getInstanceAsync(getRealmconfig(AppConstants.PARTITIONVALUE ), object : Realm.Callback() {
                    override fun onSuccess(realm: Realm) {
                        apprealm=realm
                    }
                })
                val stores=user?.customData?.get("stores")
                if (stores!=null){
                    stores as ArrayList<ObjectId>
                    Realm.getInstanceAsync(getRealmconfig(AppConstants.INVENTORYPARTITIONVALUE + stores.first().toString()), object : Realm.Callback() {
                        override fun onSuccess(realm: Realm) {
                            storerealm=realm
                        }
                    })
                }
            }
            if (BuildConfig.DEBUG) {
                RealmLog.setLevel(LogLevel.ALL)
            }
    }
    fun getAppPreference(): AppPreference {
        return appPreference!!
    }

    override fun onTerminate() {
        super.onTerminate()
        apprealm?.close()
        storerealm?.close()
    }

}