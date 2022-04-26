package com.wekanmdb.storeinventory.di.modules

import com.wekanmdb.storeinventory.ui.createOrders.CreateOrderActivity
import com.wekanmdb.storeinventory.ui.createOrders.CreateOrderSummaryActivity
import com.wekanmdb.storeinventory.ui.createOrders.OrderDetailsActivity
import com.wekanmdb.storeinventory.ui.createjobs.CreateJobActivity
import com.wekanmdb.storeinventory.ui.createjobs.CreateOrderJobActivity
import com.wekanmdb.storeinventory.ui.createjobs.SearchActivity
import com.wekanmdb.storeinventory.ui.deliveryjob.DeliveryJobActivity
import com.wekanmdb.storeinventory.ui.editjobs.DeliveryJobDetailsActivity
import com.wekanmdb.storeinventory.ui.editjobs.JobDetailsActivity
import com.wekanmdb.storeinventory.ui.home.HomeActivity
import com.wekanmdb.storeinventory.ui.login.LoginActivity
import com.wekanmdb.storeinventory.ui.signup.SignupActivity
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

    @ContributesAndroidInjector()
    abstract fun contributeSignupActivity(): SignupActivity

    @ContributesAndroidInjector()
    abstract fun contributeCreateOrderActivity(): CreateOrderActivity

    @ContributesAndroidInjector()
    abstract fun contributeCreateOrderSummaryActivity(): CreateOrderSummaryActivity

    @ContributesAndroidInjector()
    abstract fun contributeOrderDetailsActivity(): OrderDetailsActivity

    @ContributesAndroidInjector()
    abstract fun contributeCreateOrderJobActivity(): CreateOrderJobActivity

    @ContributesAndroidInjector()
    abstract fun contributeDeliveryJobDetailsActivity(): DeliveryJobDetailsActivity

}
