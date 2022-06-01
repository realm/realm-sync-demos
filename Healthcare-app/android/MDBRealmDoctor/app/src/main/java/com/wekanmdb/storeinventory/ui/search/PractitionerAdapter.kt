package com.wekanmdb.storeinventory.ui.search

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.databinding.SpecialityListItemBinding
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import io.realm.RealmResults

class PractitionerAdapter(val context: Context, var clickListener: (PractitionerRole) -> Unit) :
    RecyclerView.Adapter<PractitionerAdapter.MyViewHolder>() {

    private var codeList: List<PractitionerRole> = emptyList<PractitionerRole>()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val binding = SpecialityListItemBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return MyViewHolder(binding)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        with(holder) {
            with(codeList[position]) {

                binding.textView73.text = "  " + this.practitioner?.name?.text

                binding.textView73.setOnClickListener {
                    (context as SearchActivity).updatePractitioner(
                        codeList[absoluteAdapterPosition].practitioner?.name?.text.toString(),
                        codeList[absoluteAdapterPosition].practitioner?._id.toString(),codeList[absoluteAdapterPosition].practitioner?.identifier.toString())

                }
            }
        }
    }


    fun addData(list: RealmResults<PractitionerRole>?) {
        if (list != null) {
            this.codeList = list
        }
        notifyDataSetChanged()
    }

    override fun getItemCount(): Int {
        return codeList.size
    }

    inner class MyViewHolder(val binding: SpecialityListItemBinding) :
        RecyclerView.ViewHolder(binding.root)
}