package com.wekanmdb.storeinventory.ui.home

import android.content.Context
import android.content.Intent
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.NavController
import androidx.navigation.findNavController
import androidx.navigation.ui.AppBarConfiguration
import androidx.navigation.ui.navigateUp
import androidx.navigation.ui.setupWithNavController
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityHomeBinding
import kotlinx.android.synthetic.main.activity_home.*
import org.bson.types.ObjectId


class HomeActivity : BaseActivity<ActivityHomeBinding>(), HomeNavigator {
    companion object {
        fun getCallingIntent(context: Context): Intent {
            return Intent(context, HomeActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
    }

    private lateinit var activityHomeBinding: ActivityHomeBinding
    private lateinit var homeViewModel: HomeViewModel
    private var navController: NavController? = null
    private lateinit var appBarConfiguration: AppBarConfiguration

    override fun getLayoutId(): Int = R.layout.activity_home

    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityHomeBinding = mViewDataBinding as ActivityHomeBinding
        homeViewModel = ViewModelProvider(this, viewModelFactory).get(HomeViewModel::class.java)
        activityHomeBinding.homeViewModel = homeViewModel
        homeViewModel.navigator = this

        //  BottomNavigationView
        navController = findNavController(R.id.nav_host_fragment)
        nav_view.setupWithNavController(navController!!)

    }

    override fun onSupportNavigateUp(): Boolean {
        return navController!!.navigateUp(appBarConfiguration) || super.onSupportNavigateUp()
    }
    fun getOrderInfo(order: ObjectId): String? {
        return homeViewModel.getOrderInfo(order)
    }

}