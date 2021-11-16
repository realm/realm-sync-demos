package com.wekanmdb.storeinventory.bindings

import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.widget.ImageView
import androidx.databinding.BindingAdapter
import com.bumptech.glide.Glide
import com.wekanmdb.storeinventory.R


@BindingAdapter("imageUrl")
fun setImage(imageView: ImageView, imageUrl: String?) {
    if (!imageUrl.isNullOrEmpty()) {
        Glide.with(imageView).load(imageUrl).placeholder(R.drawable.ic_logo)
            .error(R.drawable.ic_logo)
            .into(imageView)
    }
}