//
//  Constants.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import Foundation
import UIKit
import RealmSwift


/** Completion Handlet blocks */
typealias OnSuccess = (_ response: Any) -> Void
typealias OnFailure = (_ errorMessage: String) -> Void
typealias OnTaskSuccess = (_ status: Bool) -> Void

//MARK: - enum declaration
class enumDeclarations {
    
    //enum for user types
    enum userTypes : String {
        case doctor                     = "doctor"
        case nurse                      = "nurse"
    }
    
    //enum for gender
    enum genderSelection : String {
        case male                       = "Male"
        case female                     = "Female"
        case others                     = "Others"
    }
}

//MARK: - Realm sync ID's
class RealmConstants {
    struct iOS_realmID {
        static let realmAppID                  = "phase3-refactor-sspmp"
    }
    
    struct objects {
        static let objectListArray              = [Organization.self,
                                                   Code.self,
                                                   Patient.self,
                                                   Practitioner.self,
                                                   PractitionerRole.self,
                                                   Encounter.self,
                                                   Address.self,
                                                   Attachment.self,
                                                   Codable_Concept.self,
                                                   Human_Name.self,
                                                   Diagnosis.self,
                                                   Encounter_Participant.self,
                                                   Reference.self,
                                                   Availability.self,
                                                   Appointment.self,
                                                   Coding.self,
                                                   Appointment_Participant.self,
                                                   Medication.self,
                                                   Procedure_Notes.self,
                                                   Users.self,
                                                   Procedure.self,
                                                   Condition.self]
    }
}


//MARK: - Userdefault Constants
class userDefaultsConstants {
    struct userD {
        static let fUserName                    = "fUserName"
        static let lUserName                    = "lUserName"
        static let userGender                   = "userGender"
        static let authUserId                   = "authUserId"
        static let birthDate                    = "birthDate"
        static let id                           = "id"
        static let userType                     = "userType"
        static let createdAt                    = "createdAt"
        static let uuid                         = "uuid"
        static let referenceId                  = "referenceId"
        static let LoggedInUser                 = "LoggedInUser"
        static let SignedUpUser                 = "SignedUpUser"
        static let specialityCodeList           = "specialityCodeList"
        static let partition                    = "_partition"
    }
}

//MARK: - For Storyboard declarations
class Storyboard {
    struct storyBoardName {
        static let mainBoard                    = "Main"
        static let homeBoard                    = "HomeStoryBoard"
        static let doctorPrescriptionBoard      = "DoctorPrescriptionStoryBoard"
    }
    
    struct storyBoardControllerID {
        static let signUpControllerID           = "SignUControllerVCID"
        static let homeControllerID             = "HomeBoardVCID"
        static let consultanrSessionID          = "consulatationVCID"
        static let consultantCellID             = "ConsultationSessionTableViewCell"
        static let sort_FilterControllerID      = "sort_FilterViewControllerID"
        static let doctorPrescriptionControllerID = "DoctorPrescriptionVCID"
        static let prescriptionType1               = "prescriptionType1Tableviewcell"
        static let prescriptionType2               = "PrescriptionType2TBCell"
        static let prescriptionType3               = "PrescriptionType3TableViewCell"
        static let editMedication_DoctorNotesControllerID = "EditMedication_DoctorNotesVCID"
        static let sideMenuControllerID             = "sideMenuVCID"
        static let doctorInfoVCID                   = "DoctorInfoVCID"
        static let SpecialityAdditionPage           = "SpecialityAddition2ViewControllerVCID"
        static let specialityAdditionPage1          = "specialityAdditionVC1"
        static let loginControllerID                = "LoginViewController"
        static let realFailedController             = "realmFailedController"
        static let waitingScreenController          = "SyncProgressScreeen"
        static let editDoctor_nurseNotes            = "EditNotesViewControllerVCID"
    }
    
    static let homeStoryBoard            =   UIStoryboard.init(name: storyBoardName.homeBoard, bundle: nil)
    
    static let mainStoryBoard            =   UIStoryboard.init(name: storyBoardName.mainBoard, bundle: nil)
    
    /** An instance for the AppDelegate which is UIApplication.shared.delegate */
    static let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
}

/** List of constants like maximum limits for text fields, image display ratio. */
struct Maximum {
    static let nameLength = 150
    static let emailLength = 80
    static let passwordLength = 20
}

