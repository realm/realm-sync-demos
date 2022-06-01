package com.wekanmdb.storeinventory.ui.listOfHospitals

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.databinding.ItemHospitalBinding
import com.wekanmdb.storeinventory.model.organization.Organization
import com.wekanmdb.storeinventory.ui.hospital.HospitalActivity
import com.wekanmdb.storeinventory.utils.Constants.Companion.Hospital_Address
import com.wekanmdb.storeinventory.utils.Constants.Companion.Hospital_Desc
import com.wekanmdb.storeinventory.utils.Constants.Companion.Hospital_Name
import com.wekanmdb.storeinventory.utils.Constants.Companion.Hospital_Photo
import com.wekanmdb.storeinventory.utils.Constants.Companion.Hospital_Spec
import com.wekanmdb.storeinventory.utils.Constants.Companion.Org_Id
import com.wekanmdb.storeinventory.utils.UiUtils

//Adapter for list of hospitals
class RecyclerAdapterListOfHospitals(var context: Context) :
    RecyclerView.Adapter<RecyclerAdapterListOfHospitals.ListViewHolder>() {
    private var itemList: List<Organization>? = null
    private var photoList: ArrayList<String>? = ArrayList()
    private var url: String? = null
    private var id: String? = null
    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): ListViewHolder {
        return ListViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.item_hospital, parent, false)
        )
    }

    override fun onBindViewHolder(holder: ListViewHolder, position: Int) {
        val binding: ItemHospitalBinding = holder.getBinding()
        if (itemList?.get(position)?.address?.isNotEmpty() == true) {
            val city = itemList?.get(position)?.address?.first()?.city
            val state = itemList?.get(position)?.address?.first()?.state
            val country = itemList?.get(position)?.address?.first()?.country
            binding.textviewLocation.text = String.format("$city , $state,$country")
        }
        if (itemList?.get(position)?.address?.first()?.line?.isNotEmpty() == true) {
            binding.textHospitalDescription.text =
                itemList?.get(position)?.address?.first()?.line?.first().toString()
        }
        with(holder) {
            with(itemList?.get(position)) {
                binding.listhospitals = this
                binding.textHospitalName.text = this?.name.toString()
                if (this?.photo?.isNotEmpty() == true) {
                    UiUtils.setImageInRecycler(context,this.photo.first()?.url,binding.imageHospital)
                }
            }
        }
    }

    fun addData(list: List<Organization>?) {
        if (list?.isNotEmpty() == true) {
            this.itemList = list
            notifyDataSetChanged()
        }
    }

    override fun getItemCount(): Int {
        return itemList?.size ?: 0
    }

    inner class ListViewHolder(view: View) : RecyclerView.ViewHolder(view), View.OnClickListener {
        private var binding: ItemHospitalBinding? = null

        init {
            binding = DataBindingUtil.bind(itemView)
            itemView.setOnClickListener(this)
        }

        fun getBinding(): ItemHospitalBinding {
            return binding!!
        }

        override fun onClick(p0: View?) {
            //getting list of images based on position
            val photoLists = itemList?.get(absoluteAdapterPosition)?.photo
            //Adding the url in arraylist
            photoLists?.forEach {
                it.url?.let { it1 -> photoList?.add(it1) }
            }
            //getting Organization id based on position
            id = itemList?.get(absoluteAdapterPosition)?._id.toString()
            /*
            * passing data in intents
            * params Hospital Name,Address,speciality,Description,list of Images,ID*/
            val hospitalIntent = Intent(context, HospitalActivity::class.java)
            hospitalIntent.putExtra(
                Hospital_Name,
                itemList?.get(absoluteAdapterPosition)?.name.toString()
            )
            if (itemList?.get(absoluteAdapterPosition)?.type?.coding?.isNotEmpty() == true) {
                hospitalIntent.putExtra(
                    Hospital_Address,
                    itemList?.get(absoluteAdapterPosition)?.type?.coding?.first()?.display
                )
            }
            hospitalIntent.putExtra(
                Hospital_Spec,
                itemList?.get(absoluteAdapterPosition)?.type?.text
            )
            hospitalIntent.putExtra(Hospital_Desc, binding?.textviewLocation?.text.toString())
            hospitalIntent.putStringArrayListExtra(Hospital_Photo, photoList)
            hospitalIntent.putExtra(Org_Id, id)
            context.startActivity(hospitalIntent)
        }
    }
}

