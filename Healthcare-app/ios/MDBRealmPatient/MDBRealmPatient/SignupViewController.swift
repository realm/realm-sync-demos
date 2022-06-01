//
//  SignupViewController.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/21/22.
//

import UIKit

class SignupViewController: BaseViewController {
    @IBOutlet weak var firstTF: UITextField! {
        didSet {
            self.firstTF.placeholder = ConstantsID.SignUpControllerID.firstNamePlaceHolder
            self.firstTF.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
        }
    }
    @IBOutlet weak var lastTF: UITextField! {
        didSet {
            self.lastTF.placeholder = ConstantsID.SignUpControllerID.lastNamePlaceHolder
            self.lastTF.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
        }
    }
    @IBOutlet weak var emailTF: UITextField! {
        didSet {
            self.emailTF.placeholder = ConstantsID.LoginControllerID.placeHolderEmail
            self.emailTF.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
        }
    }
    @IBOutlet weak var passwordTF: UITextField! {
        didSet {
            self.passwordTF.placeholder = ConstantsID.SignUpControllerID.passwordPlaceHolder
            self.passwordTF.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
        }
    }
    @IBOutlet weak var conformPasswordTF: UITextField! {
        didSet {
            self.conformPasswordTF.placeholder = ConstantsID.SignUpControllerID.conformPasswordPlaceHolder
            self.conformPasswordTF.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
        }
    }
    @IBOutlet weak var patientTF: UITextField! {
        didSet {
            self.patientTF.text = ConstantsID.SignUpControllerID.patientText
            self.patientTF.isUserInteractionEnabled = false
            self.patientTF.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
        }
    }
    @IBOutlet weak var genderTF: UITextField! {
        didSet {
            self.genderTF.placeholder = ConstantsID.SignUpControllerID.genderText
            self.genderTF.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
        }
    }
    @IBOutlet weak var dobTF: UITextField! {
        didSet {
            self.dobTF.placeholder = ConstantsID.SignUpControllerID.dobText
            self.dobTF.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
        }
    }
    @IBOutlet weak var createButton : UIButton! {
        didSet {
            self.createButton.setTitle(ConstantsID.SignUpControllerID.signupText, for: .normal)
        }
    }
    @IBOutlet private weak var showhidePwdBtn: UIButton!
    @IBOutlet private weak var showhideConformPwdBtn: UIButton!
    // MARK: - Variables
    var viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButtonToNav()
        self.title = "Sign Up"
    }
    @IBAction func showhidePwdAction(_ sender: UIButton) {
        showhidePwdBtn.isSelected = !showhidePwdBtn.isSelected
        passwordTF.isSecureTextEntry = !passwordTF.isSecureTextEntry
        conformPasswordTF.isSecureTextEntry = !conformPasswordTF.isSecureTextEntry
    }
    @IBAction func showhideConformPwdAction(_ sender: UIButton) {
        showhideConformPwdBtn.isSelected = !showhideConformPwdBtn.isSelected
        conformPasswordTF.isSecureTextEntry = !conformPasswordTF.isSecureTextEntry
    }
    // MARK: - IBAction
    @IBAction func actionDidCreate(_ sender: UIButton) {
        // Login to Realm
        self.showLoader()
        self.viewModel.signup { response in
            // Open realm and sync changes
            //self.syncMasterRealmAndGotoManageStores()
            DispatchQueue.main.async {
                self.syncRealmDataAndGotoHome()
            }
            
        } onFailure: { error in
            self.hideLoader()
            self.showMessage(message: error)
        }
    }
    // MARK: - Realm Sync
    
    /// After login & Signup, Sync realms from required partitions and  initiate navigation to home screen of the user
    func syncRealmDataAndGotoHome() {
        self.showLoader()
        if let user = RealmManager.shared.app.currentUser {
            if user.isLoggedIn == true {
                // sync master partition
                RealmManager.shared.syncMasterRealm { completion in
                    if completion == false {
                        self.hideLoader()
                        self.showMessage(message: "Failed to open master")
                    }
                    // do navigation to Home page
                    self.hideLoader()
                    DispatchQueue.main.async {
                        if let patientInfoVC =
                            Constants.mainStoryBoard.instantiateViewController(withIdentifier: "BasicPatientInfoViewController") as? BasicPatientInfoViewController {
                            self.navigationController?.pushViewController(patientInfoVC, animated: true)
                        }
                        return
                    }
                }
            } else {
                self.hideLoader()
            }
        } else {
            self.hideLoader()
        }
    }
    @IBAction func actionDidDOBOption(_ sender: Any) {
        self.view.endEditing(true)
        if let dobVC = Constants.mainStoryBoard.instantiateViewController(withIdentifier: "DOBViewController") as? DOBViewController {
            dobVC.modalPresentationStyle = .overCurrentContext
            dobVC.delegate = self
            dobVC.selectedDate = self.viewModel.dob
            self.present(dobVC, animated: false, completion: nil)
        }
    }
    @IBAction func actionDidGenderOption(_ sender: Any) {
        self.view.endEditing(true)
        if let genderVC = Constants.mainStoryBoard.instantiateViewController(withIdentifier: "GenderSelectionViewController") as? GenderSelectionViewController {
            genderVC.modalPresentationStyle = .overCurrentContext
            genderVC.delegate = self
            genderVC.selectedGender = self.viewModel.gender
            self.present(genderVC, animated: false, completion: nil)
        }
    }
}
// MARK:- UITextFieldDelegate
extension SignupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            if oldString.isEmpty && string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            var newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
            newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
            if textField == firstTF {
                if newString.count > Maximum.nameLength {
                    return false
                }
                viewModel.firstName = newString
            } else if textField == lastTF {
                if newString.count > Maximum.nameLength {
                    return false
                }
                viewModel.lastName = newString
            } else if textField == emailTF {
                if newString.count > Maximum.emailLength {
                    return false
                }
                viewModel.email = newString
            } else if textField == passwordTF  {
                if newString.count > Maximum.passwordLength {
                    return false
                }
                viewModel.pwd = newString
            } else if textField == conformPasswordTF {
                if newString.count > Maximum.passwordLength {
                    return false
                }
                viewModel.confirmPwd = newString
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstTF {
            self.lastTF.becomeFirstResponder()
        } else if textField == lastTF {
            self.emailTF.becomeFirstResponder()
        } else if textField == emailTF {
            self.passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            self.conformPasswordTF.becomeFirstResponder()
        } else if textField == conformPasswordTF {
            self.conformPasswordTF.resignFirstResponder()
            self.view.endEditing(true)
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == passwordTF {
            self.showhidePwdBtn.isHidden = false
        } else if textField == conformPasswordTF {
            self.showhideConformPwdBtn.isHidden = false
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.showhidePwdBtn.isHidden = true
        self.showhideConformPwdBtn.isHidden = true
        conformPasswordTF.isSecureTextEntry = true
        passwordTF.isSecureTextEntry = true
        return true
    }
}
extension SignupViewController: SelectGender {
    func didSelectGender(_ gender: String) {
        self.genderTF.text = gender
        self.viewModel.gender = gender
    }
}
extension SignupViewController: SelectDafeOfBirth {
    func didSelectDateofBirth(_ dob: String) {
        self.dobTF.text = dob
        self.viewModel.dob = dob
    }
}
