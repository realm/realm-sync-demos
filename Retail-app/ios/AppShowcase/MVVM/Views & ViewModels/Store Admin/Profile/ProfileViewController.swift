//
//  ProfileViewController.swift
//  AppShowcase
//
//  Created by Brian Christo on 27/09/21.
//

import UIKit

class ProfileViewController: BaseViewController {
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
//    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var roleLbl: UILabel!
    @IBOutlet weak var storeLbl: UILabel!
    @IBOutlet weak var logoutBtn: BorderedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let user = RealmManager.shared.getMyUserInfo()
        nameLbl.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
        emailLbl.text = user?.email
        roleLbl.text = user?.userRole?.capitalizingFirstLetter()
        if let store = RealmManager.shared.getMyStore() {
            storeLbl.text = store.name.capitalizingFirstLetter()
        }
        self.setStoreInfoOnNavBarRight()
        self.navigationItem.titleView = nil
        self.navigationItem.title = "My Profile"

    }
    
    @IBAction func logoutBtnAction(_ sender: UIButton) {
        self.showAlertViewWithBlock(message: "Do you want to logout?", btnTitleOne: "Yes", btnTitleTwo: "No", completionOk: {()in
            DispatchQueue.main.async {
                RealmManager.shared.logoutAndClearRealmData()
            }
        }, cancel: {()in})
    }
}
