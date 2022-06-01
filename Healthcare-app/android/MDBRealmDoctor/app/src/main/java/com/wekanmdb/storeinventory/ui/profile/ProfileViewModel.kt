package com.wekanmdb.storeinventory.ui.profile

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.embededclass.Attachment
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import io.realm.kotlin.where
import org.bson.types.ObjectId
import javax.inject.Inject

class ProfileViewModel @Inject constructor() : BaseViewModel<ProfileNavigator>() {
    val practitionerresponseBody = MutableLiveData<PractitionerRole?>()

    fun getPracctitionerRole(id: ObjectId) {
        if (apprealm != null && apprealm?.isClosed == false) {
            /*
            * Selecting Practitioner info*/
            val practitioner =
                apprealm?.where<PractitionerRole>()?.equalTo("practitioner._id", id)?.findFirst()

            if (practitioner != null) {
                practitionerresponseBody.postValue(practitioner)
            } else {
                practitionerresponseBody.postValue(null)
            }
        }
    }

    fun updatePracctitionerRole(
        name: String,
        speciality: String,
        about: String,
        code: String,
        system: String
    ): MutableLiveData<Boolean> {
        val response = MutableLiveData<Boolean>()
        try {
            val practitionerRoleList = apprealm?.where<PractitionerRole>()
                ?.equalTo("practitioner._id", user?.customData?.get("referenceId") as ObjectId)
                ?.findAll()
            apprealm?.executeTransaction() {
                practitionerRoleList?.forEach { practitionerRole ->
                    practitionerRole.specialty?.coding?.first()?.code = code
                    practitionerRole.specialty?.coding?.first()?.display = speciality
                    practitionerRole.specialty?.coding?.first()?.system = system
                    practitionerRole.practitioner?.name?.text = name
                    practitionerRole.practitioner?.about = about
                }

                response.postValue(true)
            }
        } catch (e: Exception) {
            response.postValue(false)
        }

        return response
    }

    fun updateProfilePic(
        practitionerRole: PractitionerRole,
        base64: String
    ): MutableLiveData<Boolean> {
        val response = MutableLiveData<Boolean>()
        try {
            apprealm?.executeTransaction() {
                if(practitionerRole.practitioner?.photo.isNullOrEmpty()) {
                    val attachment = Attachment()
                    attachment.data = base64
                    practitionerRole.practitioner?.photo?.add(attachment)
                }else{
                    practitionerRole.practitioner?.photo?.first()?.data=base64
                }


                response.postValue(true)
            }
        } catch (e: Exception) {
            response.postValue(false)
        }

        return response
    }
}