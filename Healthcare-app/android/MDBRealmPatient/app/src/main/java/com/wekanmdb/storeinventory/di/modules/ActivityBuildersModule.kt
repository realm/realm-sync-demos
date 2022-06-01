package com.wekanmdb.storeinventory.di.modules

import com.wekanmdb.storeinventory.ui.availableSlots.AvailableSlotActivity
import com.wekanmdb.storeinventory.ui.consultation.ConsultationActivity
import com.wekanmdb.storeinventory.ui.consultation.ConsultationDetailActivity
import com.wekanmdb.storeinventory.ui.doctorInfo.DoctorInfoActivity
import com.wekanmdb.storeinventory.ui.hospital.HospitalActivity
import com.wekanmdb.storeinventory.ui.listOfHospitals.ListOfHospitalsActivity
import com.wekanmdb.storeinventory.ui.login.LoginActivity
import com.wekanmdb.storeinventory.ui.patientBasicInfo.PatientInfoActivity
import com.wekanmdb.storeinventory.ui.profile.ProfileActivity
import com.wekanmdb.storeinventory.ui.search.SearchActivity
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

    @ContributesAndroidInjector()
    abstract fun contributeSignupActivity(): SignupActivity

    @ContributesAndroidInjector()
    abstract fun contributePatientInfoActivity(): PatientInfoActivity

    @ContributesAndroidInjector()
    abstract fun contributeSearchActivity(): SearchActivity

    @ContributesAndroidInjector()
    abstract fun contributeListOfHospitalsActivity() : ListOfHospitalsActivity

    @ContributesAndroidInjector()
    abstract fun contributeHospitalActivity() : HospitalActivity

    @ContributesAndroidInjector()
    abstract fun contributeDoctorInfoActivity() : DoctorInfoActivity

    @ContributesAndroidInjector()
    abstract fun contributeAvailableSlotActivity() : AvailableSlotActivity

    @ContributesAndroidInjector()
    abstract fun contributeConsultationActivity() : ConsultationActivity

    @ContributesAndroidInjector()
    abstract fun contributeConsultationDetailActivity() : ConsultationDetailActivity

    @ContributesAndroidInjector()
    abstract fun contributeProfileActivity() : ProfileActivity

}
