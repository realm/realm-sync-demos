package com.wekanmdb.storeinventory.base

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.annotation.LayoutRes
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModelProvider
import com.wekanmdb.storeinventory.data.AppPreference
import dagger.android.support.DaggerFragment
import javax.inject.Inject

abstract class BaseFragment<T : ViewDataBinding?> : DaggerFragment() {
    protected var baseLiveDataLoading = MutableLiveData<Boolean>()
    var baseActivity: BaseActivity<*>? = null
        private set
    var mViewDataBinding: T? = null
    @Inject
    lateinit var viewModelFactory: ViewModelProvider.Factory

    @Inject
    lateinit var appPreference: AppPreference
    @get:LayoutRes
    abstract val layoutId: Int
    protected abstract fun initView(mRootView: View?, mViewDataBinding: ViewDataBinding?)


    override fun onAttach(context: Context) {
        super.onAttach(context)
        if (context is BaseActivity<*>) {
            baseActivity = context
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        mViewDataBinding = DataBindingUtil.inflate(inflater, layoutId, container, false)
        return mViewDataBinding!!.getRoot()
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        initView(mViewDataBinding!!.root, mViewDataBinding)
        baseLiveDataLoading.observe(
            requireActivity(),
            { baseLiveDataLoading: Boolean -> if (baseLiveDataLoading) showLoading() else hideLoading() })
    }

    protected fun showToast( input: String?) {
        Toast.makeText(requireContext(), input, Toast.LENGTH_SHORT).show()
    }

    fun showLoading() {
        if (baseActivity != null) {
            baseActivity!!.showLoading()
        }
    }

    fun hideLoading() {
        if (baseActivity != null) {
            baseActivity!!.hideLoading()
        }
    }

    fun show() {
        if (baseActivity != null) {
            baseActivity!!.showLoading()
        }
    }

    override fun onDetach() {
        baseActivity = null
        super.onDetach()
    }
}