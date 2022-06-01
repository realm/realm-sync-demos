package com.wekanmdb.storeinventory.ui.consultation

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.databinding.ConsultationListItemBinding
import com.wekanmdb.storeinventory.model.appoinment.Appointment
import com.wekanmdb.storeinventory.model.condition.Condition
import com.wekanmdb.storeinventory.model.encounter.Encounter
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import com.wekanmdb.storeinventory.utils.Constants.Companion.DOCTOR
import io.realm.kotlin.where
import org.bson.types.ObjectId

class ConsultationAdapter(val context: Context, var clickListener: (Encounter,String,String,String) -> Unit) :
    RecyclerView.Adapter<ConsultationAdapter.MyViewHolder>() {

    private var consultationsList: List<Encounter> = emptyList<Encounter>()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val binding = ConsultationListItemBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return MyViewHolder(binding)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        with(holder) {
            with(consultationsList[position]) {

                binding.textView42.text = this.subject?.name?.text
               val illness= getCondition(this.appointment?.reasonReference?.identifier )
                binding.textView43.text = "Illness/ Condition - " + illness?.code?.text
                binding.textView44.text = "Current Medications -" + illness?.notes
                this.appointment?._id?.let { getDoctor(it, binding.textView46,binding.textView47) }
                val concern= getCondition(this.appointment?.reasonReference?.identifier)
                binding.textView45.text="Concern - "+concern?.code?.text
                binding.root.setOnClickListener {
                    clickListener(this, binding.textView43.text.toString(),binding.textView46.text.toString() ,binding.textView47.text.toString() )

                }
            }
        }

    }


    fun addData(list: List<Encounter>?) {
        if (list != null) {
            this.consultationsList = list
        }else{
            this.consultationsList= listOf()
        }
        notifyDataSetChanged()
    }

    override fun getItemCount(): Int {
        return consultationsList.size
    }

    private fun getCondition(_id: ObjectId?): Condition? {
        return apprealm?.where<Condition>()?.equalTo("_id", _id)?.findFirst()


    }

    private fun getDoctor(_id: ObjectId, doctorName: TextView, textView47: TextView) {

        val result =
            apprealm?.where<Appointment>()?.equalTo("_id", _id)?.findFirst()
        if (result != null) {
            result.participant?.forEach {

             val  practitionerRole=  apprealm?.where<PractitionerRole>()?.equalTo("practitioner._id", it.actor?.identifier)
                    ?.equalTo("code.coding.code", DOCTOR)?.findFirst()
                if(practitionerRole!=null){
                    doctorName.text="Dr."+practitionerRole.practitioner?.name?.text
                    textView47.text=practitionerRole.practitioner?._id.toString()
                }
            }
        }


    }

    inner class MyViewHolder(val binding: ConsultationListItemBinding) :
        RecyclerView.ViewHolder(binding.root)
}