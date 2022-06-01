package com.wekanmdb.storeinventory.ui.splash

import android.os.Handler
import android.os.Looper
import androidx.databinding.ViewDataBinding
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivitySplashBinding
import com.wekanmdb.storeinventory.ui.listOfHospitals.ListOfHospitalsActivity
import com.wekanmdb.storeinventory.ui.login.LoginActivity
import com.wekanmdb.storeinventory.ui.patientBasicInfo.PatientInfoActivity

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
                val customDataString = user?.customData?.getString("userType")
                if(customDataString != null) {

                        startActivity(ListOfHospitalsActivity.getCallingIntent(this))

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