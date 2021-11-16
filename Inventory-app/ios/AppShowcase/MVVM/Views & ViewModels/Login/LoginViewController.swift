//
//  LoginViewController.swift
//  AppShowcase
//
//  Created by Brian Christo on 31/08/21.
//

import Foundation
import UIKit
class LoginViewController: BaseViewController {
    
    // MARK:- Variable Declarations
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel()
    }
    
    // MARK:- Actions

    @IBAction func loginBtnAction(_ sender: UIButton) {
        // Login to Realm
        self.showLoader()
        self.viewModel.login { response in
            // Open realm and sync changes
            self.syncRealmDataAndGotoHome()
        } onFailure: { error in
            self.hideLoader()
            self.showMessage(message: "Login Failed. Please verify the credentials")
        }
    }
    
    @IBAction func showPwdBtnAction(_ sender: UIButton) {
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
