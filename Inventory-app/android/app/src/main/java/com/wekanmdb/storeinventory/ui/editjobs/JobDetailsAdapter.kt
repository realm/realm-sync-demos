package com.wekanmdb.storeinventory.ui.editjobs

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.databinding.ActivityDetailsProductItemBinding
import com.wekanmdb.storeinventory.model.job.ProductQuantity
import io.realm.RealmList

/**
 * This adapter is used to hold Product item and quantity
 * in Job Details Activity.
 */
class JobDetailsAdapter(var context: Context): RecyclerView.Adapter<JobDetailsAdapter.JobDetailsViewHolder>(){

   private  var productDetailsList: RealmList<ProductQuantity>
    init {
        productDetailsList = RealmList<ProductQuantity>()
    }
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): JobDetailsViewHolder {
        return JobDetailsViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.activity_details_product_item, parent, false)
        )
    }

    override fun onBindViewHolder(holder: JobDetailsViewHolder, position: Int) {
        val item: ProductQuantity = productDetailsList.get(position)!!
        val binding: ActivityDetailsProductItemBinding = holder.getBinding()
        binding.productquantity = item
    }


    fun addData(list: RealmList<ProductQuantity>){
        if(productDetailsList == null){
            return
        }
        productDetailsList.clear()
        productDetailsList.addAll(list)
        notifyDataSetChanged()
    }
    override fun getItemCount(): Int {
        return productDetailsList.size
    }

      class JobDetailsViewHolder( itemView: View) : RecyclerView.ViewHolder(itemView),View.OnClickListener{

          private var binding: ActivityDetailsProductItemBinding? = null

          init {
              binding = DataBindingUtil.bind(itemView)
              itemView.setOnClickListener(this)
          }

          fun getBinding(): ActivityDetailsProductItemBinding {
              return binding!!
          }


          override fun onClick(v: View?) {


          }

      }


}
