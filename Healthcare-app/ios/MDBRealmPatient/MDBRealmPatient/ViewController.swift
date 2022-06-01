//
//  ViewController.swift
//  MDBRealmPatient
//
//  Created by Brian Christo on 20/04/22.
//

import UIKit
import RealmSwift

class ViewController: BaseViewController {
    
    //Outlets
    @IBOutlet weak var logoImageSet : UIImageView! {
        didSet {
            self.logoImageSet.image = UIImage(named: ConstantsID.LoginControllerID.logoImageName)
        }
    }
    
    @IBOutlet weak var introTextlabel : UILabel! {
        didSet {
            self.introTextlabel.text = ConstantsID.LoginControllerID.introText
        }
    }
    
    @IBOutlet weak var textFieldStackView : UIStackView! {
        didSet {
            self.textFieldStackView.setCustomSpacing(40, after: self.passwordTF)
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
            self.passwordTF.placeholder = ConstantsID.LoginControllerID.passwordPlaceHolder
            self.passwordTF.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
            self.passwordTF.rightViewMode = .whileEditing
        }
    }
    
    @IBOutlet weak var loginButton : UIButton! {
        didSet {
            self.loginButton.setTitle(ConstantsID.LoginControllerID.loginText, for: .normal)
        }
    }
    @IBOutlet weak var signUpButton : UIButton! {
        didSet {
            self.signUpButton.setTitle(ConstantsID.LoginControllerID.signUptext2, for: .normal)
            self.signUpButton.layer.borderColor = UIColor.init(hexString: UIColor.Colors.appThemeColorOrange, alpha: 1).cgColor
            self.signUpButton.layer.borderWidth = 1
            self.signUpButton.layer.backgroundColor = UIColor.white.cgColor
            self.signUpButton.setTitleColor(UIColor.init(hexString: UIColor.Colors.appThemeColorOrange, alpha: 1), for: .normal)
        }
    }
    
    @IBOutlet weak var signInlabel : UILabel! {
        didSet {
            self.signInlabel.text = ConstantsID.LoginControllerID.signUpText1
        }
    }
    lazy private var singleTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onSingleTapped))
        gesture.cancelsTouchesInView = true
        return gesture
    }()
    // MARK:- Variable Declarations
    var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(singleTapGesture)
        viewModel = LoginViewModel()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    // MARK: - Keyboard Functions
    @objc func onSingleTapped() {
        self.emailTF.resignFirstResponder()
        self.passwordTF.resignFirstResponder()
    }
    // MARK: - IBAction
    @IBAction func signUPAction(_ sender: UIButton) {
        // signUPAction to Realm
        if let signUPVC =
            Constants.mainStoryBoard.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController {
            self.navigationController?.pushViewController(signUPVC, animated: true)
        }
    }
    @IBAction func actionDidCreate(_ sender: UIButton) {
        // Login to Realm
        self.showLoader()
        self.view.endEditing(true)
        self.viewModel.login { response in
            // Open realm and sync changesself.hideLoader()
            self.hideLoader()
            self.syncRealmDataAndGotoHome()
        } onFailure: { error in
            self.hideLoader()
            self.showMessage(message: "Login Failed. Please verify the credentials")
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
                        self.emailTF.text = ""
                        self.passwordTF.text = ""
                        self.openDashboard()
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
    func openDashboard() {
        if let dashboardVC =
            Constants.dashboardStoryBoard.instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController {
            self.navigationController?.pushViewController(dashboardVC, animated: true)
        }
    }
}

// MARK:- UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            if oldString.isEmpty && string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            var newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
            newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
            if textField == emailTF {
                if newString.count > Maximum.emailLength {
                    return false
                }
                viewModel.email = newString
            } else if textField == passwordTF {
                if newString.count > Maximum.passwordLength {
                    return false
                }
                viewModel.pwd = newString
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField)  {
        if textField == passwordTF {
            viewModel.pwd = textField.text ?? ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            self.passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            self.passwordTF.resignFirstResponder()
            self.view.endEditing(true)
        }
        return true
    }
}
