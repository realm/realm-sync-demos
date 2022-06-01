//
//  SpecialityAddition2ViewController.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 25/04/22.
//

import UIKit
import RealmSwift

class SpecialityAddition2ViewController: UIViewController {
    
    //Outlet
    
    @IBOutlet weak var addButton : UIButton! {
        didSet {
            self.addButton.setTitle(UIConstants.signUpView.addTitle, for: .normal)
            self.addButton.backgroundColor = UIColor.appGeneralThemeClr()
        }
    }
    
    @IBOutlet weak var specialityTableView : UITableView! {
        didSet {
            self.specialityTableView.delegate   = self
            self.specialityTableView.dataSource = self
            self.specialityTableView.tintColor  =  UIColor.appGeneralThemeClr()
        }
    }
    
    //Variable declaration
    var typeOfPage                   : Int = 0
    var specialistListArray          : Results<Code>?
    var hospitalListArray            : Results<Organization>?
    lazy var hospitalSelectionArray  = [Organization]()
    var searchActive                 : Bool = false
    var filterSpeciality             : Results<Code>?
    var filteredHospitalList         : Results<Organization>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        
        if typeOfPage == 1 {
            //Speciality selection
            specialistListArray = RealmManager.shared.getSpecialityList(searchType: "speciality")
        }else {
            hospitalListArray = RealmManager.shared.getTheOrganisationList()
        }
        
        specialityTableView.reloadData()
        
        specialityTableView.register(registerCells(cellIdentifier: "Hospital_SpecialityListUITableViewCell"), forCellReuseIdentifier: "Hospital_SpecialityListUITableViewCell")
    }
    
    ///Function for nav bar controller
    func setUpNavBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Poppins-SemiBold", size: 17)!
        ]
        
        //Left bar button item configuration
        let backUIBarButtonItemLeft = UIBarButtonItem(image: UIImage(named: UIConstants.signUpView.leftArrowImage), style: .plain, target: self, action: #selector(self.clickButton))
        self.navigationItem.leftBarButtonItem  = backUIBarButtonItemLeft
        
        //Search bar initialising
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.searchTextField.backgroundColor = UIColor.textfieldClrSet(alpha: 0.5)
        searchController.searchBar.searchTextField.textColor = UIColor.textClrSearch()
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .black
        searchController.searchBar.searchTextField.font = UIFont(name: UIConstants.HomePage.fontFamily , size: 12)
        self.navigationItem.searchController = searchController
        
        switch typeOfPage {
        case 1:
            //speciality selection
            self.title = UIConstants.signUpView.specialityTitle
            searchController.searchBar.placeholder = UIConstants.signUpView.specialityTitle
            self.addButton.isHidden = true
        case 2:
            //hospital selection
            self.title = UIConstants.signUpView.hospitalAdditionPage
            searchController.searchBar.placeholder = UIConstants.signUpView.searchHospitalField
            self.addButton.isHidden = false
            
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    /// Fuction to pop the controller
    @objc func clickButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Function for register cells
    func registerCells(cellIdentifier : String) -> UINib {
        let nibCell = UINib(nibName: cellIdentifier, bundle: nil)
        return nibCell
    }
    
    ///Action for addbutton
    @IBAction func didClickAddButton(_ sender : UIButton) {
        //board navigation
        self.navigationController?.popViewController(animated: true)
        
        let imageDataDict:[String: [Organization]] = ["listData": self.hospitalSelectionArray]
        
        self.hospitalSelectionArray.removeAll()
        
        NotificationCenter.default.post(name: .myNotification, object: nil, userInfo: imageDataDict)
    }
}

//MARK:- Table view delegates

extension SpecialityAddition2ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if typeOfPage == 1 {
            //speciality
            return searchActive == true ? filterSpeciality?.count ?? 0 : specialistListArray?.count ?? 0 > 0 ? specialistListArray?.count ?? 0 : 0
        }else {
            //hospital list
            return searchActive == true ? filteredHospitalList?.count ?? 0 : hospitalListArray?.count ?? 0 > 0 ? hospitalListArray?.count ?? 0 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Hospital_SpecialityListUITableViewCell") as? HospitalListTableViewCell else {
            return UITableViewCell()
        }
        // 0 - hospital list 1- speciality list
        //Instance creation
        var listData : Code?
        var listData1 : Organization?
        
        if typeOfPage == 1 {
            //speciality
            listData = searchActive == true ? self.filterSpeciality?[indexPath.row] : self.specialistListArray?[indexPath.row]
            cell.hospital_specialistLabel.text = listData?.name
        }else {
            //hospital
            //instance creation
            listData1 = searchActive == true ? self.filteredHospitalList?[indexPath.row] : self.hospitalListArray?[indexPath.row]
            
            //check whether the existing array has the value or not
            cell.accessoryType = self.hospitalSelectionArray.contains(where: { list in
                return list.name?.lowercased() == listData1?.name?.lowercased()
            }) ? .checkmark : .none
            cell.hospital_specialistLabel.text = listData1?.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //speciality Page
        if typeOfPage == 1 {
            //instance Creation
            let listData : Code?
            listData = searchActive == true ? filterSpeciality?[indexPath.row] : specialistListArray?[indexPath.row]
            
            if (listData != nil) {
                //board navigation
                self.navigationController?.popViewController(animated: true)
                
                let imageDataDict = ["SpecialityName": listData?.name, "specialityCode" : listData?.code, "specialitySystem" : listData?.system ]
                
                NotificationCenter.default.post(name: .myNotification, object: nil, userInfo: imageDataDict as [String : Any])
            }
        }else {
            //Hospital selection page
            //Instance Creation
            var listData2 : Organization?
            //Instance Creation
            listData2 = searchActive == true ? filteredHospitalList?[indexPath.row] : hospitalListArray?[indexPath.row]
            
            if let cell = tableView.cellForRow(at: indexPath) {
                if cell.accessoryType == .checkmark {
                    //deselected the row
                    cell.accessoryType = .none
                    
                    if let cell = tableView.cellForRow(at: indexPath) {
                        cell.accessoryType = .none
                        let filteredList = hospitalSelectionArray.filter({ (listData) -> Bool in
                            return listData.name != listData2?.name
                        })
                        self.hospitalSelectionArray.removeAll()
                        self.hospitalSelectionArray = filteredList
                    }
                } else {
                    cell.accessoryType = .checkmark
                    //  if let listDataHospital = hospitalListArray?[indexPath.row] {
                    hospitalSelectionArray.append(listData2 ?? Organization())
                    // }
                }
            }
        }
    }
}

