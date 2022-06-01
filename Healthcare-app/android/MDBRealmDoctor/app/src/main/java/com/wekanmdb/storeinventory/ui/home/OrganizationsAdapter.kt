package com.wekanmdb.storeinventory.ui.home

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.wekanmdb.storeinventory.databinding.HospitalListItemsBinding
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import io.realm.RealmResults

class OrganizationsAdapter(val context: Context, var clickListener: (PractitionerRole) -> Unit) :
    RecyclerView.Adapter<OrganizationsAdapter.MyViewHolder>() {

    private var practionarList: List<PractitionerRole> = emptyList<PractitionerRole>()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val binding = HospitalListItemsBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return MyViewHolder(binding)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        with(holder) {
            with(practionarList[position]) {

                binding.textView6.text = "  " + this.organization?.name?.trim()
                binding.textView7.text =
                    "  " + this.organization?.address?.first()?.city + "," + this.organization?.address?.first()?.state
                binding.textView8.text = "  " + this.organization?.type?.text

                Glide.with(context)
                    .load(this.organization?.photo?.first()?.url).fitCenter()
                    .into(binding.imageView3)
                binding.root.setOnClickListener {
                    clickListener(this)
                }
            }
        }

    }


    fun addData(list: List<PractitionerRole>?) {
        if (list != null) {
            this.practionarList = list
        }
        notifyDataSetChanged()
    }

    override fun getItemCount(): Int {
        return practionarList.size
    }

    inner class MyViewHolder(val binding: HospitalListItemsBinding) :
        RecyclerView.ViewHolder(binding.root)
}