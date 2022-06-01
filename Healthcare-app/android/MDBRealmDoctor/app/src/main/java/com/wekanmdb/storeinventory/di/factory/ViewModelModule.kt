package com.wekanmdb.storeinventory.di.factory

import androidx.lifecycle.ViewModel
import com.wekanmdb.storeinventory.ui.consultation.ConsultationViewModel
import com.wekanmdb.storeinventory.ui.home.HomeViewModel
import com.wekanmdb.storeinventory.ui.login.LoginViewModel
import com.wekanmdb.storeinventory.ui.prescription.PrescriptionViewModel
import com.wekanmdb.storeinventory.ui.profile.ProfileViewModel
import com.wekanmdb.storeinventory.ui.search.SearchActivityViewModel
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
    @ViewModelKey(HomeViewModel::class)
    abstract fun bindHomeViewModel(homeViewModel: HomeViewModel): ViewModel



    @Binds
    @IntoMap
    @ViewModelKey(ProfileViewModel::class)
    abstract fun bindProfileViewModel(profileViewModel: ProfileViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(SearchActivityViewModel::class)
    abstract fun bindSearchActivityViewModel(searchActivityViewModel: SearchActivityViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(ConsultationViewModel::class)
    abstract fun bindConsultationViewModel(consultationViewModel: ConsultationViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(PrescriptionViewModel::class)
    abstract fun bindPrescriptionViewModel(prescriptionViewModel: PrescriptionViewModel): ViewModel
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
