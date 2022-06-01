package com.wekanmdb.storeinventory.ui.signup

import androidx.databinding.ObservableField
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.taskApp
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.data.AppConstants
import com.wekanmdb.storeinventory.model.embededclass.Availability
import com.wekanmdb.storeinventory.model.embededclass.Codable_Concept
import com.wekanmdb.storeinventory.model.embededclass.Coding
import com.wekanmdb.storeinventory.model.organization.Organization
import com.wekanmdb.storeinventory.model.practitioner.Practitioner
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import com.wekanmdb.storeinventory.utils.Constants.Companion.DOCTOR
import com.wekanmdb.storeinventory.utils.Constants.Companion.NURSE
import com.wekanmdb.storeinventory.utils.Constants.Companion.USER_TYPE
import io.realm.RealmList
import io.realm.mongodb.App
import io.realm.mongodb.Credentials
import io.realm.mongodb.User
import org.bson.Document
import org.bson.types.ObjectId
import java.util.*
import javax.inject.Inject

class SignupViewModel @Inject constructor() : BaseViewModel<SignupNavigator>() {

    var firstName: ObservableField<String> = ObservableField("")
    var lastName: ObservableField<String> = ObservableField("")
    var email: ObservableField<String> = ObservableField("")
    var createPassword: ObservableField<String> = ObservableField("")
    var confirmPassword: ObservableField<String> = ObservableField("")

    fun signupClick() {
        navigator.signupClick()
    }


    fun getRegisterUser(
        userRole: String, gender: String, dob: Date?
    ): MutableLiveData<App.Result<User>?> {
        /**
         * Creating signup custom function call
         */
        val responseBody = MutableLiveData<App.Result<User>?>()
        val map = mapOf(
            "email" to email.get().toString().trim(),
            "password" to createPassword.get().toString().trim(),
            "userType" to userRole,
            "userData" to mapOf(
                "firstName" to firstName.get().toString().trim(),
                "lastName" to lastName.get().toString().trim(),
                "gender" to gender,
                "birthDate" to dob
            ),
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

    /**
     * Store admin can update the Assignee when the Jo status is Open(to-do) only.
     */
    fun updateOrganization(
        speciality: String,
        specialityCode: String,
        specialitySystem: String,
        selectedItems: RealmList<Organization>
    ): MutableLiveData<Boolean> {
        val response = MutableLiveData<Boolean>()
        try {
            val practitioner = apprealm?.where(Practitioner::class.java)
                ?.equalTo(
                    "_id",
                    user!!.customData["referenceId"] as ObjectId
                )?.findFirst()
            apprealm?.executeTransaction() { realm ->
                selectedItems.forEach {
                    val practitionerRole            = PractitionerRole()
                    practitionerRole.identifier     = practitioner!!.identifier
                    practitionerRole.organization   = it
                    practitionerRole.practitioner   = practitioner
                    practitionerRole.active         = true
                    // Doctor Availability
                    val availability                = Availability()
                    availability.allDay             = true
                    availability.availableStartTime = "09:00"
                    availability.availableEndTime   = "05:00"
                    availability.daysOfWeek         = "mon|tue|wed|thu|fri"
                    practitionerRole.availableTime  = availability


                    val codableConcept              = Codable_Concept()
                    val coding                      = Coding()
                    coding.system                   = "http://terminology.hl7.org/CodeSystem/practitioner-role"
                    /**
                     * based on the user type updating the role
                     */
                     if(user!!.customData[USER_TYPE].toString().equals("Doctor",true)){
                         coding.display             = "Doctor"
                         coding.code                =  DOCTOR
                         codableConcept.text        = "Doctor"
                         // adding doctor's speciality
                         val specialityConcept      = Codable_Concept()
                         val specialityCoding       = Coding()
                         specialityCoding.system    = specialitySystem
                         specialityCoding.code      = specialityCode
                         specialityCoding.display   = speciality
                         specialityConcept.coding.add(specialityCoding)
                         specialityConcept.text     = speciality

                         practitionerRole.specialty = specialityConcept
                    }else{
                         coding.display = "Nurse"
                         coding.code = NURSE
                         codableConcept.text = "Nurse"
                    }

                    codableConcept.coding.add(coding)

                    practitionerRole.code = codableConcept

                    realm.insertOrUpdate(practitionerRole)
                }

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




    fun dobClick() {
        navigator.dobClick()
    }

}