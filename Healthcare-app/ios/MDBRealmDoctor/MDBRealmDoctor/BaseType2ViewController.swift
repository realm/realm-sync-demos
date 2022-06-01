//
//  BaseType2ViewController.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 27/04/22.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class BaseType2ViewController : UIViewController {
    
    //Variable Declaration
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 80, y: 80, width: 60, height:60), type: .pacman, color: UIColor.appGeneralThemeClr())
    let blurView = UIView()
    
    
    ///View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide keyboard when clicked outside
        self.setupHideKeyboardOnTap()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
    //MARK: - Loader
    
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
    
    ///function for alert with ok action - Type 2
    func showMessageWithOkActionType2(message: String, title: String? = nil, viewToShow : UIViewController, storyBoardName : String, vcIdentifier : String) {
        if (title?.isEmpty ?? true || title == "Oops!" ) && message.isEmpty == true {
            return
        }
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIDevice.isRunningOnIpad == true ? .alert : .actionSheet)
            let okBtnAction = UIAlertAction(title: "Ok", style: .default) { _ in
                pushNavControllerStyle(storyBoardName: storyBoardName, vcId: vcIdentifier, viewControllerName: viewToShow)
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
