package com.wekanmdb.storeinventory.services

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.location.Location
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.model.user.Users
import io.realm.RealmList
import io.realm.kotlin.where
import org.bson.types.ObjectId

class LocationService : Service() {
    private val TAG = "LocationService"
    private var notificationManager: NotificationManager? = null

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        val notficationId = 1001
        var id = resources.getString(R.string.app_name)
        val name: CharSequence = resources.getString(R.string.app_name)
        val description = resources.getString(R.string.location_update)
        var userId = user?.customData?.getString("_id")
        val notification: Notification = NotificationCompat.Builder(this, "location_update")
            .setChannelId(id)
            .setContentTitle(getText(R.string.app_name))
            .setContentText(getText(R.string.location_update))
            .setSmallIcon(R.mipmap.ic_launcher)
            .setOngoing(true)
            .build()
        notificationManager =
            this.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val importance = NotificationManager.IMPORTANCE_MAX
            @SuppressLint("WrongConstant") val mChannel = NotificationChannel(id, name, importance)
            mChannel.description = description
            mChannel.enableLights(true)
            mChannel.lightColor = Color.BLACK
            notificationManager!!.createNotificationChannel(mChannel)
            notificationManager!!.notify(notficationId, notification)
        } else {
            notificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager!!.notify(notficationId, notification)
        }


        startForeground(notficationId, notification)

        LocationHelper().startListeningUserLocation(
            this, object : MyLocationListener {
                override fun onLocationChanged(location: Location?) {
                    if(isServiceStarted) {
                        mLocation = location
                        mLocation?.let { latlong ->
                            Log.d(
                                TAG,
                                "onLocationChanged: Latitude ${latlong.latitude} , Longitude ${latlong.longitude}"
                            )
                            val userRealmObject =
                                apprealm?.where<Users>()?.equalTo("_id", ObjectId(userId))
                                    ?.findFirst()
                            apprealm?.executeTransaction() {
                                userRealmObject?.location =
                                    RealmList(latlong.latitude, latlong.longitude)
                            }
                        }
                    }
                }
            })
        return START_STICKY
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        isServiceStarted = false
        stopForeground(true)
    }

    companion object {
        var mLocation: Location? = null
        var isServiceStarted = false
    }
}