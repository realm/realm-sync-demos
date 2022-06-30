//
//  DoctorInfoViewController.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 25/04/22.
//

import UIKit
import RealmSwift

class DoctorInfoViewController: BaseType2ViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var doctorInfotableView : UITableView! {
        didSet {
            self.doctorInfotableView.delegate = self
            self.doctorInfotableView.dataSource = self
        }
    }
    
    @IBOutlet weak var updateButton : UIButton! {
        didSet {
            self.updateButton.setTitle(UIConstants.doctorInfo.updateButtonTxt, for: .normal)
            self.updateButton.backgroundColor = UIColor.appGeneralThemeClr()
        }
    }
    
    //Variable declaration
    var listData                   : Results<PractitionerRole>?
    lazy var hospitalListReceived  = [Organization]()
    var specialityNameNotifi       : String = ""
    var specialityCode             : String = ""
    var specialitySystem           : String = ""
    var convertedBase64String      : String = ""
    var nameTextFieldData          : String = ""
    var aboutTextViewData          : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the navigation controller
        self.setUpNavController()
                
        //register the cells
        self.registerCellsForTableView()
        
        //Get the data from table to load details
        self.getTheListDataToLoad()
        
        //Notification observer when the keyboard has been toggled
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(self.specialitySelected(_:)), name: NSNotification.Name(rawValue: UIConstants.signUpView.notificationName), object: nil)
    }
    
    //MARK: - Action for update button
    @IBAction func didSelectUpdateButton(_ sender : UIButton) {
        //Method to make the update method possible
        RealmManager.shared.updateProfileDetails(code: self.specialityCode, display: self.specialityNameNotifi, system: self.specialitySystem, name: self.nameTextFieldData, about: self.aboutTextViewData) { [weak self] status in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.doctorInfotableView.reloadData()
                showMessageWithoutAction(message: UIConstants.doctorInfo.profileAlertMessage, title: UIConstants.doctorInfo.profileAlertTitle, controllerToPresent: self)
            }
        }
    }
}

//MARK: - General function extension
extension DoctorInfoViewController  {
    
    ///Function to register the cells
    func registerCellsForTableView() {
        //Register the first cell -- Profile Image
        doctorInfotableView.register(registerCells(cellIdentifier: UIConstants.doctorInfo.cellType1Image), forCellReuseIdentifier: UIConstants.doctorInfo.imageAddCellID)
        
        //register second cell
        doctorInfotableView.register(registerCells(cellIdentifier: UIConstants.doctorInfo.cellType2NameSpec), forCellReuseIdentifier: UIConstants.doctorInfo.type2CellNameProfile)
        
        //register third cell
        doctorInfotableView.register(registerCells(cellIdentifier: UIConstants.doctorInfo.cellType3About), forCellReuseIdentifier: UIConstants.doctorInfo.uitextViewCell)
    }
    
    //Function to get the data from table
    func getTheListDataToLoad() {
        if let userID = UserDefaults.standard.value(forKey: userDefaultsConstants.userD.referenceId) {
            listData = RealmManager.shared.getTheHospitalListInHomePage(practReferenceID: userID as? String ?? "")
            //set the basic string details
            self.nameTextFieldData = listData?.first?.practitioner?.name?.text ?? ""
            self.aboutTextViewData = listData?.first?.practitioner?.about ?? ""
            self.specialityNameNotifi = listData?.first?.specialty?.coding.first?.display ?? ""
            self.specialityCode = listData?.first?.specialty?.coding.first?.code ?? ""
            self.specialitySystem = listData?.first?.specialty?.coding.first?.system ?? ""
            //set speciality related details
            self.specialityNameNotifi = self.listData?.first?.specialty?.coding.first?.display ?? ""
            self.specialityCode = self.listData?.first?.specialty?.coding.first?.code ?? ""
            self.specialitySystem = self.listData?.first?.specialty?.coding.first?.system ?? ""
        }
    }
    
    //Notification implementatation function - Triggered when notification fired from speciality
    @objc func specialitySelected(_ notification: NSNotification) {
        
        if let specialityName = notification.userInfo?[UIConstants.doctorInfo.specialityNameID] as? String {
            //Set the speciality text field with value
            self.specialityNameNotifi = specialityName
        }
        if let specialityCode = notification.userInfo?[UIConstants.doctorInfo.specialityCodeID] as? String {
            //set specialityCode
            self.specialityCode = specialityCode
        }
        if let specialitySystem = notification.userInfo?[UIConstants.doctorInfo.specialitySystemID] as? String {
            //Set the speciality text field with value
            self.specialitySystem = specialitySystem
        }
        //reload to show the latest changes
        self.doctorInfotableView.reloadData()
    }
    
    ///Function to show the keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        self.title = ""
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 150
            }
        }
    }
    
    ///Function to hide the key board
    @objc func keyboardWillHide(notification: NSNotification) {
        self.title = UIConstants.doctorInfo.pageTitle
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //Set up navigation controller
    func setUpNavController() {
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = UIConstants.doctorInfo.pageTitle
        self.setUserRoleAndNameOnNavBar()
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: UIConstants.doctorInfo.fontNameFam, size: 17)!
        ]
        
        //Left bar button item configuration
        let backUIBarButtonItemLeft = UIBarButtonItem(image: UIImage(named: UIConstants.signUpView.leftArrowImage), style: .plain, target: self, action: #selector(self.clickButton))
        self.navigationItem.leftBarButtonItem  = backUIBarButtonItemLeft
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
}
