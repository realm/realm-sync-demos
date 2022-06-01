package com.wekanmdb.storeinventory.ui.availableSlots

import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.R


class RecyclerViewAdapterTimeSlots(var context: Context) :
    RecyclerView.Adapter<RecyclerViewAdapterTimeSlots.ListViewHolder>() {

    lateinit var itemList: MutableList<TimeSlotData>
    var timeAllList: MutableList<String>? = null
    private var timeslotsBookedList: MutableList<Long>? = null
    var selectedPosition = -1

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): ListViewHolder {

        return ListViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.item_time_slots, parent, false)
        )
    }

    override fun onBindViewHolder(holder: ListViewHolder, position: Int) {

        with(holder) {
            with(itemList[position]) {
                holder.name.text = this.start
                holder.setItem(this.start.toString())
                //This loop used to set bg color gery of already booked slot and clickable is false
                timeslotsBookedList?.forEach {
                    if (it.toInt().dec() == position) {
                        holder.name.setBackgroundColor(Color.parseColor("#828282"))
                        holder.itemView.isEnabled = false
                        holder.itemView.isClickable = false
                        itemList[position].selected = false
                    }
                }

            }
        }
    }

    fun addData(
        list: MutableList<TimeSlotData>,
        timeslots: MutableList<String>,
        timeslotsBookedList: MutableList<Long>
    ) {
        this.itemList = list
        this.timeAllList = timeslots
        this.timeslotsBookedList = timeslotsBookedList
        notifyDataSetChanged()
    }

    override fun getItemCount(): Int {
        return itemList.size ?: 0
    }

    inner class ListViewHolder(view: View) : RecyclerView.ViewHolder(view), View.OnClickListener {
        var name: TextView = view.findViewById(R.id.textview_card_timeslot)

        init {
            itemView.setOnClickListener(this)
        }

        override fun onClick(view: View?) {
            selectedPosition = absoluteAdapterPosition
            (context as AvailableSlotActivity).updateSlot(
                itemList[absoluteAdapterPosition].start.toString(),
                itemList[absoluteAdapterPosition].end.toString(),
                itemList[absoluteAdapterPosition].id?.toLong()
            )
            notifyDataSetChanged()
        }

        fun setItem(item: String) {
            if (selectedPosition == absoluteAdapterPosition) {
                name.setBackgroundColor(context.getColor(R.color.app_new_color))
            } else {
                name.setBackgroundColor(context.getColor(R.color.white))
            }
            name.text = item

        }
    }

}

