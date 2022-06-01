//
//  ProfileViewController.swift
//  MDBRealmPatient
//
//  Created by Mackbook on 11/05/22.
//

import UIKit
import RealmSwift

class ProfileViewController: BaseViewController {
    @IBOutlet weak var firstName: UITextField! {
        didSet {
            self.firstName.placeholder = ConstantsID.SignUpControllerID.firstNamePlaceHolder
            self.firstName.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
        }
    }
    @IBOutlet weak var lastName: UITextField! {
        didSet {
            self.lastName.placeholder = ConstantsID.SignUpControllerID.lastNamePlaceHolder
            self.lastName.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
        }
    }
    @IBOutlet weak var gender: UITextField! {
        didSet {
            self.gender.placeholder = ConstantsID.SignUpControllerID.genderText
            self.gender.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
        }
    }
    @IBOutlet weak var dob: UITextField! {
        didSet {
            self.dob.placeholder = ConstantsID.SignUpControllerID.dobText
            self.dob.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
        }
    }
    @IBOutlet weak var userType: UITextField! {
        didSet {
            self.userType.placeholder = ConstantsID.SignUpControllerID.dobText
            self.userType.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButtonToNav()
        self.title = "Profile"
        
        let user = RealmManager.shared.app.currentUser?.customData as? Dictionary<String, AnyObject>
        
        if let firstName = user?["firstName"] as? RealmSwift.AnyBSON {
            self.firstName.text = firstName.stringValue ?? ""
        }
        if let lastName = user?["lastName"] as? RealmSwift.AnyBSON {
            self.lastName.text = lastName.stringValue ?? ""
        }
        if let gender = user?["gender"] as? RealmSwift.AnyBSON {
            self.gender.text = gender.stringValue ?? ""
        }
        if let birthDate = user?["birthDate"] as? RealmSwift.AnyBSON {
            self.dob.text = birthDate.stringValue ?? ""
        }
        self.updateInputValue(isEnable: false)
    }
    func updateInputValue(isEnable: Bool) {
        self.firstName.isUserInteractionEnabled = isEnable
        self.lastName.isUserInteractionEnabled = isEnable
        self.gender.isUserInteractionEnabled = isEnable
        self.dob.isUserInteractionEnabled = isEnable
        self.userType.isUserInteractionEnabled = false
        
    }

}
