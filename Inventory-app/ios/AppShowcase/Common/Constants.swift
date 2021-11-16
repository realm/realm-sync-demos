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
    case storeAdmin = "store-user"
    case deliveryUser = "delivery-user"
}

enum JobStatus: String {
    case todo = "to-do"
    case inprogress = "in-progress"
    case done = "done"
}

/** List of constants like maximum limits for text fields, image display ratio. */
struct Maximum {
    static let emailLength = 80
    static let passwordLength = 20
}

struct Minimum {
    static let inventoryCount = 10
}

/** List of all keys used in the app to store data in UserDefaults. */
struct Defaults {
    static let userId = "_id"
    static let userCustomDataId = "customDataId"
    static let userRole = "userRole"
    static let partition = "_partition"
    static let stores = "stores"
    static let accessToken = "accessToken"
    static let refreshToken = "refreshToken"
}

/// List of all Storyboards used in the app.
struct Storyboards {
    static let launchScreen = "LaunchScreen"
    static let main = "Main"
    static let storeAdmin = "HomePageForAdmin"
}
struct FieldValidation {
    //LoginSignup
    static let kAllEmpty        = "Please enter the email and password."
    static let kValidEmail      = "Please enter a valid email address."
    static let kPasswordEmpty   = "Please enter the password."
    static let kEmailEmpty      = "Please enter the email address."
    static let sourceStoreEmpty = "Please select source store"
    static let destinationStoreEmpty = "Please select destination store"
    static let dateTimeEmpty    = "Please pick a date and time for delivery"
    static let assigneeEmpty    = "Please assign a delivery person"
    static let productEmpty     = "Please select product and its quantity to be delivered"
}
struct StoryboardID:RawRepresentable,Hashable {
    
    static let KLoginNavigationController = StoryboardID(rawValue: "LoginNavController")
    static let KHomePageNavigationController = StoryboardID(rawValue:"StoreAdminHomeTabBarC")
    static let KProductDetailPage = StoryboardID(rawValue: "ProductDetailController")
    static let KCreateJobViewController = StoryboardID(rawValue:"CreateJobViewController")
    static let KJobDetailsViewController = StoryboardID(rawValue:"JobDetailsViewController")
    static let KSearchViewController = StoryboardID(rawValue:"SearchViewController")
    static let kSelectionViewController = StoryboardID(rawValue:"SelectionViewController")
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
    static let productDetailTableViewCell = "ProductDetailsTableViewCell"
    static let productQuantityTableViewCell = "ProductQuantityTableViewCell"
    static let deliveryUserTableViewCell = "DeliveryUserTableViewCell"
    static let addedProductTableViewCell = "AddedProductTableViewCell"
    static let productTableViewCell = "ProductTableViewCell"
}
