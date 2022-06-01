package com.wekanmdb.storeinventory.ui.consultation

import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.base.BaseViewModel
import com.wekanmdb.storeinventory.model.encounter.Encounter
import io.realm.RealmResults
import io.realm.Sort
import io.realm.kotlin.where
import org.bson.types.ObjectId
import java.util.*
import javax.inject.Inject

class ConsultationViewModel @Inject constructor() : BaseViewModel<ConsultationNavigator>() {
    /**
     * This getConsultation  method is used to fetch consultation list info to view.
     */
    val consultationresponseBody = MutableLiveData<List<Encounter>?>()
    var consultationList: RealmResults<Encounter>? = null

    fun getConsultation(id: ObjectId, user: ObjectId?) {
        if (apprealm != null && apprealm?.isClosed == false) {

            /*
            * Selecting All Encounter from Encounter collection*/
            consultationList =
                apprealm?.where<Encounter>()?.equalTo("serviceProvider.identifier", id)
                    ?.equalTo("participant.individual.identifier", user)
                    ?.sort("appointment.start", Sort.DESCENDING)?.findAll()
            consultationList?.addChangeListener { result ->
                if (result.isNotEmpty()) {
                    consultationresponseBody.postValue(apprealm!!.copyFromRealm(consultationList))
                } else {
                    consultationresponseBody.value = null
                }
            }
            if (consultationList?.isNotEmpty()!!) {
                consultationresponseBody.postValue(apprealm!!.copyFromRealm(consultationList))
            } else {
                consultationresponseBody.value = null
            }
        }
    }

    fun getConsultationFilter(
        id: ObjectId,
        user: ObjectId?,
        startDate: Date?,

        endDate: Date?
    ) {

        consultationList =
            apprealm?.where<Encounter>()?.equalTo("serviceProvider.identifier", id)
                ?.equalTo("participant.individual.identifier", user)
                ?.greaterThanOrEqualTo("appointment.start",startDate)
                ?.lessThanOrEqualTo("appointment.start",endDate)
                ?.sort("appointment.start", Sort.DESCENDING)?.findAll()

        if (consultationList?.isNotEmpty()!!) {
            consultationresponseBody.postValue(apprealm!!.copyFromRealm(consultationList))
        } else {
            consultationresponseBody.value = null
        }

    }
  fun getConsultationSingleFilter(
        id: ObjectId,
        user: ObjectId?,
        startDate: Date?
    ) {

        consultationList =
            apprealm?.where<Encounter>()?.equalTo("serviceProvider.identifier", id)
                ?.equalTo("participant.individual.identifier", user)
                ?.greaterThan("appointment.start",startDate)
                ?.lessThanOrEqualTo("appointment.start",startDate)
                ?.sort("appointment.start", Sort.DESCENDING)?.findAll()

        if (consultationList?.isNotEmpty()!!) {
            consultationresponseBody.postValue(apprealm!!.copyFromRealm(consultationList))
        } else {
            consultationresponseBody.value = null
        }

    }

}