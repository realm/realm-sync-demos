//
//  SignUpViewController.swift
//  AppShowcase
//
//  Created by Karthick TM on 27/01/22.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    // MARK: -  Outlets
    @IBOutlet weak var scrollViewHeightConstraint : NSLayoutConstraint!

    // MARK: -  Labels

    @IBOutlet weak var signUpLabel : UILabel! {
       didSet {
           self.signUpLabel.text = ConstantsID.signUpControllerUI.signUpText
       }
   }
    @IBOutlet weak var firstNameLastNameLabel : UILabel! {
        didSet {
            self.firstNameLastNameLabel.text = ConstantsID.signUpControllerUI.firstnameLastname
        }
    }
    @IBOutlet weak var emailAddressLabel : UILabel! {
        didSet {
            self.emailAddressLabel.text = ConstantsID.signUpControllerUI.emailAddressTxt
        }
    }
    @IBOutlet weak var createPasswordLabel : UILabel! {
        didSet {
            self.createPasswordLabel.text = ConstantsID.signUpControllerUI.createPasswordTxt
        }
    }
    @IBOutlet weak var confirmPasswordLabel : UILabel! {
        didSet {
            self.confirmPasswordLabel.text = ConstantsID.signUpControllerUI.confirmPasswordTxt
        }
    }
    @IBOutlet weak var userTypeLabel : UILabel! {
        didSet {
            self.userTypeLabel.text = ConstantsID.signUpControllerUI.userTypeTxt
        }
    }
    // MARK: -  TextFields
    @IBOutlet weak var firstNameTxtField : UITextField! {
        didSet {
            self.setTextFieldCustomisation(textfield: self.firstNameTxtField, name: ConstantsID.signUpControllerUI.firstNameTxt)
        }
    }
    @IBOutlet weak var lastNameTxtField : UITextField! {
        didSet {
            self.setTextFieldCustomisation(textfield: self.lastNameTxtField, name: ConstantsID.signUpControllerUI.lastNameTxt)
        }
    }
    @IBOutlet weak var emailTextField : UITextField! {
        didSet {
            self.setTextFieldCustomisation(textfield: self.emailTextField, name: ConstantsID.signUpControllerUI.emailAddressTxt)
        }
    }
    @IBOutlet weak var createPasswordTextField : UITextField! {
        didSet {
            self.setTextFieldCustomisation(textfield: self.createPasswordTextField, name: ConstantsID.signUpControllerUI.createPasswordTxt)
            self.createPasswordTextField.rightView = self.btnDropDown
            self.createPasswordTextField.rightViewMode = .always
        }
    }
    @IBOutlet weak var confirmPasswordTextField : UITextField! {
        didSet {
            self.setTextFieldCustomisation(textfield: self.confirmPasswordTextField, name: ConstantsID.signUpControllerUI.confirmPasswordTxt)
            self.confirmPasswordTextField.rightView = self.btnDropDown1
            self.confirmPasswordTextField.rightViewMode = .always
        }
    }

    //MARK: - Buttons
    
    var btnALLTerritory = [UIButton]()
    
    @IBOutlet weak var backButton : UIButton! {
        didSet {
            self.backButton.setTitle("", for: .normal)
            self.backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        }
    }
    @IBOutlet weak var storeuserButton : UIButton! {
        didSet {
            self.storeuserButton.tag = 1
        }
    }
    @IBOutlet weak var deliveryPersonUserButton : UIButton! {
        didSet {
            self.deliveryPersonUserButton.tag = 2
        }
    }
    @IBOutlet weak var createButton : UIButton! {
        didSet {
            self.createButton.setTitle(ConstantsID.signUpControllerUI.createButtonTXT, for: .normal)
        }
    }
    ///Function for right view mode
    internal var btnDropDown: UIButton {
        let size: CGFloat = 25.0
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "showPwd"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -(size/2.0), bottom: 0, right: 0)
        button.frame = CGRect(x: self.createPasswordTextField.frame.size.width - size, y: 0.0, width: size, height: size)
        button.addTarget(self, action: #selector(showPwdBtnAction), for: .touchUpInside)
        return button
    }
    ///Function for right view mode
    internal var btnDropDown1: UIButton {
        let size: CGFloat = 25.0
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "showPwd"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -(size/2.0), bottom: 0, right: 0)
        button.frame = CGRect(x: self.confirmPasswordTextField.frame.size.width - size, y: 0.0, width: size, height: size)
        button.addTarget(self, action: #selector(showPwdBtnAction1), for: .touchUpInside)
        return button
    }
    
    // MARK: - Variables
    var viewModel = SignUpViewModel()
    
    //MARK: - View Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnALLTerritory = [storeuserButton,deliveryPersonUserButton]
    }
    
    //MARK: - Functions
    
    private func setTextFieldCustomisation(textfield : UITextField, name : String) {
        textfield.placeholder = name
        textfield.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
    }
    
    private func syncMasterRealmAndGotoManageStores() {
        self.showLoader()
        if let user = RealmManager.shared.app.currentUser {
            if user.isLoggedIn == true {
                // sync master partition
                RealmManager.shared.syncMasterRealm { completion in
                    if completion == false {
                        self.hideLoader()
                        self.showMessage(message: "Failed to open master")
                    }
                    // if store-user, do navigation to Add Stores screen
                    // if delivery user, goto delivery home
                    self.hideLoader()
                    let userRole = UserDefaults.standard.value(forKey: Defaults.userRole)
                    if userRole as! String == UserRole.storeUser.rawValue {
                        DispatchQueue.main.async {
                            self.pushVCAsPopup(withId: StoryboardID.manageStoresVC.rawValue, withStyle: .popover)
                        }
                    } else {
                        Router.setRootViewController()
                    }
                }
            } else {
                self.hideLoader()
                Router.gotoLogin()
            }
        } else {
            self.hideLoader()
            Router.gotoLogin()
        }

    }
    //MARK: - Button Actions

    @IBAction func userTypeRadioBtnTapped(_ sender: UIButton) {
        view.endEditing(true)
        for button in btnALLTerritory {
            if sender.tag == button.tag {
                // Delivery User
                button.isSelected = true;
                button.setImage(#imageLiteral(resourceName: "Checked"), for: .normal)
                self.viewModel.userRole = UserRole.deliveryUser
            }else {
                // Store User
                button.isSelected = false;
                button.setImage(#imageLiteral(resourceName: "UnChecked"), for: .normal)
                self.viewModel.userRole = UserRole.storeUser
            }
        }
    }
    
    @IBAction func didClickBackButton(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func showPwdBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        createPasswordTextField.isSecureTextEntry = !createPasswordTextField.isSecureTextEntry
    }
    
    @objc func showPwdBtnAction1(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        confirmPasswordTextField.isSecureTextEntry = !confirmPasswordTextField.isSecureTextEntry
    }
    
    @IBAction func createBtnAction(_ sender : UIButton) {
        // Login to Realm
        self.showLoader()
        self.viewModel.signup { response in
            // Open realm and sync changes
            self.syncMasterRealmAndGotoManageStores()
        } onFailure: { error in
            self.hideLoader()
            self.showMessage(message: error)
        }

    }
}

// MARK:- UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            if oldString.isEmpty && string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            var newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
            newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
            if textField == firstNameTxtField {
                if newString.count > Maximum.nameLength {
                    return false
                }
                viewModel.firstName = newString
            } else if textField == lastNameTxtField {
                if newString.count > Maximum.nameLength {
                    return false
                }
                viewModel.lastName = newString
            } else if textField == emailTextField {
                if newString.count > Maximum.emailLength {
                    return false
                }
                viewModel.email = newString
            } else if textField == createPasswordTextField  {
                if newString.count > Maximum.passwordLength {
                    return false
                }
                viewModel.pwd = newString
            } else if textField == confirmPasswordTextField {
                if newString.count > Maximum.passwordLength {
                    return false
                }
                viewModel.confirmPwd = newString
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTxtField {
            self.lastNameTxtField.becomeFirstResponder()
        } else if textField == lastNameTxtField {
            self.emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            self.createPasswordTextField.becomeFirstResponder()
        } else if textField == createPasswordTextField {
            self.confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            self.confirmPasswordTextField.resignFirstResponder()
            self.view.endEditing(true)
        }
        return true
    }
}
