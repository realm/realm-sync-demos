//
//  BaseViewController.swift
//  WKBoilerPlate

import UIKit
import NVActivityIndicatorView
import SwiftUI

class BaseViewController: UIViewController, SlideUpSelectionDelegate {
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 80, y: 80, width: 60, height:60), type: .ballClipRotatePulse, color: .white)
    let blurView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    // MARK: - UI
    
    func setLogoOnNavBarLeftItem() {
        var image = UIImage(named: "HeaderLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: nil, action: nil)
    }
    
    func setStoreInfoOnNavBarRight() {
        var image = UIImage(named: "storeRed")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(swapStoreAction(_:)))
        if let store = RealmManager.shared.getMyStore() {
            let label = UILabel()
            label.text = store.name.capitalizingFirstLetter()
            label.textAlignment = .right
            self.navigationItem.titleView = label
        }
    }
    
    // MARK: - Realm Sync
    
    /// After login & Signup, Sync realms from required partitions and  initiate navigation to home screen of the user
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
                        if userRole as! String == UserRole.storeUser.rawValue {
                            let myUserInfo = RealmManager.shared.getMyUserInfo()
                            if myUserInfo?.stores.count ?? 0 > 0 {
                                let storeId = UserDefaults.standard.value(forKey: Defaults.stores)
                                // if active store is not set, then set the first store as active
                                if storeId == nil {
                                    UserDefaults.standard.setValue(myUserInfo?.stores.first?._id.stringValue, forKey: Defaults.stores)
                                }
                            }
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
//            DispatchQueue.main.async {
                Router.setRootViewController()
                return
//            }
        }
    }
    
    // MARK: - Actions
    @IBAction func btnBackAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func swapStoreAction(_ sender: UIBarButtonItem) {
        let viewC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardID.slideUpSelectionVC.rawValue) as! SlideUpSelectionViewController
        viewC.delegate = self
        viewC.modalPresentationStyle = .popover
        viewC.modalTransitionStyle = .coverVertical
        self.navigationController?.present(viewC, animated: true, completion: {
            
        })
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
    
    /// Stop showing activity indicator
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.blurView.isHidden = true
            
        }
    }

    // MARK: - Slide up  swap  store  delegate
    
    func didSwapStore(store: Stores) {
        UserDefaults.standard.setValue(store._id.stringValue, forKey: Defaults.stores)
        RealmManager.shared.syncStoreRealm { status in
            self.hideLoader()
            Router.setRootViewController()
        }
    }
}
