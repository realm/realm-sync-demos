package com.wekanmdb.storeinventory.ui.signup

import android.content.Context
import android.content.Intent
import android.text.method.PasswordTransformationMethod
import android.text.method.SingleLineTransformationMethod
import android.view.LayoutInflater
import android.view.View
import android.widget.EditText
import android.widget.ImageView
import androidx.core.content.ContextCompat
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.*
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.data.AppConstants
import com.wekanmdb.storeinventory.databinding.ActivityLoginBinding
import com.wekanmdb.storeinventory.databinding.ActivitySignupBinding
import com.wekanmdb.storeinventory.databinding.StoreListBinding
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.ui.deliveryjob.DeliveryJobActivity
import com.wekanmdb.storeinventory.ui.home.HomeActivity
import com.wekanmdb.storeinventory.utils.Constants.Companion.DELIVERY_USER_ROLE
import com.wekanmdb.storeinventory.utils.Constants.Companion.STORE_ADMIN_USER_ROLE
import com.wekanmdb.storeinventory.utils.EncrytionUtils
import com.wekanmdb.storeinventory.utils.RealmUtils
import com.wekanmdb.storeinventory.utils.UiUtils.isValidEmail
import io.realm.Realm
import io.realm.RealmList
import kotlinx.android.synthetic.main.activity_signup.*
import org.bson.types.ObjectId

class SignupActivity : BaseActivity<ActivityLoginBinding>(), SignupNavigator {

    companion object {
        fun getCallingIntent(context: Context): Intent {
            return Intent(context, SignupActivity::class.java)
        }

        var selectedItems: RealmList<Stores> = RealmList()
    }

