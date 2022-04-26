package com.wekanmdb.storeinventory.ui.productdetails

import android.view.View
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.base.BaseFragment
import com.wekanmdb.storeinventory.data.AppConstants
import com.wekanmdb.storeinventory.databinding.FragmentProductDetailsBinding
import kotlinx.android.synthetic.main.common_toolbar.*
import kotlinx.android.synthetic.main.fragment_product_details.*

class ProductDetailsFragment : BaseFragment<FragmentProductDetailsBinding>(),
    ProductDetailsNavigator {

    private lateinit var fragmentProfileBinding: FragmentProductDetailsBinding
    private lateinit var productDetailsViewModel: ProductDetailsViewModel
    private var productId: String? = null
    private var inventryId: String? = null
    private var productName: String? = null
    private var totalQuantity = 0
    private var inventryQuantity = 0

    override val layoutId: Int
        get() = R.layout.fragment_product_details

    override fun initView(mRootView: View?, mViewDataBinding: ViewDataBinding?) {
        fragmentProfileBinding = mViewDataBinding as FragmentProductDetailsBinding
        productDetailsViewModel =
            ViewModelProvider(this, viewModelFactory).get(ProductDetailsViewModel::class.java)
        fragmentProfileBinding.productDetailsViewModel = productDetailsViewModel
        productDetailsViewModel.navigator = this

        if (arguments != null) {
            inventryId = arguments?.getString(AppConstants.STOREINVENTRYID)
            productId = arguments?.getString(AppConstants.PRODUCTID)
            productName = arguments?.getString(AppConstants.PRODUCTNAME)
            productDetailsViewModel.productId.set(productId)
            productDetailsViewModel.inventryId.set(inventryId)
            productDetailsViewModel.totalQuantity.set(totalQuantity.toString())
        }
        textView27.text = productName

        getMasterProductDetails()
        getStoreInventryDetails()

        img_back.setOnClickListener {
            requireActivity().onBackPressed()
        }

        fragmentProfileBinding.imageView13.setOnClickListener {
            inventryQuantity -= 1

            if (inventryQuantity <= 0) {
                inventryQuantity = 1
                1
            } else {
                totalQuantity += 1
                inventryQuantity
            }.let { stock ->

                textView64.text = stock.toString()
                textView29.text = totalQuantity.toString().plus(" remaining")
            }
            updateStock(inventryQuantity)
        }

        fragmentProfileBinding.imageView14.setOnClickListener {


            if ( totalQuantity>0) {
                inventryQuantity += 1
                totalQuantity -= 1
            }
            textView64.text = inventryQuantity.toString()
            textView29.text = totalQuantity.toString().plus(" remaining")
            updateStock(inventryQuantity)
        }
    }

    private fun updateStock(stock: Int) {
        productDetailsViewModel.updateInventryStock(stock)
        productDetailsViewModel.updateMasterStock(totalQuantity)
    }

    // getting master product details
    private fun getMasterProductDetails() {
        productDetailsViewModel.getProductDetails().observe(this, { productDetails ->
            if (productDetails != null) {
                textView9.text = "$ " + productDetails.price.toString()
                    .let { if (it.substringAfter(".").toInt() > 0) it else it.substringBefore(".") }
                totalQuantity= productDetails.totalQuantity.toInt()
                textView29.text = totalQuantity.toString().plus(" remaining")
                textView28.text = productDetails.sku.toString()
                fragmentProfileBinding.products = productDetails
                fragmentProfileBinding.executePendingBindings()
            } else {
                showToast("No More  data")
            }
        })
    }

    // getting store inventry details
    private fun getStoreInventryDetails() {
        productDetailsViewModel.getInventryDetails().observe(this, { inventryDetails ->
            if (inventryDetails != null) {
                inventryQuantity= inventryDetails.quantity!!
                textView64.text = inventryDetails.quantity.toString()

            } else {
                showToast("No More  data")
            }
        })
    }
}