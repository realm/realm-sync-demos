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
    private var productName: String? = null
    private var totalQuantity: String? = null

    override val layoutId: Int
        get() = R.layout.fragment_product_details

    override fun initView(mRootView: View?, mViewDataBinding: ViewDataBinding?) {
        fragmentProfileBinding = mViewDataBinding as FragmentProductDetailsBinding
        productDetailsViewModel =
            ViewModelProvider(this, viewModelFactory).get(ProductDetailsViewModel::class.java)
        fragmentProfileBinding.productDetailsViewModel = productDetailsViewModel
        productDetailsViewModel.navigator = this

        if (arguments != null) {
            productId = arguments?.getString(AppConstants.PRODUCTID)
            productName = arguments?.getString(AppConstants.PRODUCTNAME)
            totalQuantity = arguments?.getString(AppConstants.TOTALQUANTITY)
            productDetailsViewModel.productId.set(productId)
            productDetailsViewModel.totalQuantity.set(totalQuantity)
        }
        textView27.text = productName

        getProductDetails()

        img_back.setOnClickListener {
            requireActivity().onBackPressed()
        }
    }

    // getting productdetails
    private fun getProductDetails() {
        productDetailsViewModel.getProductDetails().observe(this, { productDetails ->
            if (productDetails != null) {
                textView9.text = "$ " + productDetails.price.toString()
                    .let { if (it.substringAfter(".").toInt() > 0) it else it.substringBefore(".") }
                textView28.text =
                    getString(R.string.quantity) + " " + totalQuantity + " remaining"
                textView29.text = getString(R.string.sku_number) + " " + productDetails.sku
                fragmentProfileBinding.products = productDetails
                fragmentProfileBinding.executePendingBindings()
            } else {
                showToast("No More  data")
            }
        })
    }
}