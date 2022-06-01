//
//  Sort_FilterViewController.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import UIKit

class Sort_FilterViewController: UIViewController {
    
    @IBOutlet weak var titleLabel : UILabel! {
        didSet {
            self.titleLabel.text = UIConstants.Sort_FilterPage.titleTxt
        }
    }
    
    @IBOutlet weak var filterTypesTableView : UITableView! {
        didSet {
            self.filterTypesTableView.delegate = self
            self.filterTypesTableView.dataSource = self
            self.filterTypesTableView.tintColor  =  UIColor.appGeneralThemeClr()
        }
    }
    
    @IBOutlet weak var applyButton : UIButton! {
        didSet{
            self.applyButton.setTitle(UIConstants.Sort_FilterPage.applyButtonTxt, for: .normal)
            self.applyButton.layer.backgroundColor = UIColor.white.cgColor
            self.applyButton.setTitleColor(UIColor.appGeneralThemeClr(), for: .normal)
        }
    }
    
    @IBOutlet weak var clearFilterButton : UIButton! {
        didSet{
            self.clearFilterButton.setTitle(UIConstants.Sort_FilterPage.clearFilter, for: .normal)
            self.clearFilterButton.layer.backgroundColor = UIColor.white.cgColor
            self.clearFilterButton.setTitleColor(UIColor.appGeneralThemeClr(), for: .normal)
        }
    }
    
    //Variable dec
    var selectedFilterInt : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        filterTypesTableView.register(registerCells(cellIdentifier: UIConstants.Sort_FilterPage.sortFilterName), forCellReuseIdentifier: UIConstants.Sort_FilterPage.sortFilterName)
    }
    
    /// Function for register cells
    func registerCells(cellIdentifier : String) -> UINib {
        let nibCell = UINib(nibName: cellIdentifier, bundle: nil)
        return nibCell
    }
    
    //MARK:- Action outlet
    @IBAction func didClickApplyFilterButton(_ sender : UIButton) {
        RealmManager.shared.selectedFilter = selectedFilterInt
        self.dismiss(animated: true)
        
        NotificationCenter.default.post(name: .filterNotification, object: nil, userInfo: nil)
    }
    
    @IBAction func didClickclearFilterButton(_ sender : UIButton) {
        RealmManager.shared.selectedFilter = nil
        self.selectedFilterInt = nil
        self.dismiss(animated: true)
        
        NotificationCenter.default.post(name: .filterNotification, object: nil, userInfo: nil)
    }

}

    //MARK:- Tableview extension
extension Sort_FilterViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Sort_FiltertableviewCell") as? Sort_FiltertableviewCell else {return UITableViewCell()}
        
        cell.eventName.text = UIConstants.Sort_FilterPage.sortListArray[indexPath.row]
        
        cell.accessoryType = self.selectedFilterInt == indexPath.row ? .checkmark : .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedFilterInt = indexPath.row
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                //deselected the row
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
            }
        }
        self.filterTypesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
