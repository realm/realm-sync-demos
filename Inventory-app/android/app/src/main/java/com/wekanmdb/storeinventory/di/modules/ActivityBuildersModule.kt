package com.wekanmdb.storeinventory.di.modules

import com.wekanmdb.storeinventory.ui.createjobs.CreateJobActivity
import com.wekanmdb.storeinventory.ui.createjobs.SearchActivity
import com.wekanmdb.storeinventory.ui.deliveryjob.DeliveryJobActivity
import com.wekanmdb.storeinventory.ui.editjobs.JobDetailsActivity
import com.wekanmdb.storeinventory.ui.home.HomeActivity
import com.wekanmdb.storeinventory.ui.login.LoginActivity
import com.wekanmdb.storeinventory.ui.splash.SplashActivity
import dagger.Module
import dagger.android.ContributesAndroidInjector

@Module
abstract class ActivityBuildersModule {

    @ContributesAndroidInjector()
    abstract fun contributeSplashActivity(): SplashActivity

    @ContributesAndroidInjector()
    abstract fun contributeLoginActivity(): LoginActivity

    @ContributesAndroidInjector(modules = [FragmentBuildersModule::class])
    abstract fun contributeHomeActivity(): HomeActivity

    @ContributesAndroidInjector()
    abstract fun contributeDeliveryJobActivity(): DeliveryJobActivity

    @ContributesAndroidInjector()
    abstract fun contributeCreateJobActivity(): CreateJobActivity

    @ContributesAndroidInjector()
    abstract fun contributeSearchActivity(): SearchActivity

    @ContributesAndroidInjector()
    abstract fun contributeJobDetailsActivity(): JobDetailsActivity


}
