package com.wekanmdb.storeinventory.utils

import android.annotation.SuppressLint
import android.content.Context
import android.text.Editable
import android.text.TextWatcher
import android.util.Base64
import android.util.Log
import android.widget.EditText
import android.widget.ImageView
import android.widget.Toast
import com.bumptech.glide.Glide
import com.wekanmdb.storeinventory.ui.patientBasicInfo.ConditionModel
import java.text.DateFormat
import java.text.NumberFormat
import java.text.ParseException
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
            SimpleDateFormat("MMMM-dd-yyyy hh:mm")
        return sdfDate.format(date)
    }

    fun getDateFormat(date: Date?): String? {
        return SimpleDateFormat("dd/MM/yyyy").format(date)
    }

    fun getFormattedDate(time: String): String? {
        var formattedDate: String? = time
        val readFormat: DateFormat = SimpleDateFormat("hh:mm", Locale.getDefault())
        val writeFormat: DateFormat = SimpleDateFormat("hh:mm a", Locale.getDefault())
        var date: Date? = null

        try {
            date = readFormat.parse(time)
        } catch (e: ParseException) {
        }
        if (date != null) {
            formattedDate = writeFormat.format(date)
        }
        Log.e("msg", formattedDate.toString())
        return formattedDate
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
        var appNum = number.toInt()
        return appNum

    }


    fun showToast(msg: String, context: Context) {
        Toast.makeText(context, msg, Toast.LENGTH_SHORT).show()
    }

    fun getDateYYYYmmDD(date: Date?): String {
        val dateFormat: DateFormat = SimpleDateFormat("dd-MM-yyyy hh:mm a")
        val dateString: String = dateFormat.format(date).toString()
        Log.d("wekanc", "Current Date : ${dateString}")
        return dateString
    }


    fun getTimeAmPm(date: Date?): String {
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

    //checking if the condition is already exist in the list
    fun itemAlreadyExist(conditionItem: ConditionModel, conditionList: ArrayList<String>): Boolean {
        for (item in conditionList) {
            if (item.contentEquals(conditionItem.condition) && conditionList.size >= 1) {
                return true
            }
        }
        return false
    }

    fun getDateTime(string: String): Date? {
        val simpleDateTime = SimpleDateFormat("MM-dd-yyyy hh:mm a")
        return simpleDateTime.parse(string)
    }

    fun setDateTime(date: Date?): Date? {
        val simpleDateTime = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        val sdf = simpleDateTime.format(date)
        return simpleDateTime.parse(sdf)
    }

    fun setImageInRecycler(context: Context,url: String?, imageHospital: ImageView) {
        Glide.with(context)
            .asBitmap()
            .load(url).fitCenter()
            .into(imageHospital)
    }
    fun setImageInBitmapRecycler(context: Context,url: String?, imageHospital: ImageView) {
        Glide.with(context)
            .asBitmap()
            .load(Base64.decode(url, Base64.DEFAULT))
            .into(imageHospital)
    }
}



