//
//  PrescriptionType2TBCell.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import UIKit
import SwiftUI

class PrescriptionType2TBCell: UITableViewCell, UITextFieldDelegate {
    
    
    var parentVC: UIViewController!
    
    var isNurseAssigned: Bool! {
        didSet {
           
            if isNurseAssigned {
                selectNurseTextField.isUserInteractionEnabled = false
            }
        }
    }
    
    
    //Type 2
    @IBOutlet weak var titleImageView : UIImageView!
    
    @IBOutlet weak var titleTxt       : UILabel!
    
    @IBOutlet weak var descContent    : UILabel!
    
    
    //Type 3
    @IBOutlet weak var editButton     : UIButton! {
        didSet {
            self.editButton.setImage(UIImage(named: UIConstants.doctorPrescription.editButtonImage), for: .normal)
        }
    }
    
    //Type 4
    @IBOutlet weak var selectNurseLabel : UILabel! {
        didSet {
            self.selectNurseLabel.text = UIConstants.doctorPrescription.selectNurseTitle
        }
    }
    
    @IBOutlet weak var selectNurseTextField : UITextField! {
        didSet {
            self.selectNurseTextField.rightView = self.UserTypeView
            self.selectNurseTextField.rightViewMode = .always
           
            self.selectNurseTextField.delegate = self
            self.selectNurseTextField.textColor = UIColor.black
            
       
            if(RealmManager.shared.nurseList?.count == 0) {
    //            showMessageWithoutAction(message: "No nurse assigned to this hospital.", controllerToPresent:parentVC)
                selectNurseTextField.alpha = 0
                selectNurseTextField.isUserInteractionEnabled = false
                self.selectNurseTextField.inputView = nil
                selectNurseLabel.text = "No nurse assigned to this hospital."
                
            }else{
                self.selectNurseTextField.inputView = thePicker
            }
          
        }
    }
    
    ///Function for declaring the userType button
    internal var UserTypeView: UIButton {
        let size: CGFloat = 12.0
        var filled = UIButton.Configuration.plain()
        filled.image = UIImage(named : UIConstants.LoginView.downArrowImage)
        filled.imagePlacement = .trailing
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.tintColor = UIColor.clear
        
        button.frame = CGRect(x: selectNurseTextField == nil ? selectNurseTextField.frame.size.width : selectNurseTextField.frame.size.width - size, y: 0.0, width: size, height: size)
        return button
    }
    
    //Variable declaration
    lazy var didTapEditButton   : ((_ indexPathSelected : Int) -> ()) = {_ in }
    let thePicker               = UIPickerView()
    lazy var pickerSelectedData : ((_ selectedNurse : PractitionerRole) -> ()) = {selectedNurse in }
    lazy var moveView           : (() -> ()) = { }
    let toolbar2                = UIToolbar()
    lazy var moveTheViewUp      : (() -> ()) = {}
    lazy var moveFromSelectedNurse : (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thePicker.delegate = self
        thePicker.dataSource = self
        thePicker.backgroundColor = UIColor.textfieldClrSet(alpha: 1)
        toolBarCreation()
        
       
    }
    
    func toolBarCreation() {
        toolbar2.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: UIConstants.signUpView.doneBtnTXt, style: UIBarButtonItem.Style.plain, target: self, action: #selector(donedatePicker))
        doneButton.tintColor = UIColor.appGeneralThemeClr()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: UIConstants.signUpView.cancelBtnText, style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelDatePicker))
        cancelButton.tintColor = UIColor.appGeneralThemeClr()
        toolbar2.setItems([doneButton,spaceButton,cancelButton], animated: false)
        // add toolbar to textField
        selectNurseTextField.inputAccessoryView = toolbar2
            
    }
    
    /// Done date picker
    @objc func donedatePicker() {
            let row = thePicker.selectedRow(inComponent: 0)
            thePicker.selectRow(row, inComponent: 0, animated: false)
            //instance creation
            let listData = RealmManager.shared.nurseList?[row]
            self.selectNurseTextField.text = "\(listData?.practitioner?.name?.text ?? "")"
            self.selectNurseTextField.resignFirstResponder()
            moveView()
    }
    
    /// cancel date picker
    @objc func cancelDatePicker() {
        //cancel button dismiss datepicker dialog
        selectNurseTextField.text = ""
        moveView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //Mark:- Action outlet
    
    @IBAction func editButtonTapped(_ sender : UIButton) {
        didTapEditButton(sender.tag)
    }
    
    //Search field delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTheViewUp()
        thePicker.reloadAllComponents()
    }
    
}

extension PrescriptionType2TBCell : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if RealmManager.shared.nurseList?.count ?? 0 > 0 {
            return RealmManager.shared.nurseList?.count ?? 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //instance creation
        let listData = RealmManager.shared.nurseList?[row]
        
        return "\(listData?.practitioner?.name?.text ?? "")"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Instance creation
        guard let listData = RealmManager.shared.nurseList?[row]
                
        else {return}
        
        selectNurseTextField.text = "\(listData.practitioner?.name?.text ?? "")"
        
        self.selectNurseTextField.resignFirstResponder()
        
        pickerSelectedData(listData)
    }
    
}
