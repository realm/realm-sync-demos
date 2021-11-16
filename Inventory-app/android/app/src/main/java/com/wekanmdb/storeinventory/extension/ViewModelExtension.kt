package com.wekanmdb.storeinventory.extension

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider

inline fun <reified VM : ViewModel> FragmentActivity.provideViewModel(
        crossinline factory: () -> VM
): VM {
    return ViewModelProvider(this, object : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : ViewModel?> create(modelClass: Class<T>): T = factory() as T
    }).get(VM::class.java)

}

inline fun <reified VM : ViewModel> Fragment.provideViewModel(
        crossinline factory: () -> VM
): VM {
    return ViewModelProvider(this, object : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : ViewModel?> create(modelClass: Class<T>): T = factory() as T
    }).get(VM::class.java)
}