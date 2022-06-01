package com.wekanmdb.storeinventory.utils

import android.app.Dialog
import android.app.TimePickerDialog
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.fragment.app.DialogFragment
import com.wekanmdb.storeinventory.R
import java.util.*

class TimePickerFragment : DialogFragment(){
    @NonNull
    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        val c: Calendar = Calendar.getInstance()
        val hour = c.get(Calendar.HOUR_OF_DAY)
        val minute = c.get(Calendar.MINUTE)
        return TimePickerDialog(
            activity,
            R.style.CustomCalenderTheme,
            getActivity() as TimePickerDialog.OnTimeSetListener,
            hour,
            minute,
           false
        )
    }
}