package com.wekanmdb.storeinventory.utils


import android.content.ContentValues
import android.util.Log
import com.wekanmdb.storeinventory.app.key
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.model.appoinment.Appointment
import com.wekanmdb.storeinventory.model.code.Code
import com.wekanmdb.storeinventory.model.condition.Condition
import com.wekanmdb.storeinventory.model.encounter.Encounter
import com.wekanmdb.storeinventory.model.organization.Organization
import com.wekanmdb.storeinventory.model.patient.Patient
import com.wekanmdb.storeinventory.model.practitioner.Practitioner
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import com.wekanmdb.storeinventory.model.procedure.Procedure
import io.realm.mongodb.sync.Subscription
import io.realm.mongodb.sync.SyncConfiguration
import org.bson.types.ObjectId
import java.util.*

object RealmUtils {
    fun getRealmconfig(): SyncConfiguration {
        val config = SyncConfiguration.Builder(user!!)
            .initialSubscriptions { realm, subscriptions ->
                val identifier = user?.customData?.get("uuid")
                Log.e("uuid",identifier.toString())
                if (subscriptions.size() == 0) {
                    subscriptions.addOrUpdate(
                        Subscription.create(
                            realm.where(Organization::class.java).equalTo("active", true)
                        )
                    )
                    subscriptions.addOrUpdate(
                        Subscription.create(
                            realm.where(Code::class.java).equalTo("active", true)
                        )
                    )
                    subscriptions.addOrUpdate(
                        Subscription.create(
                            realm.where(Condition::class.java).equalTo("subjectIdentifier",user?.customData?.get("uuid") as String)

                        )
                    )
                    subscriptions.addOrUpdate(
                        Subscription.create(
                            realm.where(Patient::class.java).equalTo("_id",user?.customData?.get("referenceId") as ObjectId)

                        )
                    )
                    subscriptions.addOrUpdate(
                        Subscription.create(
                            realm.where(Practitioner::class.java).equalTo("active", true)

                        )
                    )
                    subscriptions.addOrUpdate(
                        Subscription.create(
                            realm.where(PractitionerRole::class.java).equalTo("active", true)

                        )
                    )
                    subscriptions.addOrUpdate(
                        Subscription.create(
                            realm.where(Practitioner::class.java).equalTo("active", true)

                        )
                    )
                    subscriptions.addOrUpdate(
                        Subscription.create(
                            realm.where(Encounter::class.java)
                                .equalTo("subjectIdentifier",user?.customData?.get("uuid") as String)

                        )
                    )
                    subscriptions.addOrUpdate(
                        Subscription.create(
                            realm.where(Appointment::class.java)
                                .equalTo("patientIdentifier",user?.customData?.get("uuid") as String)

                        )
                    )
                    subscriptions.addOrUpdate(
                        Subscription.create(
                            realm.where(Procedure::class.java).equalTo("patientIdentifier",user?.customData?.get("uuid") as String)

                        )
                    )

                }
            }.allowQueriesOnUiThread(true)
            .allowWritesOnUiThread(true)
            .errorHandler { session, error ->
                Log.e(ContentValues.TAG, "Sync error: ${error.errorMessage}")
            }
            .waitForInitialRemoteData()
            .build()

        Arrays.fill(key, 0.toByte())
        return config
    }
}