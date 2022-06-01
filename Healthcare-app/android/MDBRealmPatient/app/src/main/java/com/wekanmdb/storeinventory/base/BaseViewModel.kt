package com.wekanmdb.storeinventory.base

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import java.lang.ref.WeakReference

abstract class BaseViewModel<N> : ViewModel() {
//    private var compositeDisposable = CompositeDisposable()
    private lateinit var mNavigator: WeakReference<N>
    private var liveErrorResponse = MutableLiveData<String>()


    var navigator: N
        get() = mNavigator.get()!!
        set(navigator) {
            this.mNavigator = WeakReference(navigator)
        }

//    fun getCompositeDisposable() = compositeDisposable

    override fun onCleared() {
        super.onCleared()
//        compositeDisposable.clear()
    }

    fun getErrorObservable(): MutableLiveData<String> {
        return liveErrorResponse
    }

}
