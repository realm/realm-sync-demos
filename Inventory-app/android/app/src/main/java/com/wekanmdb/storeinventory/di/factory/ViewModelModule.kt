package com.wekanmdb.storeinventory.di.modules

import androidx.lifecycle.ViewModel
import com.wekanmdb.storeinventory.ui.createjobs.CreateJobViewModel
import com.wekanmdb.storeinventory.ui.createjobs.SearchActivityViewModel
import com.wekanmdb.storeinventory.ui.editjobs.JobDetailsViewModel
import com.wekanmdb.storeinventory.ui.deliveryjob.DeliveryJobViewModel
import com.wekanmdb.storeinventory.ui.home.HomeViewModel
import com.wekanmdb.storeinventory.ui.inventory.InventoryViewModel
import com.wekanmdb.storeinventory.ui.jobs.JobsViewModel
import com.wekanmdb.storeinventory.ui.login.LoginViewModel
import com.wekanmdb.storeinventory.ui.productdetails.ProductDetailsViewModel
import com.wekanmdb.storeinventory.ui.profile.ProfileViewModel
import dagger.Binds
import dagger.MapKey
import dagger.Module
import dagger.multibindings.IntoMap
import kotlin.reflect.KClass

@Module
abstract class ViewModelModule {

    @Binds
    @IntoMap
    @ViewModelKey(LoginViewModel::class)
    abstract fun bindLoginViewModel(loginViewModel: LoginViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(JobsViewModel::class)
    abstract fun bindJobsViewModel(jobsViewModel: JobsViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(InventoryViewModel::class)
    abstract fun bindInventoryViewModel(inventoryViewModel: InventoryViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(HomeViewModel::class)
    abstract fun bindHomeViewModel(homeViewModel: HomeViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(ProductDetailsViewModel::class)
    abstract fun bindProductDetailsViewModel(productDetailsViewModel: ProductDetailsViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(DeliveryJobViewModel::class)
    abstract fun bindDeliveryJobViewModel(deliveryJobViewModel: DeliveryJobViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(CreateJobViewModel::class)
    abstract fun bindCreateJobViewModel(createJobViewModel: CreateJobViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(SearchActivityViewModel::class)
    abstract fun bindSearchActivityViewModel(searchActivityViewModel: SearchActivityViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(JobDetailsViewModel::class)
    abstract fun bindJobDetailsViewModel(jobDetailsViewModel: JobDetailsViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(ProfileViewModel::class)
    abstract fun bindProfileViewModel(profileViewModel: ProfileViewModel): ViewModel


}

@MustBeDocumented
@Target(
        AnnotationTarget.FUNCTION,
        AnnotationTarget.PROPERTY_GETTER,
        AnnotationTarget.PROPERTY_SETTER
)
@Retention(AnnotationRetention.RUNTIME)
@MapKey
annotation class ViewModelKey(val value: KClass<out ViewModel>)