    private lateinit var activitySignupBinding: ActivitySignupBinding
    private lateinit var signupViewModel: SignupViewModel
    private var storesAdapter: StoresListAdapter? = null
    private lateinit var storeListBinding: StoreListBinding
    private var storesList: MutableList<Stores>? = null
    override fun getLayoutId(): Int = R.layout.activity_signup
    var showcreatePwd = true
    var showconfirmPwd = true
    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activitySignupBinding = mViewDataBinding as ActivitySignupBinding
        signupViewModel = ViewModelProvider(this).get(SignupViewModel::class.java)
        activitySignupBinding.signupViewModel = signupViewModel
        signupViewModel.navigator = this
        activitySignupBinding.imageView6.setOnClickListener {
            finish()
        }
    }

    override fun signupClick() {
        if (signupViewModel.firstName.get().isNullOrEmpty()) {
            showToast("Enter first name")
            return
        }
        if (signupViewModel.lastName.get().isNullOrEmpty()) {
            showToast("Enter last name")
            return
        }
        if (signupViewModel.email.get().isNullOrEmpty()) {
            showToast("Enter email")
            return
        }
        if (!isValidEmail(signupViewModel.email.get().toString().trim())) {
            showToast("Enter valid email")
            return
        }
        if (signupViewModel.createPassword.get().isNullOrEmpty()) {
            showToast("Enter password")
            return
        }
        if (signupViewModel.confirmPassword.get().isNullOrEmpty()) {
            showToast("Enter confirm password")
            return
        }
        if (!radio0.isChecked && !radio1.isChecked) {
            showToast("Select user type")
            return
        }

        if (activitySignupBinding.createPassword.text.toString() != activitySignupBinding.confirmPassword.text.toString()) {
            showToast("Password mismatch")
            return
        }
        val userRole = if (radio0.isChecked) {
            STORE_ADMIN_USER_ROLE
        } else {
            DELIVERY_USER_ROLE
        }
        showLoading()
        signupViewModel.getRegisterUser(
            userRole
        ).observe(this, { authenticateUser ->
            // Query results are AuthenticateUser
            if (authenticateUser?.isSuccess == true) {
                user = taskApp.currentUser()
                key = EncrytionUtils.getExistingKey(appPreference)
                if (key == null) {
                    key = EncrytionUtils.getNewKey(appPreference)
                }
                //Creating realm instance
                Realm.getInstanceAsync(
                    RealmUtils.getRealmconfig(AppConstants.PARTITIONVALUE),
                    object : Realm.Callback() {
                        override fun onSuccess(realm: Realm) {
                            hideLoading()
                            apprealm = realm
                            if (userRole == DELIVERY_USER_ROLE) {
                                startActivity(DeliveryJobActivity.getCallingIntent(this@SignupActivity))
                            } else {
                                storesBottomSheet()
                                getStore()
                            }
                        }
                    })

            } else {

                showToast("" + authenticateUser?.error)
                hideLoading()
            }

        })
    }


    // Query Realm for all StoreDetails
    private fun getStore() {
        signupViewModel.getAllStore()
        signupViewModel.storesresponseBody.observe(this, { storedetails ->
            if (storedetails != null) {
                storesList = storedetails
                //Sending selected store for to set selected item enabled
                storesAdapter!!.addData(storesList!!.filter { it.name.isNotEmpty() })
            } else {
                showToast("No more Data")
            }
        })


    }

    override fun showCreatePasswordClick() {
        if (signupViewModel.createPassword.get().isNullOrEmpty()) {
            showToast("please enter the password")
            return
        }
        createPassword.requestFocus()
        if (showcreatePwd) {
            showcreatePwd = false
            showPassword(createPassword, imageView7)

        } else {
            showcreatePwd = true

            hidePassword(createPassword, imageView7)
        }

    }

    override fun showConfirmPasswordClick() {
        if (signupViewModel.confirmPassword.get().isNullOrEmpty()) {
            showToast("please enter the confirm password")
            return
        }
        confirmPassword.requestFocus()
        if (showconfirmPwd) {
            showconfirmPwd = false
            showPassword(confirmPassword, imageView8)

        } else {
            showconfirmPwd = true
            hidePassword(confirmPassword, imageView8)
        }

    }

    override fun storeUserClick() {
        activitySignupBinding.textCreate.text = resources.getString(R.string.add_store)
    }

    override fun deliveryUserClick() {
        selectedItems.clear()
        activitySignupBinding.textCreate.text = resources.getString(R.string.create)
    }

    private fun showPassword(password: EditText, imageView: ImageView) {
        password.transformationMethod = SingleLineTransformationMethod()
        imageView.setImageDrawable(
            ContextCompat.getDrawable(
                applicationContext,
                R.mipmap.pwd_show
            )
        )
        password.setSelection(password.text!!.length)
    }

    private fun hidePassword(password: EditText, imageView: ImageView) {
        password.transformationMethod = PasswordTransformationMethod()
        imageView.setImageDrawable(
            ContextCompat.getDrawable(
                applicationContext,
                R.mipmap.pwd_hide
            )
        )
        password.setSelection(password.text!!.length)
    }

    private fun storesBottomSheet() {
        storeListBinding = StoreListBinding.inflate(LayoutInflater.from(this))
        val alertDialog = BottomSheetDialog(this)
        alertDialog.setContentView(storeListBinding.root)
        alertDialog.setCancelable(false)
        storesAdapter = StoresListAdapter(this) { store ->

        }

        storeListBinding.storesList.apply {
            layoutManager = LinearLayoutManager(context)
            adapter = storesAdapter
        }
        storeListBinding.imageView34.visibility = View.INVISIBLE
        storeListBinding.imageView34.setOnClickListener {
            alertDialog.dismiss()
        }
        storeListBinding.textSelect.setOnClickListener {
            showLoading()
            //Update user store
            user?.let {
                signupViewModel.updateStore(user, selectedItems).observe(this, { updateUser ->

                    // Query results are updateUser
                    if (updateUser != null) {
                        //create instance for storeRealm
                        Realm.getInstanceAsync(
                            RealmUtils.getRealmconfig(
                                AppConstants.INVENTORYPARTITIONVALUE + selectedItems.first()?._id.toString()
                            ),
                            object : Realm.Callback() {
                                override fun onSuccess(realm: Realm) {
                                    hideLoading()
                                    alertDialog.dismiss()
                                    storerealm = realm
                                    startActivity(HomeActivity.getCallingIntent(this@SignupActivity))
                                }

                                override fun onError(exception: Throwable) {
                                    showToast(exception.message)
                                    hideLoading()
                                    alertDialog.dismiss()
                                }
                            })

                    } else {
                        showToast("Something went wrong")
                        hideLoading()
                        alertDialog.dismiss()
                    }

                })


            }

        }
        alertDialog.show()
    }


}
