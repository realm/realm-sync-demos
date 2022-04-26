package com.wekanmdb.storeinventory.utils

import android.annotation.SuppressLint
import android.content.Context
import android.net.ConnectivityManager

object NetworkUtils {

    @SuppressLint("MissingPermission")
    fun isNetworkConnected(context: Context): Boolean {
        val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val activeNetwork = cm.activeNetworkInfo
        return !(activeNetwork == null || !activeNetwork.isConnectedOrConnecting)
    }

}
