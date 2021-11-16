//
//  BaseViewController.swift
//  WKBoilerPlate

import UIKit
import NVActivityIndicatorView
import SwiftUI

class BaseViewController: UIViewController {
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 80, y: 80, width: 60, height:60), type: .ballClipRotatePulse, color: .white)
    let blurView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
    }
        
    func syncRealmDataAndGotoHome() {
        
        self.showLoader()
        if let user = RealmManager.shared.app.currentUser {
            if user.isLoggedIn == true {
                // sync master partition
                RealmManager.shared.syncMasterRealm { completion in
                    if completion == false {
                        self.hideLoader()
                        self.showMessage(message: "Failed to open master")
                    }
                    // if store admin, sync store partition
                    if let userRole = UserDefaults.standard.value(forKey: Defaults.userRole) {
                        if userRole as! String == UserRole.storeAdmin.rawValue {
                            self.syncStoreRealmData()
                            return
                        }
                    }
                    // do navigation to Home page
                    self.hideLoader()
                    DispatchQueue.main.async {
                        Router.setRootViewController()
                        return
                    }
                }
            } else {
                self.hideLoader()
                Router.gotoLogin()
            }
        } else {
            self.hideLoader()
            Router.gotoLogin()
        }
    }
    
    private func syncStoreRealmData() {
        RealmManager.shared.syncStoreRealm { completed in
            if completed == false {
                self.showMessage(message: "Failed to open realm - store")
            }
            // do navigation to Home page
            self.hideLoader()
            DispatchQueue.main.async {
                Router.setRootViewController()
                return
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func btnBackAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Alerts
    
    /// Show Alert message
    /// - Parameter errorMsg: message to show
    func showErrorAlert(_ errorMsg: String) {
        self.showMessage(message: errorMsg, title: nil)
    }
    
    /// Alert message used to show any general messages
    func showMessage(message: String, title: String? = nil) {
        if (title?.isEmpty ?? true || title == "Oops!" ) && message.isEmpty == true {
            return
        }
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okBtnAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okBtnAction)
            self.present(alert, animated: true) {
            }
        }
    }
    
    func showAlertViewWithBlock(message: String,btnTitleOne: String,btnTitleTwo: String, completionOk:(() -> Void)? = nil, cancel: (() -> Void)? = nil, _ title: String? = nil) {
        
        let setTitle:String = title != nil ? title!: ""
        let alertView = UIAlertController(title: setTitle, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: btnTitleOne, style: .default, handler: { (alertAction) -> Void in
            if let okHandler = completionOk {
                okHandler()
            }
        }))
        if !btnTitleTwo.isEmpty {
            alertView.addAction(UIAlertAction(title: btnTitleTwo, style: .destructive, handler: { (alertAction) -> Void in
                if let cancelHandler = cancel {
                    cancelHandler()
                }
            }))
            
        }
        DispatchQueue.main.async {
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    // MARK: - Loader
    
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
    // MARK: - Stop loading view
    
    /// Stop showing activity indicator
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.blurView.isHidden = true
            
        }
    }
}
