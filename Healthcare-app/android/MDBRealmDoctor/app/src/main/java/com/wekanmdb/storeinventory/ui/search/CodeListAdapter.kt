package com.wekanmdb.storeinventory.ui.search

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.databinding.SpecialityListItemBinding
import com.wekanmdb.storeinventory.model.code.Code
import io.realm.RealmResults

class CodeListAdapter(val context: Context, var clickListener: (Code) -> Unit) :
    RecyclerView.Adapter<CodeListAdapter.MyViewHolder>() {

    private var codeList: List<Code> = emptyList<Code>()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val binding = SpecialityListItemBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return MyViewHolder(binding)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        with(holder) {
            with(codeList[position]) {

                binding.textView73.text = "  " + this.name

                binding.textView73.setOnClickListener {
                    (context as SearchActivity).updateCode(
                        codeList[absoluteAdapterPosition].name.toString(),
                        codeList[absoluteAdapterPosition]._id.toString(),
                        codeList[absoluteAdapterPosition].code.toString(),
                        codeList[absoluteAdapterPosition].system.toString())

                }
            }
        }
    }


    fun addData(list: RealmResults<Code>?) {
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