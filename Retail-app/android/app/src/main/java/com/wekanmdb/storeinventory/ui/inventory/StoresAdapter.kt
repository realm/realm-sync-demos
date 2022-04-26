package com.wekanmdb.storeinventory.ui.inventory

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.databinding.SwapeStoreItemBinding
import com.wekanmdb.storeinventory.model.store.Stores

class StoresAdapter(val context: Context,var clickListener: (Stores) -> Unit) : RecyclerView.Adapter<StoresAdapter.MyViewHolder>(){

    private  var storeList: List<Stores> = emptyList<Stores>()
    private var selectedStore: Stores? = null
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val binding = SwapeStoreItemBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return MyViewHolder(binding)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        with(holder){
            with(storeList[position]){

                binding.textView73.text="  "+ this.name

                binding.textView73.setOnClickListener {

                    clickListener(this)
                    selectedStore=this
                    notifyDataSetChanged()
                }
                (selectedStore!=null && selectedStore!!._id==this._id).let {  binding.textView73.isChecked=it }
            }
        }
    }


    fun addData(list: List<Stores>, selectedStore: Stores?){
        this.storeList = list
        this.selectedStore=selectedStore
        notifyDataSetChanged()
    }
    override fun getItemCount(): Int {
        return storeList.size
    }

    inner  class MyViewHolder(val binding: SwapeStoreItemBinding) : RecyclerView.ViewHolder(binding.root)
}