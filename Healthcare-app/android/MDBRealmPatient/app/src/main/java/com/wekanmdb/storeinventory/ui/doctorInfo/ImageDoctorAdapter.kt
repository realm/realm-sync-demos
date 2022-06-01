package com.wekanmdb.storeinventory.ui.doctorInfo

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.viewpager.widget.PagerAdapter
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.utils.UiUtils


class ImageDoctorAdapter(
    private val context: Context,
    imageBit: ArrayList<String>?
) : PagerAdapter() {

    private val imageBitmap = imageBit

    override fun instantiateItem(container: ViewGroup, position: Int): Any {
        val view = LayoutInflater.from(container.context)
            .inflate(R.layout.item_hospital_imageslider, container, false)
        val image = view.findViewById<ImageView>(R.id.imageView_hospital)
        val getPosit = imageBitmap?.get(position)
        if (imageBitmap?.isNotEmpty() == true) {
            UiUtils.setImageInBitmapRecycler(context,getPosit,image)
        }
        container.addView(view)
        return view
    }

    override fun getCount(): Int {
        return imageBitmap?.size ?: 0
    }

    override fun isViewFromObject(view: View, `object`: Any): Boolean {
        return view == `object`
    }

    override fun destroyItem(container: ViewGroup, position: Int, `object`: Any) {
        container.removeView(`object` as View)
    }
}