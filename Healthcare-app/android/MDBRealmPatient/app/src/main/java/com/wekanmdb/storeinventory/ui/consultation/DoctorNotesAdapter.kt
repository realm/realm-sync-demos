package com.wekanmdb.storeinventory.ui.consultation

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.databinding.RecyclerTextviewItemBinding

class DoctorNotesAdapter(val context: Context) :
    RecyclerView.Adapter<DoctorNotesAdapter.MyViewHolder>() {

    private var codeList: MutableList<String> = ArrayList()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val binding = RecyclerTextviewItemBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return MyViewHolder(binding)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        with(holder) {
            with(codeList[position]) {
                binding.textView.text = this
            }
        }
    }


    fun addData(list: MutableList<String>?) {
        if (list != null) {
            this.codeList = list
        }
        notifyDataSetChanged()
    }

    override fun getItemCount(): Int {
        return codeList.size
    }

    inner class MyViewHolder(val binding: RecyclerTextviewItemBinding) :
        RecyclerView.ViewHolder(binding.root)
}