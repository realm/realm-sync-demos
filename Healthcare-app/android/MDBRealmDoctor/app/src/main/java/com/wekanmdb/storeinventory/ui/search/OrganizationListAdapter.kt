package com.wekanmdb.storeinventory.ui.search

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.databinding.OrganizationListItemBinding
import com.wekanmdb.storeinventory.model.organization.Organization
import com.wekanmdb.storeinventory.ui.signup.OrganizationUpdateActivity.Companion.selectedItems

class OrganizationListAdapter(val context: Context, var clickListener: (Organization) -> Unit) :
    RecyclerView.Adapter<OrganizationListAdapter.MyViewHolder>() {

    private var storeList: List<Organization> = emptyList<Organization>()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val binding = OrganizationListItemBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return MyViewHolder(binding)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        with(holder) {
            with(storeList[position]) {

                binding.textView73.text = "  " + this.name?.trim()
                binding.textView73.isChecked = selectedItems.contains(this)

                binding.textView73.setOnClickListener {
                    if(selectedItems.contains(this) ) selectedItems.remove(this) else selectedItems.add(this)


                    clickListener(this)
                    notifyDataSetChanged()
                }
            }
        }
    }


    fun addData(list: List<Organization>) {
        this.storeList = list
        notifyDataSetChanged()
    }

    override fun getItemCount(): Int {
        return storeList.size
    }

    inner class MyViewHolder(val binding: OrganizationListItemBinding) :
        RecyclerView.ViewHolder(binding.root)
}