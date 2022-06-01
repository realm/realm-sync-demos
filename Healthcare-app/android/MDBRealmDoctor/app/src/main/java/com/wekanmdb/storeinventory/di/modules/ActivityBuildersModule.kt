package com.wekanmdb.storeinventory.di.modules

import com.wekanmdb.storeinventory.ui.consultation.ConsultationActivity
import com.wekanmdb.storeinventory.ui.home.HomeActivity
import com.wekanmdb.storeinventory.ui.login.LoginActivity
import com.wekanmdb.storeinventory.ui.prescription.PrescriptionActivity
import com.wekanmdb.storeinventory.ui.profile.ProfileActivity
import com.wekanmdb.storeinventory.ui.search.SearchActivity
import com.wekanmdb.storeinventory.ui.signup.OrganizationUpdateActivity
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
    abstract fun contributeHomeActivity(): HomeActivity

    @ContributesAndroidInjector()
    abstract fun contributeSignupActivity(): SignupActivity

    @ContributesAndroidInjector()
    abstract fun contributeOrganizationUpdateActivity(): OrganizationUpdateActivity

    @ContributesAndroidInjector()
    abstract fun contributeSearchActivity(): SearchActivity

    @ContributesAndroidInjector()
    abstract fun contributeProfileActivity(): ProfileActivity

    @ContributesAndroidInjector()
    abstract fun contributeConsultationActivity(): ConsultationActivity

    @ContributesAndroidInjector()
    abstract fun contributePrescriptionActivity(): PrescriptionActivity


}
