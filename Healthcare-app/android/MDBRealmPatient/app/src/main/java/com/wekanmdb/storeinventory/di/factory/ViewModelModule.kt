package com.wekanmdb.storeinventory.di.factory

import androidx.lifecycle.ViewModel
import com.wekanmdb.storeinventory.ui.availableSlots.AvailableSlotViewModel
import com.wekanmdb.storeinventory.ui.consultation.ConsultationViewModel
import com.wekanmdb.storeinventory.ui.doctorInfo.DoctorInfoViewModel
import com.wekanmdb.storeinventory.ui.hospital.HospitalViewModel
import com.wekanmdb.storeinventory.ui.listOfHospitals.ListOfHospitalViewModel
import com.wekanmdb.storeinventory.ui.login.LoginViewModel
import com.wekanmdb.storeinventory.ui.patientBasicInfo.PatientInfoViewModel
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
    @ViewModelKey(ProfileViewModel::class)
    abstract fun bindProfileViewModel(profileViewModel: ProfileViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(PatientInfoViewModel::class)
    abstract fun bindPatientInfoViewModel(patientInfoViewModel: PatientInfoViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(ListOfHospitalViewModel::class)
    abstract fun bindListOfHospitalViewModel(listOfHospitalViewModel: ListOfHospitalViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(HospitalViewModel::class)
    abstract fun bindhospitalViewModel(hospitalViewModel: HospitalViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(DoctorInfoViewModel::class)
    abstract fun bindDoctorViewModel(doctorInfoViewModel: DoctorInfoViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(AvailableSlotViewModel::class)
    abstract fun bindAvailableSlotViewModel(availableSlotViewModel: AvailableSlotViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(ConsultationViewModel::class)
    abstract fun bindConsultationViewModel(consultationViewModel: ConsultationViewModel): ViewModel
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
