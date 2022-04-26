package com.wekanmdb.storeinventory.model.orders

import com.wekanmdb.storeinventory.model.job.ProductQuantity
import com.wekanmdb.storeinventory.model.user.Users
import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import io.realm.annotations.RealmClass
import org.bson.types.ObjectId
import java.util.*

open class Orders(
    @PrimaryKey
     var _id: ObjectId = ObjectId(),
    var _partition: String = "",
    var createdDate: Date=Date(),
    var customerEmail: String= "",
    var customerName: String= "",
    var orderId: String= "",
    var paymentStatus: String? = null,
    var paymentType: String= "",
    var type: Orders_type? = null,
    var createdBy: Users? = null,
    var products: RealmList<ProductQuantity> = RealmList(),
    var location: Order_Location? = null
) : RealmObject()

@RealmClass(embedded = true)
open class Orders_type(
    var address: String? = null,
    var name: String= ""

) : RealmObject()


@RealmClass(embedded = true)
open class Order_Location(
    var latitude: Double = 0.0,
    var longitude: Double= 0.0

) : RealmObject()