//
//  SceneDelegate.swift
//  MDBRealmDoctor
//
//  Created by Karthick T.M on 20/04/22.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /**
         Logged in sttaus is - 1
         Signed up status - 0
         No status - Nill
         */
        var view = UIViewController()
        
        //check logged In user
        if UserDefaults.standard.value(forKey: userDefaultsConstants.userD.LoggedInUser) as? String ?? "" == "1" || UserDefaults.standard.value(forKey: userDefaultsConstants.userD.LoggedInUser) as? String ?? "" == "0" {
            //Logged In user - 1
            //Signed up user - 0
            view = RealmManager.shared.routeHandling()
        }
        else if UserDefaults.standard.value(forKey: userDefaultsConstants.userD.LoggedInUser) as? String ?? "" == "" || UserDefaults.standard.value(forKey: userDefaultsConstants.userD.LoggedInUser) == nil{
            //No status move to login page
            
            view = Storyboard.mainStoryBoard.instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.loginControllerID)
        }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        let rootNC = UINavigationController(rootViewController: view)
        self.window?.rootViewController = rootNC
        self.window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

