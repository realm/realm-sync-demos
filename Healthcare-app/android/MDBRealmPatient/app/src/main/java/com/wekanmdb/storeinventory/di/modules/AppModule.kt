package com.wekanmdb.storeinventory.di.modules

import android.content.Context
import com.wekanmdb.storeinventory.app.AppApplication
import com.wekanmdb.storeinventory.data.AppPreference
import com.wekanmdb.storeinventory.di.factory.ViewModelModule
import dagger.Module
import dagger.Provides
import javax.inject.Singleton

@Module(includes = [ViewModelModule::class])
class AppModule {
    @Provides
    @Singleton
    internal fun providesContext(): Context {
        return AppApplication.getInstance()!!.applicationContext
    }

    @Provides
    @Singleton
    internal fun providesAppPreference(context: Context): AppPreference {
        return AppPreference(context)
    }

}