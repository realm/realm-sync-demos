package com.wekanmdb.storeinventory.ui.prescription

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.databinding.MedicationItemBinding
import com.wekanmdb.storeinventory.model.embededclass.Coding
import io.realm.RealmList

class MedicationAdapter(val context: Context,val isMedication: Boolean, var clickListener: (Coding) -> Unit) :
    RecyclerView.Adapter<MedicationAdapter.MyViewHolder>() {

    private var codingList: List<Coding> = arrayListOf()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val binding = MedicationItemBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return MyViewHolder(binding)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        with(holder) {
            with(codingList[position]) {

                binding.textView40.text = display
                if(isMedication){
                    binding.imageView17.visibility=View.GONE
                    binding.view.visibility=View.GONE
                }
                binding.imageView17.setOnClickListener {
                    clickListener(this)
                }

            }
        }

    }


    fun addData(list: RealmList<Coding>) {
        if (list != null) {
            this.codingList = list
        }
        notifyDataSetChanged()
    }

    override fun getItemCount(): Int {
        return codingList.size
    }

    inner class MyViewHolder(val binding: MedicationItemBinding) :
        RecyclerView.ViewHolder(binding.root)
}