package com.wekanmdb.storeinventory.ui.signup

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.databinding.StoresListItemBinding
import com.wekanmdb.storeinventory.model.store.Stores
import com.wekanmdb.storeinventory.ui.signup.SignupActivity.Companion.selectedItems

class StoresListAdapter(val context: Context, var clickListener: (Stores) -> Unit) :
    RecyclerView.Adapter<StoresListAdapter.MyViewHolder>() {

    private var storeList: List<Stores> = emptyList<Stores>()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val binding = StoresListItemBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return MyViewHolder(binding)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        with(holder) {
            with(storeList[position]) {

                binding.textView73.text = "  " + this.name
                binding.textView73.isChecked = selectedItems.contains(this)

                binding.textView73.setOnClickListener {
                    if(selectedItems.contains(this) ) selectedItems.remove(this) else selectedItems.add(this)


                    clickListener(this)
                    notifyDataSetChanged()
                }
            }
        }
    }


    fun addData(list: List<Stores>) {
        this.storeList = list
        notifyDataSetChanged()
    }

    override fun getItemCount(): Int {
        return storeList.size
    }

    inner class MyViewHolder(val binding: StoresListItemBinding) :
        RecyclerView.ViewHolder(binding.root)
}