//MARK: - UITextfield field validation
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
    static let kGenderRoleEmpty     = "Please select gender"
    static let kDOBEmpty            = "Please select 'Date Of Birth'"
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
}

//Failed Scenerios
struct failedSec {
    static let titleLogin                       = "Oops!!!!"
    static let loginFailed                      = "\n Login Failed, Please verify the credentials"
    static let syncFailed                       = "\n Sync failed, Please try again"
    static let suncFailedTryLogin               = "\n Sync failed, Account has been created,Please login."
}

//MARK: - Manager Keys
struct realmManagerKey {
    static let emailTXT                         = "email"
    static let passwordTXT                      = "password"
    static let userTypeTXT                      = "userType"
    static let userDataTXT                      = "userData"
    static let firstNameTXT                     = "firstName"
    static let lastNameTXT                      = "lastName"
    static let genderTXT                        = "gender"
    static let birthDateTXT                     = "birthDate"
    static let organizationTXt                  = "Organization"
    static let patientModelTXt                  = "Patient"
    static let practionerTXt                    = "Practitioner"
    static let practionerRoleTxt                = "PractitionerRole"
    static let codeTXT                          = "Code"
    static let encounrTXT                       = "Encounter"
    static let procedureTXT                     = "Procedure"
    static let userTXT                          = "Users"
    static let conditionTXT                     = "Condition"
    static let medicineCodeType                 = "medicine-code"
    static let nurseTXT                         = "Nurse"
    static let practionerCode                   = "Practitioner/Doctor"
    static let nurseCode                        = "Practitioner/Nurse"
    static let relativeCode                     = "Relative"
    static let typeOfUser                       = "doctor"
    static let nurseSmall                       = "nurse"
    static let addNewNurseCode                  = "http://snomed.info/sct"
    static let appoinmentModel                  = "Appointment"
}

//MARK: - For UI declaration
class UIConstants {
    
    struct LoginView {
        static let logoImageName                = "LogoGeneral"
        static let introText                    = "Hey, \nLogin Now."
        static let placeHolderEmail             = "Email"
        static let passwordPlaceHolder          = "Password"
        static let signUpText1                  = "Don’t have an account?"
        static let signUptext2                  = "Sign up"
        static let loginText                    = "LOGIN"
        static let passwordRightViewImage       = "showPwd"
        static let downArrowImage               = "DownArrow"
    }
    
    struct signUpView {
        static let signUpText                   = "Sign up"
        static let firstnameLastname            = "First Name & Last Name"
        static let firstNameTxt                 = "First Name"
        static let lastNameTxt                  = "Last Name"
        static let emailAddressTxt              = "Email Address"
        static let createPasswordTxt            = "Create Password"
        static let confirmPasswordTxt           = "Confirm Password"
        static let doctorUser                   = "Doctor"
        static let nurseUser                    = "Nurse"
        static let deliveryuserTxt              = "Delivery Person"
        static let createButtonTXT              = "SAVE"
        static let nextButtonTxt                = "CREATE"
        static let leftArrowImage               = "LeftArrow"
        static let checkedImage                 = "Checked"
        static let unCheckedImage               = "Unchecked"
        static let userType                     = "Role"
        static let SuserType                    = "Selecte Role"
        static let genderlabelTxt               = "Gender"
        static let SgenderlabelTxt              = "Select Gender"
        static let DOBText                      = "DOB"
        static let DOBTextPlaceHolder           = "Select DOB"
        static let userTypeData                 = ["Doctor", "Nurse"]
        static let genderTypeArray              = ["Male", "Female", "Others"]
        static let doneBtnTXt                   = "Done"
        static let cancelBtnText                = "Cancel"
        static let hospitalAdditionPage         = "Hospital(s) Associated"
        static let specialityTitle              = "Speciality"
        static let addTitle                     = "Add/Update"
        static let selectTxt                    = "Select"
        static let welcomeTxt                   = "Welcome"
        static let specialityInitialPage        = "HospitalAssociatedTableViewCell"
        static let rightArrowTextField          = "rightArrow"
        static let searchHospitalField          = "Search Hospital"
        static let doctorLowerCase              = "doctor"
        static let nurse                        = "nurse"
        static let notificationName             = "specialitySelectionNotification"
        static let filterNotification           = "filterNav"
    }
    
