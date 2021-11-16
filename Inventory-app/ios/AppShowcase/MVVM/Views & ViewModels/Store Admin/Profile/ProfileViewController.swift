//
//  ProfileViewController.swift
//  AppShowcase
//
//  Created by Brian Christo on 27/09/21.
//

import UIKit

class ProfileViewController: BaseViewController {
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var roleLbl: UILabel!
    @IBOutlet weak var storeLbl: UILabel!
    @IBOutlet weak var logoutBtn: BorderedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let user = RealmManager.shared.getMyUserInfo()
        firstNameLbl.text = user?.firstName
        lastNameLbl.text = user?.lastName
        emailLbl.text = user?.email
        roleLbl.text = user?.userRole?.capitalizingFirstLetter()
        storeLbl.text = user?.stores?.name
    }
    
    @IBAction func logoutBtnAction(_ sender: UIButton) {
        self.showAlertViewWithBlock(message: "Do you want to logout?", btnTitleOne: "Yes", btnTitleTwo: "No", completionOk: {()in
            DispatchQueue.main.async {
                RealmManager.shared.logoutAndClearRealmData()
            }
        }, cancel: {()in})
    }
}
