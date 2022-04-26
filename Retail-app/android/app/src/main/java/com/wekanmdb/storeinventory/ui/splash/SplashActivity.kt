package com.wekanmdb.storeinventory.ui.splash

import android.os.Handler
import android.os.Looper
import androidx.databinding.ViewDataBinding
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivitySplashBinding
import com.wekanmdb.storeinventory.ui.deliveryjob.DeliveryJobActivity
import com.wekanmdb.storeinventory.ui.home.HomeActivity
import com.wekanmdb.storeinventory.ui.login.LoginActivity

class SplashActivity : BaseActivity<ActivitySplashBinding>() {
    private lateinit var mDataBinding: ActivitySplashBinding

    override fun getLayoutId(): Int = R.layout.activity_splash

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        mDataBinding = mViewDataBinding as ActivitySplashBinding

        Handler(Looper.getMainLooper()).postDelayed({
            /*
            *Check the user is logged-in or not
            **/
            if (user==null) {
                startActivity(LoginActivity.getCallingIntent(this))
                finish()
            } else {
                val customDataString = user?.customData?.getString("userRole")
                if(customDataString != null) {
                    if (customDataString.equals("store-user", true)) {
                        startActivity(HomeActivity.getCallingIntent(this))
                    } else {
                        startActivity(DeliveryJobActivity.getCallingIntent(this))
                    }
                    finish()
                }else{
                    showToast("Invalid user credentials")
                    startActivity(LoginActivity.getCallingIntent(this))
                    finish()
                }
            }

        }, 3000)

    }
}