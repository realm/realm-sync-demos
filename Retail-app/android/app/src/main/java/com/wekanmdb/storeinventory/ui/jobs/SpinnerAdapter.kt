package com.wekanmdb.storeinventory.ui.jobs

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.TextView
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.model.job.Jobs

class SpinnerAdapter(val context: Context, var jobsList: MutableList<String>) : BaseAdapter() {

    private val inflater: LayoutInflater = context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater




    override fun getCount(): Int {
        return jobsList.size
        }

    override fun getItem(position: Int): String {
        return jobsList[position]
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        val view: View
        val vh: ItemHolder
        if (convertView == null) {
            view = inflater.inflate(R.layout.spinner_item, parent, false)
            vh = ItemHolder(view)
            view?.tag = vh
        } else {
            view = convertView
            vh = view.tag as ItemHolder
        }
        vh.label.text = jobsList[position]

        return view
    }
    private class ItemHolder(row: View?) {
        val label: TextView = row?.findViewById(R.id.tv1) as TextView

    }

}