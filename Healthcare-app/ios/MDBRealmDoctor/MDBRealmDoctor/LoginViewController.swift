//
//  LoginViewController.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import UIKit
import RealmSwift

class LoginViewController: BaseType2ViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var logoImageSet : UIImageView! {
        didSet {
            self.logoImageSet.image = UIImage(named: UIConstants.LoginView.logoImageName)
        }
    }
    
    @IBOutlet weak var introTextlabel : UILabel! {
        didSet {
            self.introTextlabel.text = UIConstants.LoginView.introText
        }
    }
    
    @IBOutlet weak var textFieldStackView : UIStackView! {
        didSet {
            self.textFieldStackView.setCustomSpacing(40, after: self.passwordTF)
        }
    }
    
    @IBOutlet weak var emailTF: UITextField! {
        didSet {
            self.emailTF.placeholder = UIConstants.LoginView.placeHolderEmail
            self.emailTF.backgroundColor = UIColor.textfieldClrSet(alpha: 1)
        }
    }
    
    @IBOutlet weak var passwordTF: UITextField! {
        didSet {
            self.passwordTF.placeholder = UIConstants.LoginView.passwordPlaceHolder
            self.passwordTF.backgroundColor = UIColor.textfieldClrSet(alpha: 1)
            self.passwordTF.rightView = self.btnDropDown
            self.passwordTF.rightViewMode = .whileEditing
        }
    }
    
    @IBOutlet weak var loginButton : UIButton! {
        didSet {
            self.loginButton.setTitle(UIConstants.LoginView.loginText, for: .normal)
            self.loginButton.backgroundColor = UIColor.appGeneralThemeClr()
        }
    }
    
    
    @IBOutlet weak var signUpButton : UIButton! {
        didSet {
            self.signUpButton.setTitle(UIConstants.LoginView.signUptext2, for: .normal)
            self.signUpButton.layer.borderColor = UIColor.appGeneralThemeClr().cgColor
            self.signUpButton.layer.borderWidth = 1
            self.signUpButton.layer.backgroundColor = UIColor.white.cgColor
            self.signUpButton.setTitleColor(UIColor.appGeneralThemeClr(), for: .normal)
        }
    }
    
    @IBOutlet weak var signInlabel : UILabel! {
        didSet {
            self.signInlabel.text = UIConstants.LoginView.signUpText1
        }
    }
    
    //MARK: - Action Outlets
    
    ///Function for signupButton
    @IBAction func didClickSignupButton(_ sender : UIButton) {
        pushNavControllerStyle(storyBoardName: Storyboard.storyBoardName.mainBoard, vcId: Storyboard.storyBoardControllerID.signUpControllerID, viewControllerName: self)
    }
    
    /// FUnction for login button
    @IBAction func didClickLoginButton(_ sender : AnyObject?) {
        //Show the loader
        self.showLoader()
        view.endEditing(true)
        
        self.passwordTF.isSecureTextEntry = true
        
        //Assigning value to singleton data
        LoginViewModel.sharedInstance.email = self.emailTF.text ?? ""
        LoginViewModel.sharedInstance.pwd = self.passwordTF.text ?? ""
        
        //Call the viewModel login execution
        LoginViewModel.sharedInstance.triggerLogin { [weak self] response in
            guard let self = self else {return}
            DispatchQueue.main.async {
                // Master Sync
                RealmManager.shared.syncMasterRealm(onSuccess: {response in
                    //handle view
                    DispatchQueue.main.async {
                        if let userRefId = UserDefaults.standard.value(forKey: userDefaultsConstants.userD.referenceId) {
                            
                            let tempData =  RealmManager.shared.getTheHospitalListInHomePage(practReferenceID: userRefId as? String ?? "")
                            
                            if tempData?.count ?? 0 > 0 {
                                // move to home page
                                pushNavControllerStyle(storyBoardName: Storyboard.storyBoardName.homeBoard, vcId: Storyboard.storyBoardControllerID.homeControllerID, viewControllerName: self)
                            }else {
                                //move to speciality and hospital selection screen
                                pushNavControllerStyle(storyBoardName: Storyboard.storyBoardName.mainBoard, vcId: Storyboard.storyBoardControllerID.specialityAdditionPage1, viewControllerName: self)
                            }
                        }else {
                            //Reference ID not found
                            self.hideLoader()
                            showMessageWithoutAction(message: failedSec.syncFailed, title: failedSec.titleLogin, controllerToPresent: self)
                        }
                    }
                }, onFailure: { [weak self] errorMessage in
                    guard let self = self else {return}
                    //handle error
                    self.hideLoader()
                    showMessageWithoutAction(message: failedSec.syncFailed, title: failedSec.titleLogin, controllerToPresent: self)
                    self.emailTF.text = ""
                    self.passwordTF.text = ""
                    LoginViewModel.sharedInstance.clearUserDetails()
                })
            }
        } onFailure: { [weak self] errorMessage in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.hideLoader()
                showMessageWithoutAction(message: failedSec.loginFailed, title: failedSec.titleLogin, controllerToPresent: self)
            }
        }
    }
    
    //MARK: - Function segments
    
    ///Function for  password text field right view mode
    internal var btnDropDown: UIButton {
        let size: CGFloat = 25.0
        var filled = UIButton.Configuration.plain()
        filled.image = UIImage(named : UIConstants.LoginView.passwordRightViewImage)
        filled.imagePlacement = .trailing
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.tintColor = UIColor.clear
        button.frame = CGRect(x: self.passwordTF.frame.size.width - size, y: 0.0, width: size, height: size)
        button.addTarget(self, action: #selector(showPwdBtnAction), for: .touchUpInside)
        return button
    }
    
    /// Function for button action
    @objc func showPwdBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTF.isSecureTextEntry = !passwordTF.isSecureTextEntry
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


//MARK:- UITextfield delegate

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            self.emailTF.resignFirstResponder()
            self.passwordTF.becomeFirstResponder()
        }else {
            self.passwordTF.resignFirstResponder()
            self.didClickLoginButton(nil)
        }
        return true
    }
}
