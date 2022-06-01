//
//  SignUpController+Extension.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import Foundation
import UIKit

extension SignUpViewController {
    
    ///Function for  password text field right view mode
    internal var btnDropDown1: UIButton {
        let size: CGFloat = 25.0
        var filled = UIButton.Configuration.plain()
        filled.image = UIImage(named : UIConstants.LoginView.passwordRightViewImage)
        filled.imagePlacement = .trailing
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.tintColor = UIColor.clear
        button.frame = CGRect(x: createPasswordTextField.frame.size.width - size, y: 0.0, width: size, height: size)
        button.addTarget(self, action: #selector(showPwdBtnAction), for: .touchUpInside)
        return button
    }
    
    /// Function for button action
    @objc func showPwdBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        createPasswordTextField.isSecureTextEntry = !createPasswordTextField.isSecureTextEntry
    }
    
    ///Function for  password text field right view mode
    internal var btnDropDown2: UIButton {
        let size: CGFloat = 25.0
        var filled = UIButton.Configuration.plain()
        filled.image = UIImage(named : UIConstants.LoginView.passwordRightViewImage)
        filled.imagePlacement = .trailing
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.tintColor = UIColor.clear
        button.frame = CGRect(x: confirmPasswordTextField.frame.size.width - size, y: 0.0, width: size, height: size)
        button.addTarget(self, action: #selector(showPwdBtnAction2), for: .touchUpInside)
        return button
    }
    
    /// Function for button action
    @objc func showPwdBtnAction2(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        confirmPasswordTextField.isSecureTextEntry = !confirmPasswordTextField.isSecureTextEntry
    }
    
    ///Function for declaring the userType button
    internal var UserTypeView: UIButton {
        let size: CGFloat = 12.0
        var filled = UIButton.Configuration.plain()
        filled.image = UIImage(named : UIConstants.LoginView.downArrowImage)
        filled.imagePlacement = .trailing
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.tintColor = UIColor.clear
        
        button.frame = CGRect(x: userTypeTextField == nil ? genderTextfield.frame.size.width : userTypeTextField.frame.size.width - size, y: 0.0, width: size, height: size)
        return button
    }
    
    ///Function for right view mode in DOB text field
    internal var dobUserType: UIButton {
        let size: CGFloat = 25.0
        var filled = UIButton.Configuration.plain()
        filled.image = UIImage(named : UIConstants.LoginView.downArrowImage)
        filled.imagePlacement = .trailing
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.tintColor = UIColor.clear
        button.frame = CGRect(x: dobTextField.frame.size.width - size, y: 0.0, width: size, height: size)
        return button
    }
}

//MARK:- Picker view extension
extension SignUpViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch activeTextField {
        case 1 :
            //userType
            return UIConstants.signUpView.userTypeData.count
        case 2:
            //gender
            return UIConstants.signUpView.genderTypeArray.count
        default:
            break
        }
        return 0
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch activeTextField {
        case 1 :
            //userType
            return UIConstants.signUpView.userTypeData[row]
        case 2:
            //gender
            return UIConstants.signUpView.genderTypeArray[row]
        default:
            break
        }
        return ""
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch activeTextField {
        case 1 :
            //userType
            self.userTypeTextField.text = UIConstants.signUpView.userTypeData[row]
            //assign value to view model
            SignupViewModel.sharedInstance.userRole = userTypeTextField.text?.count ?? 0 > 0 ? userTypeTextField.text == UIConstants.signUpView.userTypeData.first ? enumDeclarations.userTypes.doctor : enumDeclarations.userTypes.nurse : nil
            
            self.userTypeTextField.resignFirstResponder()
            self.genderTextfield.becomeFirstResponder()
        case 2:
            //gender
            self.genderTextfield.text = UIConstants.signUpView.genderTypeArray[row]
            //assign value to view model
            SignupViewModel.sharedInstance.gender = genderTextfield.text?.count ?? 0 > 0 ? genderTextfield.text == UIConstants.signUpView.genderTypeArray.first ? enumDeclarations.genderSelection.male : genderTextfield.text == UIConstants.signUpView.genderTypeArray[1] ? enumDeclarations.genderSelection.female : enumDeclarations.genderSelection.others : nil
            
            self.genderTextfield.resignFirstResponder()
            self.dobTextField.becomeFirstResponder()
            
        default:
            break
        }
    }
}

