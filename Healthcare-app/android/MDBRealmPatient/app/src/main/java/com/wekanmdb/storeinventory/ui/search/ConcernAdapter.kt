package com.wekanmdb.storeinventory.ui.search

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.databinding.ItemPatientIllnessListBinding
import com.wekanmdb.storeinventory.model.condition.Condition
import io.realm.RealmResults

class ConcernAdapter(val context: Context, var clickListener: (Condition) -> Unit) :
    RecyclerView.Adapter<ConcernAdapter.MyViewHolder>() {

    private var codeList: List<Condition> = emptyList<Condition>()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val binding = ItemPatientIllnessListBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return MyViewHolder(binding)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        with(holder) {
            with(codeList[position]) {

                binding.textIllnessCondition.text = "  " + this.code?.text
                binding.textviewNotes.text = "  " + this.notes
                binding.imageviewDelete.isVisible = false
                holder.itemView.setOnClickListener {
                    (context as SearchActivity).updateConcern(
                        codeList[absoluteAdapterPosition].code?.text.toString(),
                        codeList[absoluteAdapterPosition].notes.toString(),
                        codeList[absoluteAdapterPosition]._id.toString()
                    )
                }
            }
        }
    }


    fun addData(list: RealmResults<Condition>?) {
        if (list != null) {
            this.codeList = list
        }
        notifyDataSetChanged()
    }

    override fun getItemCount(): Int {
        return codeList.size
    }

    inner class MyViewHolder(val binding: ItemPatientIllnessListBinding) :
        RecyclerView.ViewHolder(binding.root)
}