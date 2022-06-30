//
//  BaseViewController.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import RealmSwift

class BaseViewController : UIViewController {
    
    //Variable Declaration
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 80, y: 80, width: 60, height:60), type: .pacman, color: UIColor.appGeneralThemeClr())
    let blurView = UIView()
    
    override func viewDidLoad() {
        //Set navigation controller
        setUpNavBar()
        
        //Hide keyboard when needed
        self.setupHideKeyboardOnTap()
    }
    
    ///Function for handling the navigation bar
    func setUpNavBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = UIConstants.signUpView.signUpText
        self.setUserRoleAndNameOnNavBar()
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        //Left bar button item configuration
        let backUIBarButtonItem = UIBarButtonItem(image: UIImage(named: UIConstants.signUpView.leftArrowImage), style: .plain, target: self, action: #selector(self.clickButton))
        self.navigationItem.leftBarButtonItem  = backUIBarButtonItem
    }
        
    /// Fuction to pop the controller
    @objc func clickButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //Function for setting uitextfield
    public func setTextFieldCustomisation(textfield : UITextField, name : String) {
        textfield.placeholder = name
        textfield.backgroundColor = UIColor.textfieldClrSet(alpha: 1)
    }
    
    /// Show activity indicator  on screen
    func showLoader() {
        DispatchQueue.main.async {
            self.blurView.isHidden = false
            
            self.blurView.frame = self.view.frame
            self.blurView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
            
            self.view.addSubview(self.blurView)
            self.activityIndicatorView.center = self.blurView.center
            self.view.addSubview(self.activityIndicatorView)
            
            self.activityIndicatorView.startAnimating()
        }
    }
    
    /// Stop showing activity indicator
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.blurView.isHidden = true
        }
    }
    
    /// Alert message used to show any general messages
    func showMessage(message: String, title: String? = nil) {
        if (title?.isEmpty ?? true || title == "Oops!" ) && message.isEmpty == true {
            return
        }
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIDevice.isRunningOnIpad == true ? .alert : .actionSheet)
            let okBtnAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okBtnAction)
            self.present(alert, animated: true,completion: nil)
        }
    }
    
    ///function for alert with ok action
    func showMessageWithOkAction(message: String, title: String? = nil, viewToShow : UIViewController) {
        if (title?.isEmpty ?? true || title == "Oops!" ) && message.isEmpty == true {
            return
        }
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIDevice.isRunningOnIpad == true ? .alert : .actionSheet)
            let okBtnAction = UIAlertAction(title: "Ok", style: .default) { _ in
                viewToShow.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okBtnAction)
            self.present(alert, animated: true,completion: nil)
        }
    }
    
    
    
    //MARK: - KeyBoard Dismiss
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
       func setupHideKeyboardOnTap() {
           self.view.addGestureRecognizer(self.endEditingRecognizer())
           self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
       }

       /// Dismisses the keyboard from self.view
       private func endEditingRecognizer() -> UIGestureRecognizer {
           let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
           tap.cancelsTouchesInView = false
           return tap
       }
}
