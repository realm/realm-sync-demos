package com.wekanmdb.storeinventory.ui.consultation

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.databinding.ItemPastConsultationListBinding
import com.wekanmdb.storeinventory.model.appoinment.Appointment
import com.wekanmdb.storeinventory.model.condition.Condition
import com.wekanmdb.storeinventory.model.encounter.Encounter
import com.wekanmdb.storeinventory.model.organization.Organization
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import com.wekanmdb.storeinventory.utils.UiUtils
import io.realm.kotlin.where
import org.bson.types.ObjectId

class RecyclerUpcomingAdapter(var context: Context) :
    RecyclerView.Adapter<RecyclerUpcomingAdapter.ListViewHolder>() {
    private var itemList: ArrayList<Encounter>? = null
    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): ListViewHolder {
        return ListViewHolder(
            LayoutInflater.from(parent.context)
                .inflate(R.layout.item_past_consultation_list, parent, false)
        )
    }

    override fun onBindViewHolder(holder: ListViewHolder, position: Int) {
        val binding: ItemPastConsultationListBinding = holder.getBinding()
        with(holder) {
            with(itemList?.get(position)) {
                val getHospital = getHospital(this?.serviceProvider?.identifier)
                this?.appointment?._id?.let {
                    getDoctor(
                        it,
                        binding.textviewDoctorName,
                        binding.slotText
                    )
                }
                val concern = getCondition(this?.appointment?.reasonReference?.identifier)
                binding.textviewConcernName.text = concern?.code?.text
                binding.textHospitalName.text = getHospital?.name
                if (getHospital?.photo?.isNotEmpty() == true) {
                    UiUtils.setImageInRecycler(context,getHospital.photo.first()?.url,binding.imageHospital)
                }
            }
        }
        /*
        *On item click
        * passing the data to another activity
        * params Organization name,concern,slot,slot date */
        holder.itemView.setOnClickListener {
            val consultationIntent = Intent(context, ConsultationDetailActivity::class.java)
            ConsultationDetailActivity.orgId =
                itemList?.get(position)?.serviceProvider?.identifier!!
            ConsultationDetailActivity.encounterID = itemList?.get(position)?._id!!
            ConsultationDetailActivity.conditionID =
                itemList?.get(position)?.appointment?.reasonReference?.identifier!!

            if (itemList?.get(position)?.participant?.isNotEmpty() == true) {
                ConsultationDetailActivity.doctorId =
                    itemList?.get(position)?.participant?.first()?.individual?.identifier!!
            }
            consultationIntent.putExtra("Org_Name", binding.textHospitalName.text.toString())
            consultationIntent.putExtra("Concern", binding.textviewConcernName.text.toString())
            consultationIntent.putExtra("Slot", binding.textviewConcernName.text.toString())
            consultationIntent.putExtra(
                "SlotDate",
                itemList?.get(position)?.appointment?.start.toString()
            )
            context.startActivity(consultationIntent)
        }

    }

    //Getting particular condition based on Object id
    private fun getCondition(id: ObjectId?): Condition? {
        return apprealm?.where<Condition>()?.equalTo("_id", id)?.findFirst()
    }

    fun addData(list: ArrayList<Encounter>) {
        if (list.isNotEmpty()) {
            this.itemList = list
            notifyDataSetChanged()
        }
    }

    override fun getItemCount(): Int {
        return itemList?.size ?: 0
    }

    private fun getOrg(searchedItem: ObjectId?): Encounter? {
        return apprealm?.where<Encounter>()?.equalTo("_id", searchedItem)?.findFirst()
    }

    //Getting Particular organization by passing orgid
    private fun getHospital(id: ObjectId?): Organization? {
        return apprealm?.where<Organization>()?.equalTo("_id", id)?.findFirst()
    }


    private fun getDoctor(
        _id: ObjectId,
        textviewDoctorName: TextView,
        slotText: TextView
    ) {

        val result =
            apprealm?.where<Appointment>()?.equalTo("_id", _id)?.findFirst()
        slotText.text = UiUtils.getDateYYYYmmDD(result?.start)
        result?.participant?.forEach {

            val practitionerRole = apprealm?.where<PractitionerRole>()
                ?.equalTo("practitioner._id", it.actor?.identifier)
                ?.equalTo("code.coding.code", "doctor")?.findFirst()
            if (practitionerRole != null) {
                textviewDoctorName.text = "Dr." + practitionerRole.practitioner?.name?.text

            }
        }
    }

    inner class ListViewHolder(view: View) : RecyclerView.ViewHolder(view), View.OnClickListener {
        private var binding: ItemPastConsultationListBinding? = null

        init {
            binding = DataBindingUtil.bind(itemView)
            itemView.setOnClickListener(this)
        }

        fun getBinding(): ItemPastConsultationListBinding {
            return binding!!
        }

        override fun onClick(p0: View?) {

        }
    }

}