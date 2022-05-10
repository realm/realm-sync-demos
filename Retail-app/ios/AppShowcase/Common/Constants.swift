//
//  Constants.swift
//  WKBoilerPlate


import Foundation
import UIKit

/** An instance for the AppDelegate which is UIApplication.shared.delegate */
let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
var sceneDelegate: SceneDelegate {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let delegate = windowScene.delegate as? SceneDelegate else { return SceneDelegate() }
    return delegate
}

/** Completion Handlet blocks */
typealias OnSuccess = (_ response: Any) -> Void
typealias OnFailure = (_ errorMessage: String) -> Void
typealias OnTaskSuccess = (_ status: Bool) -> Void

/** User Roles */
enum UserRole: String {
    case storeUser = "store-user"
    case deliveryUser = "delivery-user"
}

enum JobStatus: String {
    case todo = "to-do"
    case inprogress = "in-progress"
    case done = "done"
}

enum JobType: String {
    case delivery = "Delivery"
    case installation = "Installation"
}

enum Paymentstatus: String {
    case pending = "Pending"
    case paid = "Paid"
    case failed = "Failed"
}

/** List of constants like maximum limits for text fields, image display ratio. */
struct Maximum {
    static let nameLength = 150
    static let emailLength = 80
    static let passwordLength = 20
}

struct Minimum {
    static let inventoryCount = 5
}

/** List of all keys used in the app to store data in UserDefaults. */
struct Defaults {
    static let userId = "_id"
    static let userCustomDataId = "customDataId"
    static let userRole = "userRole"
    static let partition = "_partition"
    static let stores = "stores"
//    static let accessToken = "accessToken"
//    static let refreshToken = "refreshToken"
}

/// List of all Storyboards used in the app.
struct Storyboards {
    static let launchScreen = "LaunchScreen"
    static let deliveryUser = "DeliveryUser"
    static let storeAdmin = "StoreAdmin"
    static let authentication = "Authentication"
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
}

struct StoryboardID:RawRepresentable,Hashable {
    
    static let loginNavigationController = StoryboardID(rawValue: "LoginNavController")
    static let homePageNavigationController = StoryboardID(rawValue:"StoreAdminHomeTabBarC")
    static let productDetailPage = StoryboardID(rawValue: "ProductDetailController")
    static let createJobViewController = StoryboardID(rawValue:"CreateJobViewController")
    static let jobDetailsViewController = StoryboardID(rawValue:"JobDetailsViewController")
    static let deliveryJobDetailsVC = StoryboardID(rawValue:"DeliveryJobDetailsViewController")
    static let searchViewController = StoryboardID(rawValue:"SearchViewController")
    static let selectionViewController = StoryboardID(rawValue:"SelectionViewController")
    static let signupVC  = StoryboardID(rawValue: "SignUpBoardVCID")
    static let manageStoresVC  = StoryboardID(rawValue: "ManageStoreViewController")
    static let slideUpSelectionVC =  StoryboardID(rawValue: "SlideUpSelectionViewController")
    static let createOrderViewController = StoryboardID(rawValue:"CreateOrderViewController")
    static let orderSummaryViewController = StoryboardID(rawValue:"OrderSummaryViewController")
    static let orderDetailsViewController = StoryboardID(rawValue:"OrderDetailsViewController")
    static let createJobForOrderViewController = StoryboardID(rawValue:"CreateJobForOrderViewController")

    var rawValue: String
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}
struct CellIdentifier{
    static let productCollectionViewCell = "ProductsCollectionViewCell"
    static let lowStockCell = "LowStockCell"
    static let jobsTableViewCell = "JobsTableViewCell"
    static let searchTableViewCell = "SearchTableViewCell"
    static let jobDetailTableViewCell = "JobDetailTableViewCell"
    static let deliveryJobDetailTableViewCell = "DeliveryJobDetailTableViewCell"
    static let productDetailTableViewCell = "ProductDetailsTableViewCell"
    static let productQuantityTableViewCell = "ProductQuantityTableViewCell"
    static let deliveryUserTableViewCell = "DeliveryUserTableViewCell"
    static let addedProductTableViewCell = "AddedProductTableViewCell"
    static let productTableViewCell = "ProductTableViewCell"
    static let storesTableViewCell = "StoreListTableViewCell"
    static let ordersTableViewCell = "OrdersTableViewCell"
}

class ConstantsID {
    
    struct LoginControllerID {
        static let logoImageName            = "Logogeneral"
        static let introText                = "Hey, \nLogin Now."
        static let placeHolderEmail         = "Email"
        static let passwordPlaceHolder      = "Password"
        static let signUpText1              = "Don’t have an account?"
        static let signUptext2              = "Sign up"
        static let loginText                = "LOGIN"
    }
    
    struct signUpControllerUI {
        static let signUpText                   = "Sign up"
        static let firstnameLastname            = "First Name & Last Name"
        static let firstNameTxt                 = "First Name"
        static let lastNameTxt                  = "Last Name"
        static let emailAddressTxt              = "Email Address"
        static let createPasswordTxt            = "Create Password"
        static let confirmPasswordTxt           = "Confirm Password"
        static let userTypeTxt                  = "User Type"
        static let storeuserTxt                 = "Store User"
        static let deliveryuserTxt              = "Delivery Person"
        static let createButtonTXT              = "CREATE ACCOUNT"
    }
    struct ManageStoreControllerUI {
        static let screenTitleText              = "Store(s) Associated"
        static let screenSubHeader              = "Select Stores"
        static let submitButtonText             = "SAVE STORES"
    }
    
}

