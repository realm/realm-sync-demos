package com.wekanmdb.storeinventory.base

import android.app.Dialog
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.Window
import androidx.databinding.DataBindingUtil
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.databinding.CustomDialogBinding

class CustomLoaderDialog(context: Context) : Dialog(context) {

    private lateinit var mCustomDialogBinding: CustomDialogBinding
    private var enableLottie: Boolean = false

    constructor(context: Context, enableLottie: Boolean = false) : this(context) {
        this.enableLottie = enableLottie
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        mCustomDialogBinding = DataBindingUtil.inflate(
                LayoutInflater.from(context),
                R.layout.custom_dialog,
                null,
                false
        )
        setContentView(mCustomDialogBinding.root)
        setCancelable(false)

    }

}

