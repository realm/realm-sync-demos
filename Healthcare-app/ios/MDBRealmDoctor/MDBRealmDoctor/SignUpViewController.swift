//
//  SignUpViewController.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import UIKit
import RealmSwift

class SignUpViewController: BaseViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var firstNameLastNameLabel : UILabel! {
        didSet {
            self.firstNameLastNameLabel.text = UIConstants.signUpView.firstnameLastname
        }
    }
    
    @IBOutlet weak var emailAddressLabel : UILabel! {
        didSet {
            self.emailAddressLabel.text = UIConstants.signUpView.emailAddressTxt
        }
    }
    
    @IBOutlet weak var createPasswordLabel : UILabel! {
        didSet {
            self.createPasswordLabel.text = UIConstants.signUpView.createPasswordTxt
            
        }
    }
    
    @IBOutlet weak var confirmPasswordLabel : UILabel! {
        didSet {
            self.confirmPasswordLabel.text = UIConstants.signUpView.confirmPasswordTxt
        }
    }
    
    @IBOutlet weak var createAccountButton : UIButton! {
        didSet {
            self.createAccountButton.setTitle(UIConstants.signUpView.nextButtonTxt, for: .normal)
            self.createAccountButton.backgroundColor = UIColor.appGeneralThemeClr()
        }
    }
    
    @IBOutlet weak var firstNameTxtField : UITextField! {
        didSet {
            self.setTextFieldCustomisation(textfield: self.firstNameTxtField, name: UIConstants.signUpView.firstNameTxt)
            firstNameTxtField.delegate = self
        }
    }
    @IBOutlet weak var lastNameTxtField : UITextField! {
        didSet {
            self.setTextFieldCustomisation(textfield: self.lastNameTxtField, name: UIConstants.signUpView.lastNameTxt)
            lastNameTxtField.delegate = self
        }
    }
    @IBOutlet weak var emailTextField : UITextField! {
        didSet {
            self.setTextFieldCustomisation(textfield: self.emailTextField, name: UIConstants.signUpView.emailAddressTxt)
            emailTextField.delegate = self
        }
    }
    @IBOutlet weak var createPasswordTextField : UITextField! {
        didSet {
            self.setTextFieldCustomisation(textfield: self.createPasswordTextField, name: UIConstants.signUpView.createPasswordTxt)
            self.createPasswordTextField.rightView = self.btnDropDown1
            self.createPasswordTextField.rightViewMode = .whileEditing
            createPasswordTextField.delegate = self
        }
    }
    @IBOutlet weak var confirmPasswordTextField : UITextField! {
        didSet {
            self.setTextFieldCustomisation(textfield: self.confirmPasswordTextField, name: UIConstants.signUpView.confirmPasswordTxt)
            self.confirmPasswordTextField.rightView = self.btnDropDown2
            self.confirmPasswordTextField.rightViewMode = .whileEditing
            confirmPasswordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var userTypeLabel : UILabel! {
        didSet {
            self.userTypeLabel.text = UIConstants.signUpView.userType
        }
    }
    
    @IBOutlet weak var userTypeTextField : UITextField! {
        didSet {
            self.userTypeTextField.delegate = self
            self.setTextFieldCustomisation(textfield: self.userTypeTextField, name: UIConstants.signUpView.SuserType)
            self.userTypeTextField.rightView = self.UserTypeView
            self.userTypeTextField.rightViewMode = .always
            self.userTypeTextField.inputView = thePicker
            userTypeTextField.delegate = self
        }
    }
    
    @IBOutlet weak var genderTextfield : UITextField! {
        didSet {
            self.setTextFieldCustomisation(textfield: self.genderTextfield, name: UIConstants.signUpView.SgenderlabelTxt)
            self.genderTextfield.delegate = self
            self.genderTextfield.rightView = self.UserTypeView
            self.genderTextfield.rightViewMode = .always
            self.genderTextfield.inputView = thePicker
            genderTextfield.delegate = self
        }
    }
    
    @IBOutlet weak var genderLabel : UILabel! {
        didSet {
            self.genderLabel.text = UIConstants.signUpView.genderlabelTxt
        }
    }
    
    @IBOutlet weak var DOBLabel : UILabel! {
        didSet {
            self.DOBLabel.text = UIConstants.signUpView.DOBText
        }
    }
    
    @IBOutlet weak var dobTextField : UITextField! {
        didSet {
            self.setTextFieldCustomisation(textfield: self.dobTextField, name: UIConstants.signUpView.DOBTextPlaceHolder)
            self.dobTextField.delegate = self
            self.dobTextField.rightView = self.dobUserType
            self.dobTextField.rightViewMode = .always
            dobTextField.delegate = self
        }
    }
    
    
    //MARK: - Variable declarations
    let thePicker               = UIPickerView()
    let datePicker              = UIDatePicker()
    var activeTextField         : Int = 0
    let toolbar                 = UIToolbar()
    let otherPickerToolBar      = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thePicker.delegate = self
        thePicker.dataSource = self
        
        thePicker.backgroundColor = UIColor.textfieldClrSet(alpha: 1)
        
        //Date picker view
        showDatePicker()
        
        //toolbar initialising
        toolBarCreation()
        
        //Notification observer when the keyboard has been toggled
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Deinit the notification
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Action Outlets
    
    @IBAction func didClickCreateAccountButton(_ sender: AnyObject?) {
        // sign up to Realm
        self.showLoader()
        SignupViewModel.sharedInstance.signup { [weak self] response in
            guard let self = self else {return}
            //sync realm
            RealmManager.shared.syncMasterRealm { [weak self] response in
                guard let self = self else {return}
                //Finished
                //Check the organisation availale for the user logic
                DispatchQueue.main.async {
                    self.hideLoader()
                    //move to speciality and hospital selection screen
                    pushNavControllerStyle(storyBoardName: Storyboard.storyBoardName.mainBoard, vcId: Storyboard.storyBoardControllerID.specialityAdditionPage1, viewControllerName: self)
                }
            } onFailure: { [weak self] errorMessage in
                guard let self = self else {return}
                //if sync faile show alert and move to login page
                DispatchQueue.main.async {
                    self.hideLoader()
                    SignupViewModel.sharedInstance.clearUserDetails()
                    self.showMessageWithOkAction(message: failedSec.suncFailedTryLogin, title: failedSec.titleLogin, viewToShow: self)
                }
            }
        } onFailure: { [weak self] error in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.hideLoader()
                self.showMessage(message: "\n \(error)", title: failedSec.titleLogin)
            }
        }
    }
    
    /// Function to show the keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if activeTextField == 1 || activeTextField == 2 || activeTextField == 3 {
            self.title = ""
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height - 150
                }
            }
        }
    }
    
    /// Function to hide the key board
    @objc func keyboardWillHide(notification: NSNotification) {
        self.title = UIConstants.signUpView.signUpText
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
