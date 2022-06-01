package com.wekanmdb.storeinventory.data

import android.content.Context
import android.content.SharedPreferences
import javax.inject.Inject

class AppPreference @Inject constructor(context: Context) {

    companion object {
        private val PREFERENCE_NAME = "DATABINDING_PREF"
        private val KEY = "KEY"
        private val EMAIL = "EMAIL"
    }

    private val preferences: SharedPreferences =
        context.getSharedPreferences(PREFERENCE_NAME, Context.MODE_PRIVATE)

    /*---------------------------------------------------------Clear Preference -----------------------------------------------------------*/
    fun clearAppPreference() {
        preferences.edit().clear().apply()
    }

    var KEY: String
        set(value) = preferences.edit().putString(Companion.KEY, value).apply()
        get() = preferences.getString(Companion.KEY, "")!!

}