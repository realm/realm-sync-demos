package com.wekanmdb.storeinventory.ui.createjobs

/**
 * This is a wrapper class used for adding product items
 * & binding with adapter to show how many Product items are added to create Jobs.
 */
data class JobProduct(var id: String, var quantity: Int, var name : String, var totalQuantity: Int)
