package com.wekanmdb.storeinventory.ui.patientBasicInfo

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.lifecycle.MutableLiveData
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.app.apprealm
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.databinding.ItemPatientIllnessListBinding
import com.wekanmdb.storeinventory.model.condition.Condition
import io.realm.RealmResults
import io.realm.kotlin.where
import org.bson.types.ObjectId

class RecyclerAddIllnessList(var context: Context) :
    RecyclerView.Adapter<RecyclerAddIllnessList.ListViewHolder>() {
    private var itemList: ArrayList<ConditionModel>? = null
    val conditionResponseBody = MutableLiveData<RealmResults<Condition>?>()
    val id = user?.customData?.get("referenceId") as ObjectId

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): ListViewHolder {
        val binding = ItemPatientIllnessListBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return ListViewHolder(binding)
    }

    override fun onBindViewHolder(holder: RecyclerAddIllnessList.ListViewHolder, position: Int) {
        with(holder) {
            with(itemList?.get(position)) {
                binding.text = this
                binding.textIllnessCondition.text = this?.condition.toString()
                binding.textviewNotes.text = this?.notes.toString()
                binding.imageviewDelete.setOnClickListener {
                    itemList?.forEach {
                        if (it.condition == binding.textIllnessCondition.text) {
                            itemList!!.removeAt(position)
                            removeCondition(binding.textIllnessCondition.text.toString())
                            notifyDataSetChanged()
                        }
                    }
                }
            }
        }
    }

    fun addData(list: ArrayList<ConditionModel>) {
        this.itemList = list
        notifyDataSetChanged()
    }

    override fun getItemCount(): Int {
        return itemList?.size ?: 0
    }

    inner class ListViewHolder(val binding: ItemPatientIllnessListBinding) :
        RecyclerView.ViewHolder(binding.root)

    fun removeCondition(toString: String) {
        apprealm?.executeTransaction { realm ->
            val conditionList = realm.where<Condition>()
                .equalTo("subject.identifier", user?.customData?.get("referenceId") as ObjectId)
                .findAll()
            conditionList?.forEach {
                if (it.isValid) {
                    if (it.code?.coding!!.isNotEmpty()) {
                        if (it?.code?.coding?.first()?.display.equals(toString)) {
                            it.deleteFromRealm()
                        }
                    }
                }
            }
        }
    }

}