//
//  HomePageViewController.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import UIKit
import RealmSwift

class HomePageViewController: UIViewController {
    
    //Mark:- Outlets
    
    @IBOutlet weak var subTitlelabel : UILabel! {
        didSet {
            self.subTitlelabel.text = UIConstants.HomePage.subTitleLabel
        }
    }
    
    @IBOutlet weak var hospitalListTableView : UITableView! {
        didSet {
            self.hospitalListTableView.delegate = self
            self.hospitalListTableView.dataSource = self
            self.hospitalListTableView.allowsSelection = true
        }
    }
    
    @IBOutlet weak var filterButton : UIButton! {
        didSet {
            self.filterButton.setTitle("", for: .normal)
        }
    }
    
    //MARK:- Variable declaration
    var sideMenuViewController          : SidemenuViewController!
    var sideMenuShadowView              : UIView!
    var sideMenuRevealWidth             : CGFloat = 260
    let paddingForRotation              : CGFloat = 150
    var isExpanded                      : Bool = false
    var draggingIsEnabled               : Bool = false
    var panBaseLocation                 : CGFloat = 0.0
    // Expand/Collapse the side menu by changing trailing's constant
    var sideMenuTrailingConstraint      : NSLayoutConstraint?
    var revealSideMenuOnTop             : Bool = true
    var gestureEnabled                  : Bool = true
    var listDataHome                    : Results<PractitionerRole>?
    var filteredListDataHome            : Results<PractitionerRole>?
    var searchActive                    : Bool = false
    var notificationToken               : NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Declaring the nav bar
        setTheNavBar()
        
        //Register list of hospital tableview cell
        hospitalListTableView.register(registerCells(cellIdentifier: UIConstants.HomePage.listOfHospitalCells), forCellReuseIdentifier: UIConstants.HomePage.listOfHospitalCells)
        
        //set sidemenu properties
        setSideMenuProperties()
        
        self.getTheList()
        
      //  notificationToken =
    }
    
    //Get the list
    func getTheList() {
        //get the list data frm Realm
        if let userRefID = UserDefaults.standard.value(forKey: userDefaultsConstants.userD.referenceId) {
            listDataHome = RealmManager.shared.getTheHospitalListInHomePage(practReferenceID: userRefID as? String ?? "")
            self.hospitalListTableView.reloadData()
        }
    }
    
    //MARK:- Action outlets
    
    ///Function for filter popup
    @IBAction func didClickFilterAction(_ sender : UIButton) {
        let popVC = UIStoryboard(name: Storyboard.storyBoardName.homeBoard, bundle: nil).instantiateViewController(withIdentifier: "sort_FilterViewControllerID")
        
        popVC.modalPresentationStyle = .popover
        
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.filterButton
        popOverVC?.sourceRect = CGRect(x: self.filterButton.bounds.midX, y: self.filterButton.bounds.minY, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 250, height: 250)
        self.present(popVC, animated: true)
    }
    
}

//MARK:- popover presenattion controller declaration
extension HomePageViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
