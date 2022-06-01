package com.wekanmdb.storeinventory.ui.signup

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.databinding.OrganizationListItemBinding
import com.wekanmdb.storeinventory.databinding.SelectedHospitalItemBinding
import com.wekanmdb.storeinventory.model.organization.Organization
import com.wekanmdb.storeinventory.ui.signup.OrganizationUpdateActivity.Companion.selectedItems

class SelectedOrganizationListAdapter(val context: Context, var clickListener: (Organization) -> Unit) :
    RecyclerView.Adapter<SelectedOrganizationListAdapter.MyViewHolder>() {

    private var storeList: List<Organization> = emptyList<Organization>()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val binding = SelectedHospitalItemBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return MyViewHolder(binding)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        with(holder) {
            with(storeList[position]) {

                binding.textView40.text = "  " + this.name?.trim()
                binding.imageView17.setOnClickListener {
                    selectedItems.remove(this)
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

    inner class MyViewHolder(val binding: SelectedHospitalItemBinding) :
        RecyclerView.ViewHolder(binding.root)
}