package com.wekanmdb.storeinventory.ui.splash

import android.os.Handler
import android.os.Looper
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivitySplashBinding
import com.wekanmdb.storeinventory.ui.home.HomeActivity
import com.wekanmdb.storeinventory.ui.login.LoginActivity
import com.wekanmdb.storeinventory.ui.login.LoginViewModel
import com.wekanmdb.storeinventory.ui.signup.OrganizationUpdateActivity
import com.wekanmdb.storeinventory.utils.Constants.Companion.USER_TYPE
import com.wekanmdb.storeinventory.utils.RealmUtils
import io.realm.Realm
import org.bson.types.ObjectId
import java.util.Observer

class SplashActivity : BaseActivity<ActivitySplashBinding>() {
    private lateinit var mDataBinding: ActivitySplashBinding

    override fun getLayoutId(): Int = R.layout.activity_splash
    private lateinit var splashViewModel: SplashViewModel
    override fun initView(mViewDataBinding: ViewDataBinding?) {
        mDataBinding = mViewDataBinding as ActivitySplashBinding
        splashViewModel = ViewModelProvider(this).get(SplashViewModel::class.java)
        Handler(Looper.getMainLooper()).postDelayed({
            /*
            *Check the user is logged-in or not
            **/
            if (user==null) {
                startActivity(LoginActivity.getCallingIntent(this))
                finish()
            } else {
                val customDataString = user?.customData?.getString(USER_TYPE)
                if(customDataString != null) {
                    Realm.getInstanceAsync(RealmUtils.getRealmconfig(), object : Realm.Callback() {
                        override fun onSuccess(realm: Realm) {
                            apprealm =realm
                            checkOrganizations()
                        }
                    })

                }else{
                    showToast("Invalid user credentials")
                    startActivity(LoginActivity.getCallingIntent(this))
                    finish()
                }
            }

        }, 3000)

    }

    private fun checkOrganizations() {
        splashViewModel.getPracctitionerRole(user?.customData?.get("referenceId") as ObjectId)
        splashViewModel.practitionerRoleresponseBody.observe(this,
            { result ->
                /**
                 * If role is assigned to the practitioner App will redirect to home screen otherwise it will redirect to Welcome screen
                 */
                if (result != null && result.size > 0) {
                    startActivity(HomeActivity.getCallingIntent(this))
                } else {
                    startActivity(OrganizationUpdateActivity.getCallingIntent(this))
                }

            })

        finish()
    }
}