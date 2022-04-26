package com.wekanmdb.storeinventory.utils

import android.annotation.SuppressLint
import android.content.Context
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.widget.EditText
import android.widget.Toast
import androidx.lifecycle.MutableLiveData
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.model.job.ProductQuantity
import com.wekanmdb.storeinventory.model.product.Products
import com.wekanmdb.storeinventory.ui.createjobs.JobProduct
import com.wekanmdb.storeinventory.utils.Constants.Companion.VALUE_PRODUCT_SELECT
import io.realm.RealmList
import io.realm.kotlin.where
import org.bson.types.ObjectId
import java.text.DateFormat
import java.text.NumberFormat
import java.text.SimpleDateFormat
import java.util.*
import java.util.regex.Pattern

object UiUtils {

    val EMAIL_PATTERN = Pattern.compile(
        "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
                "\\@" +
                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                "(" +
                "\\." +
                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                ")+"
    )


    fun formattedDate(date: Date?): String? {
        @SuppressLint("SimpleDateFormat") val sdfDate =
            SimpleDateFormat("MMMM-dd-yyyy")
        return sdfDate.format(date)
    }

     fun convertToCustomFormatDate(dateStr: String?): String {
        val utc = TimeZone.getTimeZone("UTC")
        val sourceFormat = SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy")
        val destFormat = SimpleDateFormat("dd-MMM-YYYY")
        sourceFormat.timeZone = utc
        val convertedDate = sourceFormat.parse(dateStr)
        return destFormat.format(convertedDate)
    }

    fun convertToCustomFormatTime(dateStr: String?): String {
        val utc = TimeZone.getTimeZone("UTC")
        val sourceFormat = SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy")
        val destFormat = SimpleDateFormat("hh:mm aa")
        sourceFormat.timeZone = utc
        val convertedDate = sourceFormat.parse(dateStr)
        return destFormat.format(convertedDate)
    }


    fun isValidEmail(email: CharSequence?): Boolean {
        return email != null && EMAIL_PATTERN.matcher(email).matches()
    }

     fun getNumber(stringval: String): Int {
        val format: NumberFormat = NumberFormat.getInstance(Locale.US)
        val number: Number = format.parse(stringval)
        var appNum=number.toInt()
        return appNum

    }

    /**
     * To check if same item is added to lis
     */
    fun itemAlreadyExist(productItem: JobProduct, jobProductList: ArrayList<JobProduct>): Boolean {
       for(item in jobProductList){
           if(item.id.contentEquals(productItem.id)){
               return true
           }
       }
        return false
    }

    /**
     * To make the Realm list with Realm object from wrapper class
     * to use in the createJob.
     */
    fun getRealmProductList(list: ArrayList<JobProduct>): RealmList<ProductQuantity>{
        val productQtyList : RealmList<ProductQuantity> = RealmList()
        val iterator = list.iterator()
        while (iterator.hasNext()){
            val item = iterator.next()
            if(item.id.isNullOrEmpty() || item.id.contentEquals("") || item.id.contentEquals(VALUE_PRODUCT_SELECT)|| item.quantity<=0){
                // not to add
            }
            else {
                 val product = getProductfromrealm(item.id)
                 var ansItem = ProductQuantity()
                  ansItem.product = product
                  ansItem.quantity = item.quantity
                productQtyList.add(ansItem)
            }
        }
        return productQtyList
    }

    private fun getProductfromrealm(id: String): Products? {
        val responseBody = MutableLiveData<Products>()
        val product = apprealm?.where<Products>()?.equalTo("_id", ObjectId(id))?.findFirst()

        return product

    }

    fun showToast(msg: String, context: Context){
        Toast.makeText(context,msg,Toast.LENGTH_SHORT).show()
    }
    fun getDateYYYYmmDD(date: Date?) : String{
        val dateFormat: DateFormat = SimpleDateFormat("yyyy-MM-dd")
        val dateString: String = dateFormat.format(date).toString()
        Log.d("wekanc","Current Date : ${dateString}")
        return dateString
    }


    fun getTimeAmPm(date:Date?) : String{
        val dateFormat: DateFormat = SimpleDateFormat("hh.mm aa")
        val timeString: String = dateFormat.format(date).toString()
        return timeString
    }
    /**
     * Extension function to simplify setting an afterTextChanged action to EditText components.
     */
    fun EditText.afterTextChanged(afterTextChanged: (String) -> Unit) {
        this.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                afterTextChanged.invoke(editable.toString())
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}

            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {}
        })
    }

}



