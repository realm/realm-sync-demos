//
//  LoginViewModel.swift
//  AppShowcase
//
//  Created by Brian Christo on 31/08/21.
//

import Foundation
class LoginViewModel:NSObject{
    var email: String = ""
    var pwd: String = ""

    
    /// Login API call
    /// - Parameters:
    ///   - email: email address entered
    ///   - password: password entered
    ///   - completionHandler: completionHandler with success and error
    func login(onSuccess success: @escaping OnSuccess,
               onFailure failure: @escaping OnFailure) {
        validateForm { taskSuccess in
            // Realm Authentication
            RealmManager.shared.appLogin(email: self.email, pwd: self.pwd) { response in
                success(response)
            } onFailure: { error in
                failure(error)
            }
        } failure: { error in
            failure(error)
        }
    }
    
    /// Validates the login form
    func validateForm(success onTaskSuccess: OnTaskSuccess, failure onFailure: @escaping OnFailure) {
        let email = self.email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = self.pwd.trimmingCharacters(in: .whitespacesAndNewlines)
        if email.isEmpty && password.isEmpty {
            onFailure(FieldValidation.kAllEmpty)
            return
        }
        if email.isEmpty {
            onFailure(FieldValidation.kEmailEmpty)
            return
        }
        if password.isEmpty {
            onFailure(FieldValidation.kPasswordEmpty)
            return
        }
        if !email.isValidEmail() {
            onFailure(FieldValidation.kValidEmail)
            return
        }
        onTaskSuccess(true)
    }

}
