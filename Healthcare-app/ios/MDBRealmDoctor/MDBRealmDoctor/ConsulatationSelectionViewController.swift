//
//  ConsulatationSelectionViewController.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import UIKit
import RealmSwift

class ConsulatationSelectionViewController: UIViewController {
    
    @IBOutlet weak var consultationSelectionion : UILabel! {
        didSet {
            self.consultationSelectionion.text = UIConstants.consultation_session.consultation
        }
    }
    
    @IBOutlet weak var consultationTableView : UITableView! {
        didSet {
            self.consultationTableView.delegate = self
            self.consultationTableView.dataSource = self
            self.consultationTableView.isHidden = true
        }
    }
    
    @IBOutlet weak var filterButton : UIButton? {
        didSet {
            self.filterButton?.setTitle("", for: .normal)
            self.filterButton?.isHidden = true
        }
    }
    
    //Varible declaration
    var selectedHospital            : PractitionerRole?
    var consultationList            = [Encounter]()
    var searchActive                : Bool = false
    var filteredconsultationList    = [Encounter]()
    let searchController            = UISearchController(searchResultsController: nil)
    var notificationToken           : NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheNavBar()
        
        //Set initial data
        self.setIntitalData()
        
        //Register list of hospital tableview cell
        consultationTableView.register(registerCells(cellIdentifier: Storyboard.storyBoardControllerID.consultantCellID), forCellReuseIdentifier: Storyboard.storyBoardControllerID.consultantCellID)
        
        //Notification from filter page
        NotificationCenter.default.addObserver(self, selector: #selector(self.filterNavFunction(_:)), name: NSNotification.Name(rawValue: UIConstants.signUpView.filterNotification), object: nil)
        
        //
        let results = RealmManager.shared.masterRealm?.objects(Encounter.self)
        
        notificationToken =  results?.observe { change in
            guard let tableView = self.consultationTableView else { return }
            switch change {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, _, _, _):
                self.setIntitalData()
                // Query results have changed, so apply them to the UITableView
                tableView.reloadData()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    func setIntitalData() {
        //call the method get the list details
        let listDataSet = RealmManager.shared.getTheConsultationList(selectedOrgID: selectedHospital?.organization?._id ?? ObjectId(""))
        
        self.filterSet(arrayList: listDataSet)
    }
    
    //filter nav function
    @objc func filterNavFunction(_ notification: NSNotification) {
        if RealmManager.shared.selectedFilter != nil {
            //0 - yesterday 1- today 2- tomorrow
            let listDataSet = RealmManager.shared.getTheConsultationWithFilter(selectedOrgID: selectedHospital?.organization?._id ?? ObjectId(""), filterObj: RealmManager.shared.selectedFilter ?? 0)
            
            self.filterSet(arrayList: listDataSet)
        }else {
            //call the method get the list details
            let listDataSet = RealmManager.shared.getTheConsultationList(selectedOrgID: selectedHospital?.organization?._id ?? ObjectId(""))
            
            self.filterSet(arrayList: listDataSet)
        }
    }
    
    //filter Condition Set
    func filterSet(arrayList : [Encounter]) {
        
        guard arrayList.count > 0 else {
            self.searchController.searchBar.isHidden = true
            self.consultationTableView.isHidden = true
            return
        }
        
        self.consultationList = arrayList
        self.consultationTableView.isHidden = false
        self.filterButton?.isHidden = false
        self.searchController.searchBar.isHidden = false
    }
    
    //MARK: - Action outlet
    @IBAction func filterButtonTapped(_ sender : UIButton) {
        guard let popVC = UIStoryboard(name: Storyboard.storyBoardName.homeBoard, bundle: nil).instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.sort_FilterControllerID) as? Sort_FilterViewController else {return}
        popVC.modalPresentationStyle = .popover
        popVC.selectedFilterInt = RealmManager.shared.selectedFilter != nil ? RealmManager.shared.selectedFilter : nil
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.filterButton
        popOverVC?.sourceRect = CGRect(x: self.filterButton?.bounds.midX ?? 0, y: self.filterButton?.bounds.minY ?? 0, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 250, height: 250)
        self.present(popVC, animated: true)
    }
}

//MARK: - popover presenattion controller declaration
extension ConsulatationSelectionViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
