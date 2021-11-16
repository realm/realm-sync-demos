package com.wekanmdb.storeinventory.ui.profile

import android.app.Dialog
import android.content.Intent
import android.view.View
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.storerealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseFragment
import com.wekanmdb.storeinventory.databinding.FragmentProfileBinding
import com.wekanmdb.storeinventory.ui.login.LoginActivity
import kotlinx.android.synthetic.main.dialog_logout.*
import kotlinx.android.synthetic.main.fragment_profile.*
import org.bson.types.ObjectId


class ProfileFragment : BaseFragment<FragmentProfileBinding>(), ProfileNavigator {

    private lateinit var profileViewModel: ProfileViewModel
    private lateinit var pragmentProfileBinding: FragmentProfileBinding
    private var storeId: ObjectId? = null
    private var firstName: String? = null
    private var lastName: String? = null
    private var email: String? = null
    private var userRole: String? = null

    override val layoutId: Int
        get() = R.layout.fragment_profile

    override fun initView(mRootView: View?, mViewDataBinding: ViewDataBinding?) {
        pragmentProfileBinding = mViewDataBinding as FragmentProfileBinding
        profileViewModel = ViewModelProvider(this).get(ProfileViewModel::class.java)
        pragmentProfileBinding.profileViewModel = profileViewModel
        profileViewModel.navigator = this
        storeId = user?.customData?.getObjectId("stores")
        firstName = user?.customData?.getString("firstName")
        lastName = user?.customData?.getString("lastName")
        email = user?.customData?.getString("email")
        userRole = user?.customData?.getString("userRole")
        profileViewModel.storeId.set(storeId.toString())
        profileViewModel.firstName.set(firstName.toString())
        profileViewModel.lastName.set(lastName.toString())
        profileViewModel.email.set(email.toString())
        profileViewModel.role.set(userRole.toString())
        getStore()
    }

    // Query Realm for all StoreDetails
    private fun getStore() {
        profileViewModel.storesresponseBody.observe(this, { storedetails ->
            if (storedetails != null) {
                pragmentProfileBinding.stores = storedetails
                pragmentProfileBinding.executePendingBindings()
            } else {
                showToast("No more Data")
            }
        })
        profileViewModel.getStore()
        profileViewModel.storeListener()
    }

    // logout fuction
    private fun logout() {
        val dialoglogout = Dialog(requireActivity(), R.style.dialog_center)
        dialoglogout.setCancelable(false)
        dialoglogout.setContentView(R.layout.dialog_logout)
        dialoglogout.show()
        val no = dialoglogout.textView23
        val yes = dialoglogout.textView24
        no.setOnClickListener {
            dialoglogout.dismiss()
        }
        yes.setOnClickListener {
            user?.logOutAsync { logout ->
                if (logout.isSuccess) {
                    apprealm?.close()
                    storerealm?.close()
                    user = null
                    startActivity(
                        LoginActivity.getCallingIntent(requireActivity())
                            .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    )
                    dialoglogout.dismiss()
                } else {
                    showToast("log out failed! Error: ${logout.error}")
                }
            }
        }
    }

    override fun logoutClick() {
        logout()
    }
}