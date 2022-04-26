package com.wekanmdb.storeinventory.ui.signup

import androidx.databinding.ObservableField
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.taskApp
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.data.AppConstants
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.model.user.Users
import io.realm.RealmList
import io.realm.RealmResults
import io.realm.kotlin.where
import io.realm.mongodb.App
import io.realm.mongodb.Credentials
import io.realm.mongodb.User
import org.bson.Document
import org.bson.types.ObjectId
import javax.inject.Inject

class SignupViewModel @Inject constructor() : BaseViewModel<SignupNavigator>() {

    var firstName: ObservableField<String> = ObservableField("")
    var lastName: ObservableField<String> = ObservableField("")
    var email: ObservableField<String> = ObservableField("")
    var createPassword: ObservableField<String> = ObservableField("")
    var confirmPassword: ObservableField<String> = ObservableField("")
    val storesresponseBody = MutableLiveData<RealmResults<Stores>?>()
    var storesItemList: RealmResults<Stores>? = null
    fun signupClick() {
        navigator.signupClick()
    }

    fun getAllStore() {

        if (apprealm != null && apprealm?.isClosed == false) {
            /*
            * Selecting All stores from Stores master collection*/
            storesItemList = apprealm?.where<Stores>()?.findAll()
            storesItemList?.addChangeListener { storedetails ->
                if (storedetails.isNotEmpty()) {
                    storesresponseBody.postValue(storesItemList)
                } else {
                    storesresponseBody.value = null
                }
            }
            if (storesItemList?.isNotEmpty()!!) {
                storesresponseBody.postValue(storesItemList)
            } else {
                storesresponseBody.value = null
            }
        }
    }

    fun getRegisterUser(
        userRole: String
    ): MutableLiveData<App.Result<User>?> {
        val responseBody = MutableLiveData<App.Result<User>?>()
        val map = mapOf(
            "email" to email.get().toString().trim(),
            "password" to createPassword.get().toString().trim(),
            "userRole" to userRole,
            "firstName" to firstName.get().toString().trim(),
            "lastName" to lastName.get().toString().trim(),
            "action" to AppConstants.REGISTER
        )

        /*
            * Signup the user*/
        val creds = Credentials.customFunction(Document(map))
        taskApp.loginAsync(creds) { login ->
            if (!login.isSuccess) {
                responseBody.value = null
            } else {
                // when the account has been created successfully, log in to the account
                responseBody.value = login
            }


        }
        return responseBody
    }

    fun updateStore(user: User?, selectedItems: RealmList<Stores>): MutableLiveData<Boolean> {
        val response = MutableLiveData<Boolean>()
        try {

            apprealm?.executeTransaction() {

                val users =
                    it.where<Users>().equalTo("_id", ObjectId(user?.customData?.getString("_id")))
                        ?.findFirst()
                if (users != null) {
            /* Updating stores to the newly signed user*/
                    users.stores = selectedItems
                }
                it.insertOrUpdate(users)
                response.postValue(true)
            }
        } catch (e: Exception) {
            response.postValue(false)
        }
        return response

    }

    fun showCreatePasswordClick() {
        navigator.showCreatePasswordClick()
    }

    fun showConfirmPasswordClick() {
        navigator.showConfirmPasswordClick()
    }

    fun storeUserClick() {
        navigator.storeUserClick()
    }

    fun deliveryUserClick() {
        navigator.deliveryUserClick()
    }
}