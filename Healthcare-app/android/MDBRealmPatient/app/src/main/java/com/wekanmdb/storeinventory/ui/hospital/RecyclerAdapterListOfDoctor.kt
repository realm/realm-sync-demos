package com.wekanmdb.storeinventory.ui.hospital

import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.util.Base64
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.databinding.ItemDoctorDetailsBinding
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import com.wekanmdb.storeinventory.ui.doctorInfo.DoctorInfoActivity
import com.wekanmdb.storeinventory.utils.Constants.Companion.Doctor_About
import com.wekanmdb.storeinventory.utils.Constants.Companion.Doctor_EndTime
import com.wekanmdb.storeinventory.utils.Constants.Companion.Doctor_Image
import com.wekanmdb.storeinventory.utils.Constants.Companion.Doctor_Name
import com.wekanmdb.storeinventory.utils.Constants.Companion.Doctor_Spec
import com.wekanmdb.storeinventory.utils.Constants.Companion.Doctor_Time
import com.wekanmdb.storeinventory.utils.Constants.Companion.Org_Id
import io.realm.RealmResults
import org.bson.types.ObjectId


class RecyclerAdapterListOfDoctor(var context: Context) :
    RecyclerView.Adapter<RecyclerAdapterListOfDoctor.ListViewHolder>() {
    private var itemList: RealmResults<PractitionerRole>? = null
    var orgId: ObjectId? = null
    private var photoList: ArrayList<String>? = ArrayList()
    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): ListViewHolder {
        return ListViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.item_doctor_details, parent, false)
        )
    }

    override fun onBindViewHolder(holder: ListViewHolder, position: Int) {
        var url: String = ""
        val binding: ItemDoctorDetailsBinding = holder.getBinding()
        if (itemList?.get(position)?.practitioner?.photo?.isNotEmpty() == true) {
            url = itemList?.get(position)?.practitioner?.photo?.first()?.data.toString()
        }
        with(holder) {
            with(itemList?.get(position)) {
                binding.listDoctor = this
                binding.textView.text = this?.practitioner?.name?.text.toString()
                binding.textviewSpeciality.text = this?.practitioner?.about.toString()
                binding.textviewSpecialityTitlw.text = this?.specialty?.text.toString()

                if (url.isNotEmpty()) {
                    // decode base64 string
                    val bytes: ByteArray = Base64.decode(url, Base64.DEFAULT)
                    // Initialize bitmap
                    val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
                    // set bitmap on imageView
                    binding.imageHospital.setImageBitmap(bitmap)
                }
            }
        }
    }

    fun addData(list: RealmResults<PractitionerRole>, orgId: ObjectId?) {
        if (list.isNotEmpty()) {
            this.itemList = list
            this.orgId = orgId
            notifyDataSetChanged()
        }
    }

    override fun getItemCount(): Int {
        return itemList?.size ?: 0
    }

    inner class ListViewHolder(view: View) : RecyclerView.ViewHolder(view), View.OnClickListener {
        private var binding: ItemDoctorDetailsBinding? = null

        init {
            binding = DataBindingUtil.bind(itemView)
            itemView.setOnClickListener(this)
        }

        fun getBinding(): ItemDoctorDetailsBinding {
            return binding!!
        }

        override fun onClick(p0: View?) {
            val photoLists = itemList?.get(absoluteAdapterPosition)?.practitioner?.photo
            photoLists?.forEach {
                it.data?.let { it1 -> photoList?.add(it1) }
            }
            /*
            * Start Activity on Click and Pass data
            * data Doctor Name,Speciality,About,List of Doctor Image,ID,Org ID,Start and End Time*/
            val doctorIntent = Intent(context, DoctorInfoActivity::class.java)
            doctorIntent.putExtra(Doctor_Name, binding?.textView?.text.toString())
            doctorIntent.putExtra(Doctor_Spec, binding?.textviewSpecialityTitlw?.text.toString())
            doctorIntent.putExtra(
                Doctor_About,
                itemList?.get(absoluteAdapterPosition)?.practitioner?.about?.toString()
            )
            doctorIntent.putStringArrayListExtra(Doctor_Image, photoList)
            doctorIntent.putExtra(
                Doctor_Time,
                itemList?.get(absoluteAdapterPosition)?.availableTime?.availableStartTime.toString()
            )
            doctorIntent.putExtra(
                Doctor_EndTime,
                itemList?.get(absoluteAdapterPosition)?.availableTime?.availableEndTime.toString()
            )
            DoctorInfoActivity.doctorId = itemList?.get(absoluteAdapterPosition)?.practitioner?._id
            DoctorInfoActivity.doctorIdentifier = itemList?.get(absoluteAdapterPosition)?.practitioner?.identifier
            doctorIntent.putExtra(Org_Id, orgId)
            context.startActivity(doctorIntent)
        }
    }

}
