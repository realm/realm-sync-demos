//
//  LoginViewModel.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 27/04/22.
//

import Foundation
import RealmSwift

class LoginViewModel : NSObject {
    
    //Make shared instance
    static let sharedInstance   = LoginViewModel()
    
    //Variable declaration
    var email: String   = ""
    var pwd: String     = ""
    var userDefaults    = UserDefaults.standard
    var practReferenceID : ObjectId?
    
    //Make Login
    func triggerLogin(onSuccess success: @escaping OnSuccess,
               onFailure failure: @escaping OnFailure) {
        validateForm { taskSuccess in
            // Realm Authentication
            RealmManager.shared.appLogin(email: self.email, pwd: self.pwd) { [weak self] response in
                guard let self = self else {return}
                if response is [String : Any] {
                    self.saveUserDetails(userData: response as! [String : Any])
                }
                success(response)
            } onFailure: { error in
                failure(error)
            }
        } failure: { error in
            failure(error)
        }
    }
    
    ///Save user defaults details -- login user details
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
        self.practReferenceID = dataSet.referenceId?.objectIdValue
        self.userDefaults.set("1", forKey: userDefaultsConstants.userD.LoggedInUser)
        
        
        
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
        self.practReferenceID = nil
        self.userDefaults.set("", forKey: userDefaultsConstants.userD.LoggedInUser)
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
