//
//  EditMedication_DoctorNotesViewController.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 22/04/22.
//

import UIKit
import RealmSwift

class EditMedication_DoctorNotesViewController: UIViewController {
    
    @IBOutlet weak var saveButton : UIButton! {
        didSet {
            self.saveButton.setTitle(UIConstants.editMedication.saveTitle, for: .normal)
            self.saveButton.backgroundColor = UIColor.appGeneralThemeClr()
        }
    }
    
    @IBOutlet weak var listTableView : UITableView! {
        didSet {
            self.listTableView.delegate = self
            self.listTableView.dataSource = self
            self.listTableView.tintColor  =  UIColor.appGeneralThemeClr()
        }
    }
    
    //MARK:- Variable declaration
    
    var isMedicationOrDoctorNotes       : Bool = false //true - medication false for doctore notes
    let searchController                = UISearchController(searchResultsController: nil)
    var searchActive                    : Bool = false
    var medicationListArr               : Results<Code>?
    var filteredArr                     : Results<Code>?
    var selectedMedicationArr           = [Code]()
    var receivedEnounterID              : String? = ""
    let medication                      = Medication()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        
        //register the cell
        self.listTableView.register(registerCells(cellIdentifier: "Hospital_SpecialityListUITableViewCell"), forCellReuseIdentifier: "Hospital_SpecialityListUITableViewCell")
        
        //get the list of medication to show
        self.medicationListArr = RealmManager.shared.getSpecialityList(searchType: "medicine-code")
        
        //get the already selected medication
        let selectedMedicationList = RealmManager.shared.getProcedureDetails(encounterID: receivedEnounterID ?? "")
        
        if selectedMedicationList?.usedReference.count ?? 0 > 0 {
            for i in 0..<(selectedMedicationList?.usedReference.first?.code?.coding.count ?? 0) {
                let instance = selectedMedicationList?.usedReference.first?.code?.coding[i]
                
                let instanceDec = Code()
                
                instanceDec.code = instance?.code
                instanceDec.system = instance?.system
                instanceDec.name = instance?.display
                
                self.selectedMedicationArr.append(instanceDec)
            }
        }
        
        print(self.selectedMedicationArr)
    }
    
    /// Function for register cells
    func registerCells(cellIdentifier : String) -> UINib {
        let nibCell = UINib(nibName: cellIdentifier, bundle: nil)
        return nibCell
    }
    
    //Action outlet for function
    @IBAction func didClickAddmedication(_ sender : UIButton) {
        //insert into code
        let dataSet = RealmManager.shared.changeCodeToCoding(listofCode: self.selectedMedicationArr)
        self.insertMedication(listData : dataSet)
    }
    
    ///Insert medication
    func insertMedication(listData : Codable_Concept) {
        var medicationList       = [Medication]()
        
        medication.code = listData
        
        medicationList.append(medication)
        
        RealmManager.shared.updateMedicationToProcedure(medicationList: medicationList, encounterID: self.receivedEnounterID ?? "", success: {
            status in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    //Navigation bar configuration
    ///Function for setting up the navigation controller
    func setUpNavBar() {
        self.title = isMedicationOrDoctorNotes == true ? UIConstants.editMedication.editMedicationPageTitle : UIConstants.doctorPrescription.doctorNotesTitle
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Poppins-SemiBold", size: 17)!
        ]
        
        //Left bar button item configuration
        let backUIBarButtonItemLeft = UIBarButtonItem(image: UIImage(named: UIConstants.signUpView.leftArrowImage), style: .plain, target: self, action: #selector(self.clickButton))
        self.navigationItem.leftBarButtonItem  = backUIBarButtonItemLeft
        
        //Search bar initialising
        searchController.searchBar.isHidden = isMedicationOrDoctorNotes == true ? false : true
        searchController.searchBar.searchTextField.backgroundColor = UIColor.textfieldClrSet(alpha: 0.5)
        searchController.searchBar.searchTextField.textColor = UIColor.textClrSearch()
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .black
        searchController.searchBar.searchTextField.font = UIFont(name: UIConstants.HomePage.fontFamily , size: 12)
        searchController.searchBar.placeholder = "Search medication"
        self.navigationItem.searchController = searchController
    }
    
    /// Fuction to pop the controller
    @objc func clickButton(){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - tableview extension
extension EditMedication_DoctorNotesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchActive == true ? filteredArr?.count ?? 0 : self.medicationListArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Hospital_SpecialityListUITableViewCell") as? HospitalListTableViewCell else {
            return UITableViewCell()
        }
        
        //instance creation
        let listData = self.searchActive == true ? filteredArr?[indexPath.row] : self.medicationListArr?[indexPath.row]
        
        cell.hospital_specialistLabel.text = listData?.name
        
        //check whether the existing array has the value or not
        cell.accessoryType = self.selectedMedicationArr.contains(where: { list in
            return list.name?.lowercased() == listData?.name?.lowercased()
        }) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //instance creation
        guard let listDataIndex = self.searchActive == true ? filteredArr?[indexPath.row] : self.medicationListArr?[indexPath.row] else { return}
        
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                //deselected the row
                cell.accessoryType = .none
                
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = .none
                    let filteredList = selectedMedicationArr.filter({ (listData) -> Bool in
                        return listData.name != listDataIndex.name
                    })
                    self.selectedMedicationArr.removeAll()
                    self.selectedMedicationArr = filteredList
                }
            } else {
                cell.accessoryType = .checkmark
                self.selectedMedicationArr.append(listDataIndex)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK: - Search delegate

extension EditMedication_DoctorNotesViewController : UISearchBarDelegate {
    
    internal func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    internal func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.listTableView.isHidden = false
        self.listTableView.reloadData()
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredArr = self.medicationListArr?.filter("name CONTAINS[c] %@", searchText.lowercased()).sorted(byKeyPath: "name", ascending: true)
        self.filteredArr =  searchText.isEmpty ? self.medicationListArr : self.filteredArr
        
        if(self.filteredArr?.count == 0) {
            searchActive = false
            self.listTableView.isHidden = true
        } else {
            searchActive = true
            self.listTableView.isHidden = false
        }
        self.listTableView.reloadData()
    }
}
