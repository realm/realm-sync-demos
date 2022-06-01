//
//  BaseViewController.swift
//  WKBoilerPlate

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController {
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 80, y: 80, width: 60, height:60), type: .pacman, color: UIColor.init(hexString: "#EE4557"))
    let blurView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    // MARK: - UI
    
    func setLogoOnNavBarLeftItem() {
        var image = UIImage(named: "HeaderLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: nil, action: nil)
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
    
    /// Stop showing activity indicator
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.blurView.isHidden = true
            
        }
    }
}
