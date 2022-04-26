package com.wekanmdb.storeinventory.di.factory

import androidx.lifecycle.ViewModelProvider
import com.wekanmdb.storeinventory.extension.DaggerViewModelFactory
import dagger.Binds
import dagger.Module

@Module
abstract class ViewModelFactory {
    @Binds
    internal abstract fun bindViewModelFactory(factoryApp: DaggerViewModelFactory): ViewModelProvider.Factory
}
