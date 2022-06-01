package com.wekanmdb.storeinventory.di.component

import android.app.Application
import com.wekanmdb.storeinventory.app.AppApplication
import com.wekanmdb.storeinventory.di.modules.AppModule

import dagger.BindsInstance
import dagger.Component
import dagger.android.AndroidInjectionModule
import dagger.android.AndroidInjector
import com.wekanmdb.storeinventory.di.modules.ActivityBuildersModule
import com.wekanmdb.storeinventory.di.factory.ViewModelFactory
import javax.inject.Singleton

@Singleton
@Component(
    modules = [
        AndroidInjectionModule::class,
        AppModule::class,
        ActivityBuildersModule::class, ViewModelFactory::class

    ]
)
interface AppComponent : AndroidInjector<AppApplication> {
    @Component.Builder
    interface Builder {
        @BindsInstance
        fun application(application: Application): Builder

        fun build(): AppComponent
    }

    override fun inject(app: AppApplication)
}
