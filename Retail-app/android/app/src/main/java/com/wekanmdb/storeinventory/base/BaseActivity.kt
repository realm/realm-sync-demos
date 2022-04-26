package com.wekanmdb.storeinventory.base

import android.os.Bundle
import android.widget.Toast
import androidx.annotation.LayoutRes
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModelProvider
import com.wekanmdb.storeinventory.data.AppPreference
import com.wekanmdb.storeinventory.extension.observeLiveData
import com.wekanmdb.storeinventory.utils.NetworkUtils
import dagger.android.support.DaggerAppCompatActivity
import java.util.*
import javax.inject.Inject

abstract class BaseActivity<T : ViewDataBinding> : DaggerAppCompatActivity() {

    var baseLiveDataLoading = MutableLiveData<Boolean>()
    lateinit var viewDataBinding: T
    private var mCustomLoader: CustomLoaderDialog? = null

    @Inject
    lateinit var viewModelFactory: ViewModelProvider.Factory

    @Inject
    lateinit var appPreference: AppPreference

    @LayoutRes
    protected abstract fun getLayoutId(): Int

    val loadingObservable: MutableLiveData<*> get() = baseLiveDataLoading

    val isNetworkConnected: Boolean get() = NetworkUtils.isNetworkConnected(applicationContext)

    protected abstract fun initView(mViewDataBinding: ViewDataBinding?)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        viewDataBinding = DataBindingUtil.setContentView(this, getLayoutId())
        initView(viewDataBinding)

        mCustomLoader = CustomLoaderDialog(this, true)

        observeLiveData(baseLiveDataLoading) {
            if (it!!) showLoading() else hideLoading()
        }

    }

    protected fun showToast( input: String?) {
        Toast.makeText(this, input, Toast.LENGTH_SHORT).show()
    }

    fun showLoading() {
        if (mCustomLoader != null) {
            Objects.requireNonNull(mCustomLoader!!.window)
                    ?.setBackgroundDrawableResource(android.R.color.transparent)
            mCustomLoader?.show()
        }
    }

    fun hideLoading() {
        if (mCustomLoader != null) mCustomLoader!!.cancel()
    }

}