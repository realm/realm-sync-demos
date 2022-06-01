package com.wekanmdb.storeinventory.ui.availableSlots

data class TimeSlotData (
    val id:Int?=0, val start:String?="", val end:String?="", var selected:Boolean?=true, var slot:Long?=0)