//
//  LoginViewController.swift
//  AppShowcase
//
//  Created by Brian Christo on 31/08/21.
//

import Foundation
import UIKit
class LoginViewController: BaseViewController {
    
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
            self.passwordTF.rightView = self.btnDropDown
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
    
    ///Function for right view mode
    internal var btnDropDown: UIButton {
        let size: CGFloat = 25.0
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "showPwd"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -(size/2.0), bottom: 0, right: 0)
        button.frame = CGRect(x: self.passwordTF.frame.size.width - size, y: 0.0, width: size, height: size)
        button.addTarget(self, action: #selector(showPwdBtnAction), for: .touchUpInside)
        return button
    }
    
    // MARK:- Variable Declarations
    var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel()
    }
    
    // MARK:- Actions
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        // Login to Realm
        self.showLoader()
        self.view.endEditing(true)
        self.viewModel.login { response in
            // Open realm and sync changes
            self.syncRealmDataAndGotoHome()
        } onFailure: { error in
            self.hideLoader()
            self.showMessage(message: "Login Failed. Please verify the credentials")
        }
    }
    
    @IBAction func signUPAction(_ sender: UIButton) {
        let vc = Router.getVC(withId: StoryboardID.signupVC.rawValue, fromStoryboard: Storyboards.authentication) as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showPwdBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTF.isSecureTextEntry = !passwordTF.isSecureTextEntry
    }
    
}

// MARK:- UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
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
