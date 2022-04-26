package com.wekanmdb.storeinventory.ui.createOrders

import android.os.Parcel
import android.os.Parcelable
import com.wekanmdb.storeinventory.model.orders.Orders_type
import java.util.*

/**
 * This is a wrapper class used for adding product items
 * & binding with adapter to show how many Product items are added to create Jobs.
 */
data class CreateOrder(
    var orderId: String?,
    var customerName: String?,
    var paymentStatus: String?,
    var customerEmail: String?,
    var createdDate: Date?,
    var address: String?,
    var name: String?,
    var paymentType: String?
) : Parcelable {
    constructor(parcel: Parcel) : this(
        parcel.readString(),
        parcel.readString(),
        parcel.readString(),
        parcel.readString(),
        parcel.readValue(Date::class.java.classLoader) as? Date,
        parcel.readString(),
        parcel.readString(),
        parcel.readString()
    ) {
    }

    override fun writeToParcel(parcel: Parcel, flags: Int) {
        parcel.writeString(orderId)
        parcel.writeString(customerName)
        parcel.writeString(paymentStatus)
        parcel.writeString(customerEmail)
        parcel.writeValue(createdDate)
        parcel.writeString(address)
        parcel.writeString(name)
        parcel.writeString(paymentType)
    }

    override fun describeContents(): Int {
        return 0
    }

    companion object CREATOR : Parcelable.Creator<CreateOrder> {
        override fun createFromParcel(parcel: Parcel): CreateOrder {
            return CreateOrder(parcel)
        }

        override fun newArray(size: Int): Array<CreateOrder?> {
            return arrayOfNulls(size)
        }
    }
}