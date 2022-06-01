//
//  SignUpViewModel.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 27/04/22.
//

import Foundation
import RealmSwift

class SignupViewModel : NSObject {
 
    //Shared instance
    static let sharedInstance = SignupViewModel()
    
    var firstName       : String = ""
    var lastName        : String = ""
    var email           : String = ""
    var pwd             : String = ""
    var confirmPwd      : String = ""
    var userRole        : enumDeclarations.userTypes?
    var gender          : enumDeclarations.genderSelection?
    var dateofBirth     : String = ""
    var userDefaults    = UserDefaults.standard
    var signUpReferenceID   : ObjectId?
    
    
    //signup realm call
    func signup(onSuccess success: @escaping OnSuccess,
               onFailure failure: @escaping OnFailure) {
        validateForm { taskSuccess in
            // Realm Authentication
            
            RealmManager.shared.userCreation(firstName: self.firstName, lastName: self.lastName, userRole: self.userRole!, email: self.email, pwd: self.pwd, gender: self.gender!, dateOfBirth: self.dateofBirth) { [weak self] response in
                guard let self = self else {return}
                if response is [String : Any] {
                    self.saveUserDetails(userData: response as! [String : Any])
                }
                success(response)
            } onFailure: { [weak self] errorMessage in
                guard let _ = self else {return}
                print(errorMessage)
                failure(errorMessage)
            }
        } failure: { error in
            failure(error)
        }
    }
    
    ///Save user defaults details -- signup user details
    func saveUserDetails(userData: [String: Any]) {
        let dataSet = signUpModelData(dictionary: userData)
        
        //Assign to user defaults
        self.userDefaults.set(dataSet.firstName?.stringValue, forKey: userDefaultsConstants.userD.fUserName)
        self.userDefaults.set(dataSet.lastName?.stringValue, forKey: userDefaultsConstants.userD.lUserName)
        self.userDefaults.set(dataSet.gender?.stringValue, forKey: userDefaultsConstants.userD.userGender)
        self.userDefaults.set(dataSet.authUserId?.stringValue, forKey: userDefaultsConstants.userD.authUserId)
        self.userDefaults.set(dataSet.birthDate?.stringValue, forKey: userDefaultsConstants.userD.birthDate)
        self.userDefaults.set(dataSet.id?.stringValue, forKey: userDefaultsConstants.userD.id)
        self.userDefaults.set(dataSet.userType?.stringValue, forKey: userDefaultsConstants.userD.userType)
        self.userDefaults.set(dataSet.createdAt?.stringValue, forKey: userDefaultsConstants.userD.createdAt)
        self.userDefaults.set(dataSet.uuid?.stringValue, forKey: userDefaultsConstants.userD.uuid)
        self.userDefaults.set(dataSet.referenceId?.objectIdValue?.stringValue, forKey: userDefaultsConstants.userD.referenceId)
        self.userDefaults.set("0", forKey: userDefaultsConstants.userD.LoggedInUser)
        //1- logged in || 0 - signed up
    }
    
    ///Function clear userdetails
    func clearUserDetails() {
        self.userDefaults.set("", forKey: userDefaultsConstants.userD.fUserName)
        self.userDefaults.set("", forKey: userDefaultsConstants.userD.lUserName)
        self.userDefaults.set("", forKey: userDefaultsConstants.userD.userGender)
        self.userDefaults.set("", forKey: userDefaultsConstants.userD.authUserId)
        self.userDefaults.set("", forKey: userDefaultsConstants.userD.birthDate)
        self.userDefaults.set("", forKey: userDefaultsConstants.userD.id)
        self.userDefaults.set("", forKey: userDefaultsConstants.userD.userType)
        self.userDefaults.set("", forKey: userDefaultsConstants.userD.createdAt)
        self.userDefaults.set("", forKey: userDefaultsConstants.userD.uuid)
        self.userDefaults.set("", forKey: userDefaultsConstants.userD.referenceId)
        self.userDefaults.set("", forKey: userDefaultsConstants.userD.LoggedInUser)
    }
    
    /// Validates the signUp form
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
        
        if self.gender == nil {
            onFailure(FieldValidation.kGenderRoleEmpty)
            return
        }
        
        if self.dateofBirth == "" {
            onFailure(FieldValidation.kDOBEmpty)
            return
        }
        
        onTaskSuccess(true)
    }
}
