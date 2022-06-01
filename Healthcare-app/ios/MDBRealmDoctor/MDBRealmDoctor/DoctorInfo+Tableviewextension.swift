//
//  DoctorInfo+Tableviewextension.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 25/04/22.
//

import Foundation
import UIKit

extension DoctorInfoViewController : UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.doctorInfo.imageAddCellID) as? DoctorInfoTableViewCell else {return UITableViewCell() }
            
            cell.imageLoadImageView.image =  self.listData?.first?.practitioner?.photo.count ?? 0 > 0 ? convertBase64StringToImage(imageBase64String: self.listData?.first?.practitioner?.photo.first?.data ?? "") : UIImage(named: UIConstants.doctorInfo.personPhoto)
            cell.contentView.layer.cornerRadius = cell.contentView.frame.size.height / 2
            return cell
            
        case 1,2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.doctorInfo.type2CellNameProfile) as? DoctorInfoNameEditTableView else {return UITableViewCell() }
            
            cell.nameLabel.text = indexPath.row == 1 ? UIConstants.doctorInfo.nameTitle : UIConstants.doctorInfo.specialityTxt
            cell.nameTextField.placeholder = indexPath.row == 1 ? "" : UIConstants.doctorInfo.selectTxt
            cell.nameTextField.rightViewMode = indexPath.row == 1 ? .never : .always
            cell.nameTextField.text = indexPath.row == 1 ? self.listData?.first?.practitioner?.name?.text == "" ? ("\(UserDefaults.standard.value(forKey: userDefaultsConstants.userD.fUserName) ?? "") \(UserDefaults.standard.value(forKey: userDefaultsConstants.userD.lUserName) ?? "")") : self.listData?.first?.practitioner?.name?.text : self.specialityNameNotifi.isEmpty ? self.listData?.first?.specialty?.coding.first?.display ?? "" : self.specialityNameNotifi
            cell.nameTextField.tag = indexPath.row
            
            //speciality selection closure
            cell.didClickSpeciality = { [weak self] textfieldR, textfieldData in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    if indexPath.row == 2 {
                        self.view.endEditing(true)
                        //speciality controller
                        pushNavControllerWithvalue(StroryBoardName: Storyboard.storyBoardName.mainBoard, VcID: Storyboard.storyBoardControllerID.SpecialityAdditionPage, ViewControllerName: self, valueToPass: 1, hospitalSelectionList: self.hospitalListReceived)
                    }else {
                        //name textfield
                        self.nameTextFieldData = textfieldData
                        cell.nameTextField.becomeFirstResponder()
                    }
                }
            }
            return cell
            
        default:
            //UIText view
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.doctorInfo.uitextViewCell) as? DoctorInfoTextViewCell else {return UITableViewCell() }
            
            cell.nameTitle.text = UIConstants.doctorInfo.aboutDescTXT
            cell.descTextView.tag = indexPath.row
            cell.descTextView.text = listData?.first?.practitioner?.about
            //closure for textview
            cell.didClickTextView = { [weak self] textviewIndex, textInTextView in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    self.aboutTextViewData = textInTextView
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alert = UIAlertController(title: UIConstants.doctorInfo.chooseImageInstance, message: UIConstants.doctorInfo.profileTitleImage, preferredStyle: UIDevice.isRunningOnIpad == true ? .alert : .actionSheet )
            
            alert.addAction(UIAlertAction(title: UIConstants.doctorInfo.snapAPic, style: .default, handler: { _ in
                self.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title:  UIConstants.doctorInfo.selectFromGallery, style: .default, handler: { _ in
                self.openGallery()
            }))
            
            alert.addAction(UIAlertAction.init(title: UIConstants.HomePage.cancelTxt, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0 :
            return 190
            
        case 1,2 :
            return 96
            
        default:
            return 250
        }
    }
    
    //MARK: - Photo image picker controller
    // Function to open the camera
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) else {return showMessageWithoutAction(message: UIConstants.doctorInfo.cameraTxt, title: UIConstants.doctorInfo.wariningText, controllerToPresent: self)}
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    /// Function to pic the image from gallery
    func openGallery() {
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) else {return showMessageWithoutAction(message: UIConstants.doctorInfo.cameraTxt, title: UIConstants.doctorInfo.wariningText, controllerToPresent: self)}
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:-- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            
            ///Compress the image under 1MB then move to base64 conversion
            ImageCompressor.compress(image: pickedImage, maxByte: 500000) { image in
                guard let compressedImage = image else { return }
                
                DispatchQueue.main.async {
                    //dismiss the picker view
                    picker.dismiss(animated: true, completion: nil)
                    self.showLoader()
                    
                    ///Function will call the convert to base64 string
                    RealmManager.shared.initiateProfilePicInsert(base64: convertImageToBase64String(img: compressedImage), success: {
                        [weak self] _ in
                        guard let self = self else {return}
                        DispatchQueue.main.async {
                            self.hideLoader()
                            self.doctorInfotableView.reloadData()
                        }
                    })
                }
            }
        }
    }
}
