package com.wekanmdb.storeinventory.ui.signup

import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.databinding.ObservableField
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.taskApp
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.data.AppConstants
import io.realm.mongodb.App
import io.realm.mongodb.Credentials
import io.realm.mongodb.User
import org.bson.Document
import java.time.LocalDateTime
import java.util.*
import javax.inject.Inject

class SignupViewModel @Inject constructor() : BaseViewModel<SignupNavigator>() {

    var firstName: ObservableField<String> = ObservableField("")
    var lastName: ObservableField<String> = ObservableField("")
    var email: ObservableField<String> = ObservableField("")
    var createPassword: ObservableField<String> = ObservableField("")
    var confirmPassword: ObservableField<String> = ObservableField("")

    fun signupClick() {
        navigator.signupClick()
    }

    /*
    * This function used to register the user
    * params email,password,usertype,firstname,lastname,gender,dob
    */
    @RequiresApi(Build.VERSION_CODES.O)
    fun getRegisterUser(
        userRole: String, gender: String, dob: Date?
    ): MutableLiveData<App.Result<User>?> {
        val responseBody = MutableLiveData<App.Result<User>?>()
        val map = mapOf(
            "email" to email.get().toString().trim(),
            "password" to createPassword.get().toString().trim(),
            "userType" to "patient",
            "userData" to mapOf(
                "firstName" to firstName.get().toString().trim(),
                "lastName" to lastName.get().toString().trim(),
                "gender" to gender,
                "birthDate" to dob
            ),
            "action" to AppConstants.REGISTER
        )
        /*
            * Signup the user*/
        val creds = Credentials.customFunction(Document(map))
        Log.v("CHECKTimer", "RESPONSE: ${LocalDateTime.now()}")

        taskApp.loginAsync(creds) { login ->
            if (!login.isSuccess) {
                Log.v("CHECKTimer", "RESPONSE: ${LocalDateTime.now()}")
                responseBody.value = null
            } else {
                // when the account has been created successfully, log in to the account
                responseBody.value = login
            }

            Log.v("CHECK", "RESPONSE: ${responseBody.value}")
        }
        return responseBody
    }


    fun showCreatePasswordClick() {
        navigator.showCreatePasswordClick()
    }

    fun showConfirmPasswordClick() {
        navigator.showConfirmPasswordClick()
    }

    fun dobClick() {
        navigator.dobClick()
    }
}