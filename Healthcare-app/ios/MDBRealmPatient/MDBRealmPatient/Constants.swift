//
//  Constants.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/21/22.
//

import Foundation
import UIKit

/** Completion Handlet blocks */
typealias OnSuccess = (_ response: Any) -> Void
typealias OnFailure = (_ errorMessage: String) -> Void
typealias OnTaskSuccess = (_ status: Bool) -> Void

/** User Roles */
enum UserRole: String {
    case userType = "nurse/doctor/patient"
}
/** List of constants like maximum limits for text fields, image display ratio. */
struct Maximum {
    static let nameLength = 150
    static let emailLength = 80
    static let passwordLength = 20
}
/** List of all keys used in the app to store data in UserDefaults. */
struct Defaults {
    static let userId = "_id"
    static let userCustomDataId = "customDataId"
    static let userRole = "userRole"
    static let partition = "_partition"
    static let stores = "stores"
}

class Constants {
    static var shared    = Constants()

    // Storyboard instance
    static var mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
    static var dashboardStoryBoard = UIStoryboard.init(name: "Dashboard", bundle: nil)
}
class ConstantsID {
    
    struct LoginControllerID {
        static let logoImageName            = "logo"
        static let introText                = "Hey, \nLogin Now."
        static let placeHolderEmail         = "Email"
        static let passwordPlaceHolder      = "Password"
        static let signUpText1              = "Don’t have an account?"
        static let signUptext2              = "Sign up"
        static let loginText                = "LOGIN"
    }
    struct SignUpControllerID {
        static let lastNamePlaceHolder      = "Last Name"
        static let firstNamePlaceHolder     = "First Name"
        static let passwordPlaceHolder     = "Create Password"
        static let conformPasswordPlaceHolder     = "Conform Password"
        static let signupText                = "CREATE"
        static let nextText                = "NEXT"
        static let patientText                = "Patient"
        static let genderText                = "Select Gender"
        static let dobText                = "Select DOB"
        // Patient Basic Info
        static let condition = "Select Illness/Condition"
    }
    struct BookingControllerID {
        static let bookingButtonName            = "Book an Appointment"
    }

}
struct FieldValidation {
    //LoginSignup
    static let kAllEmpty        = "Please enter the email and password."
    static let kValidEmail      = "Please enter a valid email address."
    static let kPasswordEmpty   = "Please enter the password."
    static let kEmailEmpty      = "Please enter the email address."
    static let kFirstNameEmpty  = "Please enter the first name."
    static let kLastNameEmpty   = "Please enter the last name."
    static let kPasswordMismatch = "Passwords doesn't match."
    static let kUserRoleEmpty   = "Please select the user role."
    static let sourceStoreEmpty = "Please select source store"
    static let destinationStoreEmpty = "Please select destination store"
    static let droppOffAddressEmpty = "Please select drop off address"
    static let jobTypeEmpty = "Please select a job type"
    static let dateTimeEmpty    = "Please pick a date and time for delivery"
    static let assigneeEmpty    = "Please assign a delivery person"
    static let productEmpty     = "Please select product and its quantity to be delivered"
    static let customerNameEmpty = "Please enter the customer's name."
    static let customerEmailEmpty = "Please enter the customer's email."
    static let pickupTypeEmpty = "Please select the pickup type for this order."
    static let payTypeEmpty = "Please select the payment mode for this order"
    
    static let genderError = "Please select gender"
    static let dobError = "Please 'select Date Of Birth'"
    
    static let kConditionOptionEmpty      = "Please select condition."
    static let kConditionNotesEmpty      = "Please enter condition notes."
    
    
    static let kBookingDate     =   "Please select booking data."
    static let kBookingTime     =   "Please select booking time."
    static let kBookingConcern     =   "Please select concern."
}
