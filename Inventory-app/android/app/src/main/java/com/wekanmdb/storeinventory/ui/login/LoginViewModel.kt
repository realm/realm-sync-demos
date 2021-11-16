package com.wekanmdb.storeinventory.ui.login

import androidx.databinding.ObservableField
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.taskApp
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.data.AppConstants
import io.realm.mongodb.App
import io.realm.mongodb.Credentials
import io.realm.mongodb.User
import org.bson.Document
import javax.inject.Inject

class LoginViewModel @Inject constructor() : BaseViewModel<LoginNavigator>() {

    var useremail: ObservableField<String> = ObservableField("")
    var userpassword: ObservableField<String> = ObservableField("")

    fun getAuthenticateUser(): MutableLiveData<App.Result<User>> {
        val responseBody = MutableLiveData<App.Result<User>>()
        val map: Map<String, String> = mapOf<String, String>(
            "email" to useremail.get().toString().trim(),
            "password" to userpassword.get().toString().trim(),
            "action" to AppConstants.LOGIN
        )
        val creds = Credentials.customFunction(Document(map))
        taskApp.loginAsync(creds) { login ->
            if (!login.isSuccess) {
                responseBody.value = login
            } else {
                // when the account has been created successfully, log in to the account
                responseBody.value = login
            }


        }
        return responseBody
    }

    fun loginClick() {
        navigator.loginClick()
    }
}