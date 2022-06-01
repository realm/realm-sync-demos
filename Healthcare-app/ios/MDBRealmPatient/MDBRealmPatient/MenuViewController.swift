//
//  MenuViewController.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/25/22.
//

import UIKit

class MenuViewController: BaseViewController {
    var yourMenuList = LocalStorage.defaultMenu()
    @IBOutlet var tableView         : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButtonToNav()
        self.title = "Menu"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }
}
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.yourMenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell)
        let object = self.yourMenuList[indexPath.row] as? [String: Any]
        cell.textLabel?.text = object?["menuName"] as? String
        cell.imageView?.image = UIImage(named: object?["menuIcon"] as? String ?? "")
        return cell
    }
}
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.yourMenuList[indexPath.row] as? [String: Any]
        switch object?["menuId"] as? Int {
        case 1:
            if let bookingHistoryVC =
                Constants.dashboardStoryBoard.instantiateViewController(withIdentifier: "BookingHistoryViewController") as? BookingHistoryViewController {
                self.navigationController?.pushViewController(bookingHistoryVC, animated: true)
            }
            break
        case 2:
            if let profileVC =
                Constants.dashboardStoryBoard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
            break
        case 3:
            self.showAlertViewWithBlock(message: "Do you want to logout?", btnTitleOne: "Yes", btnTitleTwo: "No", completionOk: {()in
                RealmManager.shared.logoutAndClearRealmData {
                    DispatchQueue.main.async {
                        self.hideLoader()
                        RealmManager.shared.clearUserDefaultsData()
                        self.setRootViewController()
                    }
                }
            }, cancel: {()in})
            break
            
        default:
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func setRootViewController() {
        if let viewControllers = self.navigationController?.viewControllers {
               for vc in viewControllers {
                    if vc.isKind(of: ViewController.classForCoder()) {
                        self.navigationController?.popToViewController(vc, animated: true)
                        return
                    }
               }
         }
        if let loginVC =
            Constants.mainStoryBoard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
}