    struct HomePage {
        static let homePageTitle                = "Hospitals"
        static let menuLines                    = "line.3.horizontal"
        static let searchPlaceholder            = "Search Speciality or Hospitals"
        static let fontFamily                   = "SourceSansPro-Regular"
        static let subTitleLabel                = "List of Hospitals"
        static let listOfHospitalCells          = "ListOfHospitalTableViewCell"
        static let placeHolderImage             = "placeHolder"
        static let logOutOption                 = "\nAre you sure,to logout of 'AppShowcase'"
        static let logOutTitle                  = "Log Out!!!"
        static let okTxt                        = "Ok"
        static let cancelTxt                    = "Cancel"
        static let selectSpeciality             = "\nPlease select speciality"
        static let organisationSel              = "\nPlease select hospital"
    }
    
    struct Sort_FilterPage {
        static let titleTxt                     = "Filter"
        static let sortListArray                = ["Yesterday","Today","Tomorrow"]
        static let applyButtonTxt               = "Apply"
        static let clearFilter                  = "Clear"
        static let sortFilterName               = "Sort_FiltertableviewCell"
    }
    
    struct consultation_session {
        static let searchPlaceHolder            = "Search Patient"
        static let consultation                 = "Consultation Sessions"
    }
    
    struct doctorPrescription {
        static let pageTitle                    = "Doctor Prescription"
        static let concernTitle                 = "Concern"
        static let selectNurseTitle             = "Select Nurse"
        static let editButtonImage              = "Edit"
        static let concernSmilieImage           = "Smilie"
        static let medicationPrescribedImage    = "MedicationPrescribed"
        static let medicationPresTitle          = "Medications Prescribed"
        static let doctorNotesTitleImage        = "DoctorNotes"
        static let doctorNotesTitle             = "Doctor Note"
        static let nurseNotesTitle              = "Nurse Note"
        static let notAvailableTxt              = "Not Available"
        static let noteDescTxt                  = "Note description"
    }
    
    struct editMedication {
        static let editMedicationPageTitle      = "Medications"
        static let saveTitle                    = "SAVE"
    }
    
    struct sideMenu {
        static let menuTitle                    = "Menu"
        static let cellIdentifierId             = "SidemenuTableViewCell"
        static let menu                         : [SideMenuModel] = [
            SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: "Home"),
            SideMenuModel(icon: UIImage(named: "DoctorNotes")!, title: "My Profile"),
            SideMenuModel(icon: UIImage(named: "Logout")!, title: "Logout"),
        ]
    }
    
    struct doctorInfo {
        static let pageTitle            = "My Profile"
        static let imageAddCellID       = "imageLoadCellID"
        static let aboutDescTXT         = "About Description"
        static let nameTitle            = "Name"
        static let specialityTxt        = "Speciality"
        static let selectTxt            = "Select"
        static let updateButtonTxt      = "Update"
        static let cellType1Image       = "DoctorInfoTableViewCell"
        static let cellType2NameSpec    = "DoctorInfoNameEditTableView"
        static let cellType3About       = "DoctorInfoTextViewCell"
        static let specialityNameID     = "SpecialityName"
        static let specialityCodeID     = "specialityCode"
        static let specialitySystemID   = "specialitySystem"
        static let fontNameFam          = "Poppins-SemiBold"
        static let alertHeader          = "Oops!"
        static let profileAlertMessage  = "\n Profile updated"
        static let profileAlertTitle    = "Profile Update"
        static let uitextViewCell       = "DoctorInfoTextViewCell"
        static let type2CellNameProfile = "DoctorInfoNameEditTableView"
        static let chooseImageInstance  = "Profile Image"
        static let profileTitleImage    = "\n Please select a image to set as your 'Profile Picture'"
        static let snapAPic             = "Snap a photo"
        static let selectFromGallery    = "Select from photos"
        static let wariningText         = "Warning"
        static let cameraTxt            = "\nCamera could not be opened"
        static let personPhoto          = "man-2"
    }
    
    struct SideMenuModel {
        var icon                        : UIImage
        var title                       : String
    }
    
    //Struct for declaring general THing in the application
    struct generalF  {
        static let dateFormatSuggested  = "YYYY-MM-dd"
        static let errorMsgForNoteAdd   = "Please enter notes to update/add."
        static let specialityCode       = "specialityCode"
        static let specialityName       = "SpecialityName"
        static let specialitySystem     = "specialitySystem"
    }
}
