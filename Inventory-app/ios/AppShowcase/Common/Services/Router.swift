//
//  Router.swift
//  AppShowcase
//
//  Created by Brian Christo on 02/09/21.
//

import Foundation
import UIKit

class Router {
    /**
     To get viewcontrollers from Main storyboard
     - get viewcontrollers from main storyboard using their storyboard IDs
     - Parameter storyboardId: Storyboard ID of the requested viewcontroller
     - returns: the requested viewcontroller in it's file type
     */
    static func getVCFromMainStoryboard(withId storyboardId: String) -> Any {
        return self.getVC(withId: storyboardId, fromStoryboard: Storyboards.main)
    }
    /**
     To get viewcontrollers from storeAdmin storyboard
     - get viewcontrollers from storeAdmin storyboard using their storyboard IDs
     - Parameter storyboardId: Storyboard ID of the requested viewcontroller
     - returns: the requested viewcontroller in it's file type
     */
    static func getVCFromStoreAdminStoryboard(withId storyboardId: String) -> Any {
        return self.getVC(withId: storyboardId, fromStoryboard: Storyboards.storeAdmin)
    }
    /**
     To get viewcontrollers from storyboards
     - get viewcontrollers from storyboard using their storyboard IDs and storyboard name
     - Parameter storyboardName: name of the storyboard that contains the requested viewcontroller
     - Parameter storyboardId: Storyboard ID of the requested viewcontroller
     - returns: the requested viewcontroller in it's file type
     */
    static func getVC(withId storyboardId: String, fromStoryboard storyboardName: String) -> Any {
        let viewC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: storyboardId)
        return viewC
    }
    
    /// Set app window's rootviewcontroller.
    /// - If already authenticated, will get inside app
    /// - Else will be taken to authentication screen
    static func setRootViewController() {
        // if realm u=user is logged in and user role available, goto corresponding user's home. Else goto login
        if RealmManager.shared.app.currentUser?.isLoggedIn == true {
            if let userRole = UserDefaults.standard.value(forKey: Defaults.userRole) {
                DispatchQueue.main.async {
                    if userRole as! String == UserRole.storeAdmin.rawValue {
                        // goto store admin home
                        let viewC = Router.getVCFromStoreAdminStoryboard(withId: "StoreAdminHomeTabBarC") as! UITabBarController
                        sceneDelegate.window?.rootViewController = viewC
                        return
                    } else {
                        // goto Delivery user home
                        let viewC = Router.getVCFromMainStoryboard(withId: "DeliveryHomeNav") as! UINavigationController
                        sceneDelegate.window?.rootViewController = viewC
                        return
                    }
                }
            } else {
                // if not logged in, goto login
                Router.gotoLogin()
            }
        } else {
            // if not logged in, goto login
            Router.gotoLogin()
        }
    }
    
    static func gotoLogin() {
        DispatchQueue.main.async {
            let viewC = Router.getVCFromMainStoryboard(withId: "LoginNavController") as! UINavigationController
            sceneDelegate.window?.rootViewController = viewC
        }
    }
}
