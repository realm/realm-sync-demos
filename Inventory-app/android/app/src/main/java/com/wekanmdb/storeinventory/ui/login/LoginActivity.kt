package com.wekanmdb.storeinventory.ui.login

import android.content.Context
import android.content.Intent
import android.view.View
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.*
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.data.AppConstants
import com.wekanmdb.storeinventory.databinding.ActivityLoginBinding
import com.wekanmdb.storeinventory.ui.deliveryjob.DeliveryJobActivity
import com.wekanmdb.storeinventory.ui.home.HomeActivity
import com.wekanmdb.storeinventory.utils.EncrytionUtils.getExistingKey
import com.wekanmdb.storeinventory.utils.EncrytionUtils.getNewKey
import com.wekanmdb.storeinventory.utils.RealmUtils.getRealmconfig
import io.realm.Realm
import kotlinx.android.synthetic.main.activity_login.*
import org.bson.Document
import org.bson.types.ObjectId

class LoginActivity : BaseActivity<ActivityLoginBinding>(), LoginNavigator {

    companion object {
        fun getCallingIntent(context: Context): Intent {
            return Intent(context, LoginActivity::class.java)
        }
    }

    private lateinit var activityLoginBinding: ActivityLoginBinding
    private lateinit var loginViewModel: LoginViewModel
    private var storeId: ObjectId? = null

    override fun getLayoutId(): Int = R.layout.activity_login

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityLoginBinding = mViewDataBinding as ActivityLoginBinding
        loginViewModel = ViewModelProvider(this).get(LoginViewModel::class.java)
        activityLoginBinding.loginViewModel = loginViewModel
        loginViewModel.navigator = this
    }

    // Userlogin AuthenticateUser verify
    override fun loginClick() {
        if (loginViewModel.useremail.get().isNullOrEmpty()) {
            showToast("please enter the username")
            return
        }

        if (loginViewModel.userpassword.get().isNullOrEmpty()) {
            showToast("please enter the password")
            return
        }

        progressBar.visibility = View.VISIBLE
        loginViewModel.getAuthenticateUser()
            .observe(this, { authenticateUser ->
                // Query results are AuthenticateUser
                if (authenticateUser.isSuccess) {
                    user = taskApp.currentUser()
                    key = getExistingKey(appPreference)
                    if (key == null) {
                        key = getNewKey(appPreference)
                    }
                    asyncConfig()
                } else {
                    progressBar.visibility = View.GONE
                    showToast(""+authenticateUser.error)
                }
            })
    }

    // Use the config
    fun asyncConfig() {
        storeId = user?.customData?.getObjectId("stores")

        Realm.getInstanceAsync(
            getRealmconfig(AppConstants.PARTITIONVALUE),
            object : Realm.Callback() {
                override fun onSuccess(realm: Realm) {
                    apprealm = realm
                    getSyncData()
                }
            })
        if (storeId != null) {
            Realm.getInstanceAsync(getRealmconfig(AppConstants.INVENTORYPARTITIONVALUE + storeId),
                object : Realm.Callback() {
                    override fun onSuccess(realm: Realm) {
                        storerealm = realm
                        getSyncData()
                    }
                })
        }

    }

    fun getSyncData() {
        if (storeId != null && apprealm != null && storerealm != null) {
            user?.let { login(it.customData) }
        } else if (storeId == null && apprealm != null) {
            user?.let { login(it.customData) }
        }
    }

    private fun login(customData: Document?) {
        try {
            progressBar.visibility = View.GONE
            val customDataString = customData?.getString("userRole")
            if (customDataString.equals("store-user", true)) {
                startActivity(HomeActivity.getCallingIntent(this))
            } else {
                startActivity(DeliveryJobActivity.getCallingIntent(this))
            }
        } catch (e: Exception) {

        }

    }
}
