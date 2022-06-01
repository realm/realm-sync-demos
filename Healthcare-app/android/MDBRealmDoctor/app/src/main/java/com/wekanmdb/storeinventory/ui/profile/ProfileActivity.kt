package com.wekanmdb.storeinventory.ui.profile

import android.annotation.TargetApi
import android.app.Activity
import android.app.Dialog
import android.content.ContentUris
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.provider.DocumentsContract
import android.provider.MediaStore
import android.util.Base64
import android.view.View
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProvider
import com.wekanmdb.storeinventory.R
import com.wekanmdb.storeinventory.app.user
import com.wekanmdb.storeinventory.base.BaseActivity
import com.wekanmdb.storeinventory.databinding.ActivityDoctorInfoBinding
import com.wekanmdb.storeinventory.model.practitioner.PractitionerRole
import com.wekanmdb.storeinventory.ui.search.SearchActivity
import com.wekanmdb.storeinventory.utils.Constants
import com.wekanmdb.storeinventory.utils.Constants.Companion.NURSE
import com.wekanmdb.storeinventory.utils.Constants.Companion.USER_TYPE
import kotlinx.android.synthetic.main.profile_pic_dialog.*
import org.bson.types.ObjectId
import java.io.ByteArrayOutputStream


class ProfileActivity : BaseActivity<ActivityDoctorInfoBinding>(), ProfileNavigator {
    companion object {

    }

    override fun getLayoutId(): Int = R.layout.activity_doctor_info
    private lateinit var activityProfileBinding: ActivityDoctorInfoBinding
    private lateinit var profileViewModel: ProfileViewModel
    var practionerRole: PractitionerRole? = null
    private var code=""
    private var system=""
    override fun initView(mViewDataBinding: ViewDataBinding?) {
        activityProfileBinding = mViewDataBinding as ActivityDoctorInfoBinding
        profileViewModel =
            ViewModelProvider(this, viewModelFactory).get(ProfileViewModel::class.java)

        profileViewModel.getPracctitionerRole(user?.customData?.get("referenceId") as ObjectId)

        profileViewModel.practitionerresponseBody.observe(this, { practionerRole ->

            if (practionerRole != null) {
                this.practionerRole = practionerRole
                activityProfileBinding.editTextTextPersonName4.setText(practionerRole.practitioner?.name?.text)
                activityProfileBinding.textSpeciality.text = practionerRole.specialty?.coding?.first()?.display

                practionerRole.practitioner?.about?.let {
                    activityProfileBinding.editTextTextPersonName5.setText(it)
                }
                if(!practionerRole.practitioner?.photo.isNullOrEmpty()) {
                    practionerRole.practitioner?.photo?.first()?.data?.let {

                        activityProfileBinding.imageView14.setImageBitmap(decodeImage(it))
                        activityProfileBinding.imageView15.visibility= View.GONE
                        activityProfileBinding.textView31.visibility= View.GONE
                    }
                }
            }


        })

        activityProfileBinding.textSpeciality.setOnClickListener {
            val searchIntent = Intent(this, SearchActivity::class.java)
            searchIntent.putExtra(Constants.SEARCH_TYPE, Constants.SEARCH_CODE)
            searchIntent.putExtra(Constants.SEARCH_CATGORY, Constants.SPECIALITY)
            specialitySearchLauncher.launch(searchIntent)
        }

        activityProfileBinding.textView35.setOnClickListener {

                showLoading()
                profileViewModel.updatePracctitionerRole(
                    activityProfileBinding.editTextTextPersonName4.text.toString(),
                    activityProfileBinding.textSpeciality.text.toString(),
                    activityProfileBinding.editTextTextPersonName5.text.toString(),code,system
                ).observe(this, {
                    hideLoading()
                    if (it) {
                        showToast("Profile has been updated")
                    }

                })


        }

        activityProfileBinding.imageView14.setOnClickListener {
            imagePickerDialog()

        }
        if(user!!.customData[USER_TYPE].toString().equals(NURSE,true)){
            activityProfileBinding.textView9.text="Nurse Information"
            activityProfileBinding.textView33.visibility=View.GONE
            activityProfileBinding.cardView4.visibility=View.GONE

        }

    }

