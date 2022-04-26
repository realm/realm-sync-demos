//
//  SignUpViewModel.swift
//  AppShowcase
//
//  Created by Brian Christo on 03/02/22.
//

import Foundation

class SignUpViewModel {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var pwd: String = ""
    var confirmPwd: String = ""
    var userRole: UserRole? // = UserRole.storeUser

    
    /// Login API call
    /// - Parameters:
    ///   - success: success callback with whole  reesponse dict
    ///   - failure: failure callback withh error message
    func signup(onSuccess success: @escaping OnSuccess,
               onFailure failure: @escaping OnFailure) {
        validateForm { taskSuccess in
            // Realm Authentication
            RealmManager.shared.userCreation(firstName: self.firstName, lastName: self.lastName, userRole: self.userRole, email: self.email, pwd: self.pwd, onSuccess: { response in
                success(response)
            }, onFailure: { error in
                failure(error)
            })
        } failure: { error in
            failure(error)
        }
    }
    
    /// Validates the login form
    func validateForm(success onTaskSuccess: @escaping OnTaskSuccess, failure onFailure: @escaping OnFailure) {
        let firstName = self.firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = self.lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = self.email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = self.pwd.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPassword = self.confirmPwd.trimmingCharacters(in: .whitespacesAndNewlines)
        if firstName.isEmpty && lastName.isEmpty && password.isEmpty && password.isEmpty {
            onFailure(FieldValidation.kAllEmpty)
            return
        }
        if firstName.isEmpty {
            onFailure(FieldValidation.kFirstNameEmpty)
            return
        }
        if lastName.isEmpty {
            onFailure(FieldValidation.kLastNameEmpty)
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
        if password != confirmPassword {
            onFailure(FieldValidation.kPasswordMismatch)
            return
        }
        if self.userRole == nil {
            onFailure(FieldValidation.kUserRoleEmpty)
            return
        }
        onTaskSuccess(true)
    }
}
