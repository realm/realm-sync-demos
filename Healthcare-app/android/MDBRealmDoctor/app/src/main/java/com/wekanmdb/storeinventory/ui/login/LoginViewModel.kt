package com.wekanmdb.storeinventory.ui.login

import androidx.databinding.ObservableField
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.taskApp
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.data.AppConstants
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import io.realm.RealmResults
import io.realm.kotlin.where
import io.realm.mongodb.App
import io.realm.mongodb.Credentials
import io.realm.mongodb.User
import org.bson.Document
import org.bson.types.ObjectId
import javax.inject.Inject

class LoginViewModel @Inject constructor() : BaseViewModel<LoginNavigator>() {

    var useremail: ObservableField<String> = ObservableField("")
    var userpassword: ObservableField<String> = ObservableField("")

    val practitionerRoleresponseBody = MutableLiveData<RealmResults<PractitionerRole>?>()
    var practitionerList: RealmResults<PractitionerRole>? = null
    /*
    *Passing email,Password and Action name for login
    *  */
    fun getAuthenticateUser(): MutableLiveData<App.Result<User>> {
        val responseBody = MutableLiveData<App.Result<User>>()
        val map: Map<String, String> = mapOf<String, String>(
            "email" to useremail.get().toString().trim(),
            "password" to userpassword.get().toString().trim(),
            "action" to AppConstants.LOGIN
        )
        /*
        * Creating login credentials from customFunction */
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

    fun getPracctitionerRole(id: ObjectId) {
        if (apprealm != null && apprealm?.isClosed == false) {
            /*
            * Selecting All organization from Organization master collection*/
            practitionerList = apprealm?.where<PractitionerRole>()?.equalTo("practitioner._id", id)?.findAll()
            practitionerList?.addChangeListener { result ->
                if (result.isNotEmpty()) {
                    practitionerRoleresponseBody.postValue(practitionerList)
                } else {
                    practitionerRoleresponseBody.value = null
                }
            }
            if (practitionerList?.isNotEmpty()!!) {
                practitionerRoleresponseBody.postValue(practitionerList)
            } else {
                practitionerRoleresponseBody.value = null
            }
        }
    }

    fun loginClick() {
        navigator.loginClick()
    }

    fun signupClick() {
        navigator.signupClick()
    }

    fun showPasswordClick() {
        navigator.showPasswordClick()
    }
}