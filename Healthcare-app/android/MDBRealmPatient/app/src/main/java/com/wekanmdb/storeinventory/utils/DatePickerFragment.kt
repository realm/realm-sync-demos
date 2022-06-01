package com.wekanmdb.storeinventory.utils

import android.app.DatePickerDialog
import android.app.Dialog
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.fragment.app.DialogFragment
import java.util.*
import android.app.DatePickerDialog.OnDateSetListener
import com.wekanmdb.storeinventory.R


class DatePickerFragment : DialogFragment() {
    @NonNull
    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        val mCalendar = Calendar.getInstance()
        val year = mCalendar[Calendar.YEAR]
        val month = mCalendar[Calendar.MONTH]
        val dayOfMonth = mCalendar[Calendar.DAY_OF_MONTH]
        val picker =
            DatePickerDialog( requireContext(),
                R.style.CustomCalenderTheme
                ,activity as OnDateSetListener?, year, month, dayOfMonth)

        return picker
    }
}
