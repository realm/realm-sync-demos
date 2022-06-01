package com.wekanmdb.storeinventory.ui.signup

import android.app.DatePickerDialog
import android.content.Context
import android.content.Intent
import android.os.Build
import android.text.method.PasswordTransformationMethod
import android.text.method.SingleLineTransformationMethod
import android.util.Log
import android.widget.ArrayAdapter
import android.widget.DatePicker
import android.widget.EditText
import android.widget.ImageView
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.DialogFragment
import androidx.lifecycle.ViewModelProvider
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.key
import com.wekanmdb.storeinventory.app.taskApp
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityLoginBinding
import com.wekanmdb.storeinventory.databinding.ActivitySignupBinding
import com.wekanmdb.storeinventory.ui.patientBasicInfo.PatientInfoActivity
import com.wekanmdb.storeinventory.utils.Constants.Companion.DOCTOR
import com.wekanmdb.storeinventory.utils.DatePickerFragment
import com.wekanmdb.storeinventory.utils.EncrytionUtils
import com.wekanmdb.storeinventory.utils.RealmUtils
import com.wekanmdb.storeinventory.utils.UiUtils.isValidEmail
import io.realm.Realm
import kotlinx.android.synthetic.main.activity_signup.*
import java.text.SimpleDateFormat
import java.util.*

class SignupActivity : BaseActivity<ActivityLoginBinding>(), SignupNavigator,
    DatePickerDialog.OnDateSetListener {

    companion object {
        fun getCallingIntent(context: Context): Intent {
            return Intent(context, SignupActivity::class.java)
        }
    }

    private lateinit var activitySignupBinding: ActivitySignupBinding
    private lateinit var signupViewModel: SignupViewModel
    override fun getLayoutId(): Int = R.layout.activity_signup
    private var showCreatePwd = true
    var showConfirmPwd = true
    var calendar: Calendar = Calendar.getInstance()
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

    // This function is used to generate static dropdown values ans view for gender and Role
    private fun spinnerInit() {
        val gender =
            listOf("Select Gender", "Male", "Female", "Others")

        val genderAdapter = ArrayAdapter(
            this,
            R.layout.spinner_row, gender
        )

        val role =
            listOf("Patient")

        val adapter = ArrayAdapter(
            this,
            R.layout.spinner_row, role
        )
        activitySignupBinding.spinner2.adapter = genderAdapter
        activitySignupBinding.spinner.adapter = adapter
    }

    @RequiresApi(Build.VERSION_CODES.O)
    /*
    * click function of First Time Signing up and check the fields are not empty
    * getting response from register user and start the next activity
    * */
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
        if (activitySignupBinding.spinner.selectedItem.toString().isNullOrEmpty()) {
            showToast("Select the Role")
            return
        }
        if (activitySignupBinding.spinner2.selectedItem.toString().isNullOrEmpty()) {
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
            userRole, gender, date
        ).observe(this) { authenticateUser ->
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
                        @RequiresApi(Build.VERSION_CODES.O)
                        override fun onSuccess(realm: Realm) {
                            hideLoading()
                            apprealm = realm
                            if (userRole == DOCTOR) {
                                //TODO : Need to show the hospitals list to select
                            } else {
                                startActivity(PatientInfoActivity.getCallingIntent(this@SignupActivity))
                            }
                        }
                    })

            } else {
                showToast("" + authenticateUser?.error)
                hideLoading()
            }
        }
    }

    /*
    * click function of showing the entered password
     */
    override fun showCreatePasswordClick() {
        if (signupViewModel.createPassword.get().isNullOrEmpty()) {
            showToast("please enter the password")
            return
        }
        createPassword.requestFocus()
        if (showCreatePwd) {
            showCreatePwd = false
            showPassword(createPassword, imageView7)

        } else {
            showCreatePwd = true

            hidePassword(createPassword, imageView7)
        }

    }

    /*
    * click function of showing the entered confirm password
     */
    override fun showConfirmPasswordClick() {
        if (signupViewModel.confirmPassword.get().isNullOrEmpty()) {
            showToast("please enter the confirm password")
            return
        }
        confirmPassword.requestFocus()
        if (showConfirmPwd) {
            showConfirmPwd = false
            showPassword(confirmPassword, imageView8)

        } else {
            showConfirmPwd = true
            hidePassword(confirmPassword, imageView8)
        }

    }

    override fun patientUserClick() {
        activitySignupBinding.textCreate.text = resources.getString(R.string.create)
    }

    //Calender for selecting date of birth
    override fun dobClick() {
        val datePicker: DialogFragment = DatePickerFragment()
        datePicker.show(supportFragmentManager, "date picker")
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

    // Setting the date selected on Calender
    override fun onDateSet(view: DatePicker?, year: Int, month: Int, dayOfMonth: Int) {
        calendar[Calendar.YEAR] = year
        calendar[Calendar.MONTH] = month
        calendar[Calendar.DATE] = dayOfMonth
        val months = month + 1
        val dat = "$year-$months-$dayOfMonth"
        val dateFormat = SimpleDateFormat("yyyy-mm-dd")
        date = calendar.time
        try {
            val d = dateFormat.parse(dat)
            val jobDay = dateFormat.format(d)
            activitySignupBinding.textView58.text = jobDay


        } catch (e: Exception) { //java.text.ParseException: Unparseable date: Geting error
            Log.d("error", e.message.toString())
        }
    }


}
