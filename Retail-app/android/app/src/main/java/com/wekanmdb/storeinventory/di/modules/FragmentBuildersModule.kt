package com.wekanmdb.storeinventory.di.modules

import com.wekanmdb.storeinventory.ui.inventory.InventoryFragment
import com.wekanmdb.storeinventory.ui.jobs.JobsFragment
import com.wekanmdb.storeinventory.ui.orders.OrdersFragment
import com.wekanmdb.storeinventory.ui.productdetails.ProductDetailsFragment
import com.wekanmdb.storeinventory.ui.profile.ProfileFragment
import dagger.Module
import dagger.android.ContributesAndroidInjector

@Module
abstract class FragmentBuildersModule {

    @ContributesAndroidInjector
    abstract fun contributeInventoryFragment(): InventoryFragment

    @ContributesAndroidInjector
    abstract fun contributeJobsFragment(): JobsFragment

    @ContributesAndroidInjector
    abstract fun contributeProfileFragment(): ProfileFragment

    @ContributesAndroidInjector
    abstract fun contributeProductDetailsFragment(): ProductDetailsFragment

    @ContributesAndroidInjector
    abstract fun contributeOrdersFragment(): OrdersFragment
}
