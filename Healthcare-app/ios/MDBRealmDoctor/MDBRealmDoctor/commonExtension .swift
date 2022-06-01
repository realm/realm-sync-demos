//
//  commonExtension .swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import Foundation
import UIKit

//MARK: - Card view
/// FUnction for general card view
func cardView(view : UIView) {
    
    view.layer.cornerRadius = 10.0
    view.layer.shadowColor = UIColor.gray.cgColor
    view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    view.layer.shadowRadius = 3.0
    view.layer.shadowOpacity = 0.4
}


//FUnction for card view for UIImage
func cardViewImageView(view : UIImageView) {
    
    view.layer.shadowColor = UIColor.gray.cgColor
    view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    view.layer.shadowRadius = 3.0
    view.layer.shadowOpacity = 0.4
}


//MARK: - UINavigation controller extension
extension UINavigationController {
    
    ///Function for popView controller
    func popViewControllerWithHandler(animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: animated)
        CATransaction.commit()
    }
}

//MARK: - Extension for UINotification
///Notification name extension
extension Notification.Name {
    
    //Static variable for notification names
    static let myNotification = Notification.Name(UIConstants.signUpView.notificationName)
    static let filterNotification = Notification.Name(UIConstants.signUpView.filterNotification)
}

///Function to get the date in a specific format
func convertDateFormat(inputDate: String) -> String {
    
    let olDateFormatter = DateFormatter()
    olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    
    let oldDate = olDateFormatter.date(from: inputDate)
    
    let convertDateFormatter = DateFormatter()
    convertDateFormatter.dateFormat = "MMM dd yyyy, h:mm a"
    
    return convertDateFormatter.string(from: oldDate!)
}

//MARK: - Alert controller

func getAlertFOrLogOut(controllerToInduce : UIViewController) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: UIConstants.HomePage.logOutTitle, message: UIConstants.HomePage.logOutOption, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: UIConstants.HomePage.okTxt, style: .destructive, handler: { _ in
            RealmManager.shared.logoutAndClearRealmData(controllerInstance: controllerToInduce)
        }))
        
        alert.addAction(UIAlertAction.init(title:  UIConstants.HomePage.cancelTxt, style: .default, handler: nil))
        controllerToInduce.present(alert, animated: true, completion: nil)
    }
}

/// Action sheet without any ok action
func showMessageWithoutAction(message: String, title: String? = nil, controllerToPresent : UIViewController) {
    if (title?.isEmpty ?? true || title == UIConstants.doctorInfo.alertHeader ) && message.isEmpty == true {
        return
    }
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIDevice.isRunningOnIpad == true ? .alert : .actionSheet)
        let okBtnAction = UIAlertAction(title: UIConstants.HomePage.okTxt, style: .default, handler: nil)
        alert.addAction(okBtnAction)
        controllerToPresent.present(alert, animated: true) {
        }
    }
}

extension UIDevice {
    static let isRunningOnIpad = UIDevice.current.userInterfaceIdiom == .pad ? true : false
}