//Mark:- Search bar delegae

extension SpecialityAddition2ViewController : UISearchBarDelegate {
    
    internal func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    internal func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.specialityTableView.isHidden = false
        self.specialityTableView.reloadData()
        
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //speciality page
        if typeOfPage == 1 {
            self.filterSpeciality = self.specialistListArray?.filter("name CONTAINS[c] %@", searchText.lowercased()).sorted(byKeyPath: "name", ascending: true)
            self.filterSpeciality =  searchText.isEmpty ? self.specialistListArray : self.filterSpeciality
            
            self.showViewOrNor(arrayListed: self.filterSpeciality, arrayListedHospital: nil)
        }else {
            //Hospital list page
            filteredHospitalList = self.hospitalListArray?.filter("name CONTAINS[c] %@", searchText.lowercased()).sorted(byKeyPath: "name", ascending: true)
            filteredHospitalList =  searchText.isEmpty ? self.hospitalListArray : self.filteredHospitalList
            
            self.showViewOrNor(arrayListed: nil, arrayListedHospital: self.filteredHospitalList)
        }
        self.specialityTableView.reloadData()
    }
    
    //Function to determine the tableview to show or not
    func showViewOrNor(arrayListed : Results<Code>?, arrayListedHospital : Results<Organization>?) {
        if (arrayListed?.count == 0) || arrayListedHospital?.count == 0 {
            searchActive = false
            self.specialityTableView.isHidden = true
        } else {
            searchActive = true
            self.specialityTableView.isHidden = false
        }
    }
}