//Mark:- textfield delegate
extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case userTypeTextField:
            activeTextField = 1
            thePicker.reloadAllComponents()
        case genderTextfield:
            activeTextField = 2
            thePicker.reloadAllComponents()
        case dobTextField:
            activeTextField = 3
        default:
            activeTextField = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTxtField:
            self.lastNameTxtField.becomeFirstResponder()
            
        case lastNameTxtField:
            self.emailTextField.becomeFirstResponder()
            
        case emailTextField:
            self.createPasswordTextField.becomeFirstResponder()
            
        case createPasswordTextField:
            self.confirmPasswordTextField
                .becomeFirstResponder()
            
        case confirmPasswordTextField:
            self.userTypeTextField.becomeFirstResponder()
            
        default:
            self.view.endEditing(true)
            break
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            if oldString.isEmpty && string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            var newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
            newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            switch textField {
            case firstNameTxtField:
                if newString.count > Maximum.nameLength {
                    return false
                }
                SignupViewModel.sharedInstance.firstName = newString
                
            case lastNameTxtField:
                if newString.count > Maximum.nameLength {
                    return false
                }
                SignupViewModel.sharedInstance.lastName = newString
                
            case emailTextField:
                if newString.count > Maximum.emailLength {
                    return false
                }
                SignupViewModel.sharedInstance.email = newString
                
            case createPasswordTextField:
                if newString.count > Maximum.passwordLength {
                    return false
                }
                SignupViewModel.sharedInstance.pwd = newString
                
            case confirmPasswordTextField:
                if newString.count > Maximum.passwordLength {
                    return false
                }
                SignupViewModel.sharedInstance.confirmPwd = newString
                
            default:
                break
            }
        }
        return true
    }
}

//MARK:- Date Picker
extension SignUpViewController {
    
    func showDatePicker() {
        //Frame set for datePicker
        datePicker.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        datePicker.preferredDatePickerStyle = .inline
        
        datePicker.tintColor = UIColor.appGeneralThemeClr()
        
        //maximum date set
        datePicker.maximumDate = Date()
        
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: UIConstants.signUpView.doneBtnTXt, style: UIBarButtonItem.Style.plain, target: self, action: #selector(donedatePicker))
        doneButton.tintColor = UIColor.appGeneralThemeClr()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: UIConstants.signUpView.cancelBtnText, style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelDatePicker))
        cancelButton.tintColor = UIColor.appGeneralThemeClr()
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        dobTextField.inputAccessoryView = toolbar
        // add datepicker to textField
        dobTextField.inputView = datePicker
    }
    
    /// Done date picker
    @objc func donedatePicker() {
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        dobTextField.text = formatter.string(from: datePicker.date)
        //assign value to view model
        SignupViewModel.sharedInstance.dateofBirth = dobTextField.text ?? ""
        
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    /// cancel date picker
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
        dobTextField.text = ""
        SignupViewModel.sharedInstance.dateofBirth = ""
    }
    
    func toolBarCreation() {
        otherPickerToolBar.sizeToFit()
        
        //done button & cancel button
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: UIConstants.signUpView.cancelBtnText, style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelDatePicker))
        cancelButton.tintColor = UIColor.appGeneralThemeClr()
        otherPickerToolBar.setItems([spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        userTypeTextField.inputAccessoryView = otherPickerToolBar
        
        genderTextfield.inputAccessoryView = otherPickerToolBar
    }
}
