package com.wekanmdb.storeinventory.ui.signup

import android.app.DatePickerDialog
import android.content.Context
import android.content.Intent
import android.text.method.PasswordTransformationMethod
import android.text.method.SingleLineTransformationMethod
import android.util.Log
import android.widget.ArrayAdapter
import android.widget.EditText
import android.widget.ImageView
import androidx.core.content.ContextCompat
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.*
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivitySignupBinding
import com.wekanmdb.storeinventory.utils.EncrytionUtils
import com.wekanmdb.storeinventory.utils.RealmUtils
import com.wekanmdb.storeinventory.utils.UiUtils.isValidEmail
import io.realm.Realm
import kotlinx.android.synthetic.main.activity_signup.*
import java.text.SimpleDateFormat
import java.util.*

class SignupActivity : BaseActivity<ActivitySignupBinding>(), SignupNavigator{

    companion object {
        fun getCallingIntent(context: Context): Intent {
            return Intent(context, SignupActivity::class.java)
        }

    }

    private lateinit var activitySignupBinding: ActivitySignupBinding
    private lateinit var signupViewModel: SignupViewModel
    override fun getLayoutId(): Int = R.layout.activity_signup
    var showcreatePwd = true
    var showconfirmPwd = true
    var calendar = Calendar.getInstance()
    var date: Date? = null
    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activitySignupBinding = mViewDataBinding as ActivitySignupBinding
        signupViewModel = ViewModelProvider(this).get(SignupViewModel::class.java)
        activitySignupBinding.signupViewModel = signupViewModel
        signupViewModel.navigator = this
        activitySignupBinding.imageView6.setOnClickListener {
            finish()
        }
        spinnerInit()
    }

    fun spinnerInit() {
        val gender =
            listOf("Select the Gender","Male","Female")

        val genderAdapter = ArrayAdapter(
            this,
            R.layout.spinner_row, gender
        )

        val role =
            listOf("Select the Roll","Doctor","Nurse")

        val adapter = ArrayAdapter(
            this,
            R.layout.spinner_row, role
        )
        activitySignupBinding.spinner2.adapter = genderAdapter
        activitySignupBinding.spinner.adapter = adapter
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
        if (activitySignupBinding.spinner.selectedItem.toString().isNullOrEmpty() ||
            activitySignupBinding.spinner.selectedItem.toString()=="Select the Roll") {
            showToast("Select the Roll")
            return
        }
        if (activitySignupBinding.spinner2.selectedItem.toString().isNullOrEmpty()||
                activitySignupBinding.spinner2.selectedItem.toString()=="Select the Gender") {
            showToast("Select the Gender")
            return
        }

        if (activitySignupBinding.textView58.text.toString().isNullOrEmpty()) {
            showToast("Select the DOB")
            return
        }


        if (activitySignupBinding.createPassword.text.toString() != activitySignupBinding.confirmPassword.text.toString()) {
            showToast("Password mismatch")
            return
        }
        val userRole = activitySignupBinding.spinner.selectedItem.toString()
        val gender = activitySignupBinding.spinner2.selectedItem.toString()

        showLoading()
        signupViewModel.getRegisterUser(
            userRole,gender,date
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
                    RealmUtils.getRealmconfig(),
                    object : Realm.Callback() {
                        override fun onSuccess(realm: Realm) {
                            hideLoading()
                            apprealm = realm

                                startActivity(OrganizationUpdateActivity.getCallingIntent(this@SignupActivity))

                        }
                    })

            } else {

                showToast("" + authenticateUser?.error)
                hideLoading()
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



    val day = calendar[Calendar.DAY_OF_MONTH]
    val year = calendar[Calendar.YEAR]
    val month = calendar[Calendar.MONTH]
    override fun dobClick() {

       var datePicker = DatePickerDialog(this@SignupActivity,
            { view, year, month, dayOfMonth -> // adding the selected date in the edittext

                var months = month + 1
                var dat = "$year-$months-$dayOfMonth"
                val dateFormat = SimpleDateFormat("yyyy-mm-dd")
                date = calendar.time
                Log.d("wekanc", "date after date selection : $date")

                try {
                    val d = dateFormat.parse(dat)
                    val jobDay = dateFormat.format(d)
                    activitySignupBinding.textView58.text = jobDay


                } catch (e: Exception) {
                    Log.d("errordroid", e.message.toString())
                }
            }, year, month, day
        )

        // set maximum date to be selected as today
        datePicker.datePicker.maxDate = calendar.timeInMillis

        // show the dialog
        datePicker.show()
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




}