    private var specialitySearchLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val data: Intent? = result.data
                if (data != null) {
                    code=data.getStringExtra("code") as String
                    system=data.getStringExtra("system") as String
                    activityProfileBinding.textSpeciality.text = data.getStringExtra("data")
                }
            }
        }

    override fun logoutClick() {
    }

    private fun show(message: String) {
        showToast(message)
    }

    private fun capturePhoto() {

        val intent = Intent("android.media.action.IMAGE_CAPTURE")
        cameraLauncher.launch(intent)
    }

    private fun openGallery() {
        val intent = Intent("android.intent.action.GET_CONTENT")
        intent.type = "image/*"
        imageLauncher.launch(intent)
    }

    private fun renderImage(imagePath: String?) {
        if (imagePath != null) {
            val bitmap = BitmapFactory.decodeFile(imagePath)
            activityProfileBinding.imageView14.setImageBitmap(bitmap)
            activityProfileBinding.imageView15.visibility= View.GONE
            activityProfileBinding.textView31.visibility= View.GONE
            practionerRole?.let { encodeImage(bitmap)?.let { it1 ->
                profileViewModel.updateProfilePic(it,
                    it1
                )
            } }
        } else {
            show("ImagePath is null")
        }
    }

    private fun getImagePath(uri: Uri?, selection: String?): String {
        var path: String? = null
        val cursor = uri?.let { contentResolver.query(it, null, selection, null, null) }
        if (cursor != null) {
            if (cursor.moveToFirst()) {
                path = cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.DATA))
            }
            cursor.close()
        }
        return path!!
    }

    @TargetApi(19)
    private fun handleImageOnKitkat(data: Intent?) {
        var imagePath: String? = null
        val uri = data!!.data
        //DocumentsContract defines the contract between a documents provider and the platform.
        if (DocumentsContract.isDocumentUri(this, uri)) {
            val docId = DocumentsContract.getDocumentId(uri)
            if ("com.android.providers.media.documents" == uri?.authority) {
                val id = docId.split(":")[1]
                val selsetion = MediaStore.Images.Media._ID + "=" + id
                imagePath = getImagePath(
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                    selsetion
                )
            } else if ("com.android.providers.downloads.documents" == uri?.authority) {
                val contentUri = ContentUris.withAppendedId(
                    Uri.parse(
                        "content://downloads/public_downloads"
                    ), java.lang.Long.valueOf(docId)
                )
                imagePath = getImagePath(contentUri, null)
            }
        } else if ("content".equals(uri?.scheme, ignoreCase = true)) {
            imagePath = getImagePath(uri, null)
        } else if ("file".equals(uri?.scheme, ignoreCase = true)) {
            imagePath = uri?.path
        }
        renderImage(imagePath)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, grantedResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantedResults)
        when (requestCode) {
            1 ->
                if (grantedResults.isNotEmpty() && grantedResults.get(0) ==
                    PackageManager.PERMISSION_GRANTED
                ) {
                    openGallery()
                } else {
                    show("Unfortunately You are Denied Permission to Perform this Operation.")
                }
        }
    }

    private var cameraLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val data: Intent? = result.data
                if (data != null) {
                    activityProfileBinding.imageView14.setImageBitmap(data.extras?.get("data") as Bitmap)
                    activityProfileBinding.imageView15.visibility= View.GONE
                    activityProfileBinding.textView31.visibility= View.GONE
                    practionerRole?.let { encodeImage(data.extras?.get("data") as Bitmap)?.let { it1 ->
                        profileViewModel.updateProfilePic(it,
                            it1
                        )
                    } }
                }
            }
        }

    private var imageLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val data: Intent? = result.data
                handleImageOnKitkat(data)
            }
        }

    private fun encodeImage(bm: Bitmap): String? {
        val baos = ByteArrayOutputStream()
        bm.compress(Bitmap.CompressFormat.JPEG, 100, baos)
        val b = baos.toByteArray()
        return Base64.encodeToString(b, Base64.DEFAULT)
    }

    private fun decodeImage(base64String: String): Bitmap? {
        val imageBytes = Base64.decode(base64String, Base64.DEFAULT)
        return BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
    }

    private fun imagePickerDialog() {
        val dialog = Dialog(this, R.style.dialog_center)
        dialog.setCancelable(true)
        dialog.setContentView(R.layout.profile_pic_dialog)
        dialog.show()
        val camera = dialog.camera
        val gallery = dialog.image
        val cancel = dialog.cancel
        gallery.setOnClickListener {
                  //check permission at runtime
                val checkSelfPermission = ContextCompat.checkSelfPermission(this,
                    android.Manifest.permission.WRITE_EXTERNAL_STORAGE)
                if (checkSelfPermission != PackageManager.PERMISSION_GRANTED){
                    //Requests permissions to be granted to this application at runtime
                    ActivityCompat.requestPermissions(this,
                        arrayOf(android.Manifest.permission.WRITE_EXTERNAL_STORAGE), 1)
                }
                else{
                    openGallery()

                }
            dialog.dismiss()
        }
        camera.setOnClickListener {
            capturePhoto()
            dialog.dismiss()
        }
        cancel.setOnClickListener {
            dialog.dismiss()
        }
    }


}