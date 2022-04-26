package com.wekanmdb.storeinventory.ui.createjobs

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.databinding.StoreItemBinding
import com.wekanmdb.storeinventory.model.store.Stores
import io.realm.RealmList
import io.realm.RealmResults
/**
 * This Adapter is used to hold actual store item from realm
 * while searching in Search Activity.
 */

class StoreSearchAdapter(var context: Context): RecyclerView.Adapter<StoreSearchAdapter.StoreSearchViewHolder>()
     {
         private  var storeList: RealmList<Stores>
         init {
             storeList = RealmList<Stores>()
         }
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): StoreSearchViewHolder {
       return StoreSearchViewHolder(
           LayoutInflater.from(parent.context).inflate(R.layout.store_item, parent, false)
       )
    }

    override fun onBindViewHolder(holder: StoreSearchViewHolder, position: Int) {
        val item: Stores = storeList.get(position)!!
        val binding: StoreItemBinding = holder.getBinding()
        binding.stores = item
    }


    fun addData(ans: RealmResults<Stores>){
        if(storeList == null){
            return
        }
        storeList.clear()
        storeList.addAll(ans)
        notifyDataSetChanged()
    }
    override fun getItemCount(): Int {
        return storeList.size
    }

    inner  class StoreSearchViewHolder( view : View) : RecyclerView.ViewHolder(view),View.OnClickListener{
        private var binding: StoreItemBinding? = null

        init {
            binding = DataBindingUtil.bind(itemView)
            itemView.setOnClickListener(this)
        }

        fun getBinding(): StoreItemBinding {
            return binding!!
        }

        override fun onClick(v: View?) {
            (context as SearchActivity).updateStore(storeList.get(absoluteAdapterPosition)?.name.toString(),storeList.get(absoluteAdapterPosition)?._id.toString())

        }

    }


}
