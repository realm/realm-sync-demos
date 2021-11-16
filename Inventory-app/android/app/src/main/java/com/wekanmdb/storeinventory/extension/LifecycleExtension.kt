package com.wekanmdb.storeinventory.extension

import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LiveData
import androidx.lifecycle.Observer

inline fun <T> LifecycleOwner.observeLiveData(
        data: LiveData<T>,
        crossinline onChanged: (T) -> Unit
) {
    data.observe(this, Observer {
        it?.let { value -> onChanged(value) }
    })
}