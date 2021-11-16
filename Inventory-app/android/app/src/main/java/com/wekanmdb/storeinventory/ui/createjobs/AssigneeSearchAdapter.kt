package com.wekanmdb.storeinventory.ui.createjobs

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.databinding.AssigneeItemBinding
import com.wekanmdb.storeinventory.model.user.Users
import io.realm.RealmList
import io.realm.RealmResults
/**
 * This Adapter is used to hold actual users Assignee item from realm
 * while searching in Search Activity.
 */

class AssigneeSearchAdapter(var context: Context): RecyclerView.Adapter<AssigneeSearchAdapter.AssigneeSearchViewHolder>(){

    private  var assigneeList: RealmList<Users>
    init {
        assigneeList = RealmList<Users>()
    }
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): AssigneeSearchViewHolder {
        return AssigneeSearchViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.assignee_item, parent, false)
        )
    }

    override fun onBindViewHolder(holder: AssigneeSearchViewHolder, position: Int) {
        val item: Users = assigneeList.get(position)!!
        val binding: AssigneeItemBinding = holder.getBinding()
        binding.users = item
    }


    fun addData(ans: RealmResults<Users>){
        if(assigneeList==null){
            return
        }
        assigneeList.clear()
        assigneeList.addAll(ans)
        notifyDataSetChanged()
    }
    override fun getItemCount(): Int {
        return assigneeList.size
    }

    inner  class AssigneeSearchViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView),View.OnClickListener{
        private var binding: AssigneeItemBinding? = null

        init {
            binding = DataBindingUtil.bind(itemView)
            itemView.setOnClickListener(this)
        }

        fun getBinding(): AssigneeItemBinding {
            return binding!!
        }


        override fun onClick(v: View?) {
            (context as SearchActivity).updateAssignee(assigneeList.get(absoluteAdapterPosition)?.firstName.toString(),assigneeList.get(absoluteAdapterPosition)?._id.toString())
        }

    }


}