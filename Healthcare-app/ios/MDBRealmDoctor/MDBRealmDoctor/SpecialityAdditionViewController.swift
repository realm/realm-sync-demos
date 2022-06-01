//
//  SpecialityAdditionViewController.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 25/04/22.
//

import UIKit
import RealmSwift

class SpecialityAdditionViewController: BaseType2ViewController {
    
    //Outlet
    @IBOutlet weak var specialityTitle : UILabel!
    
    @IBOutlet weak var hospitalAssociatedTitle : UILabel! {
        didSet {
            self.hospitalAssociatedTitle.text = UIConstants.signUpView.hospitalAdditionPage
        }
    }
    
    @IBOutlet weak var specialityTextField : UITextField! {
        didSet {
            self.specialityTextField.placeholder = UIConstants.signUpView.selectTxt
            self.specialityTextField.backgroundColor = UIColor.textfieldClrSet(alpha: 1)
            self.specialityTextField.rightView = self.UserTypeView
            self.specialityTextField.rightViewMode = .always
            self.specialityTextField.delegate = self
        }
    }
    
    @IBOutlet weak var addHospitalBtn : UIButton! {
        didSet {
            self.addHospitalBtn.layer.borderWidth = 1
            self.addHospitalBtn.layer.borderColor = UIColor.greenClr().cgColor
        }
    }
    
    @IBOutlet weak var hospitalAssociatedTableView : UITableView! {
        didSet {
            self.hospitalAssociatedTableView.delegate = self
            self.hospitalAssociatedTableView.dataSource = self
            self.hospitalAssociatedTableView.isHidden = true
        }
    }
    
    @IBOutlet weak var createAccountButton : UIButton! {
        didSet {
            self.createAccountButton.setTitle(UIConstants.signUpView.createButtonTXT, for: .normal)
            self.createAccountButton.backgroundColor = UIColor.appGeneralThemeClr()
        }
    }
    
    //Variable declaration
    lazy var hospitalListReceived  = [Organization]()
    var specialityCode             : String = ""
    var specialitySystem           : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        
        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: UIConstants.signUpView.notificationName), object: nil)
        
        //Set speciality title
        self.specialityTitle.text = UIConstants.signUpView.specialityTitle
        self.specialityTextField.isHidden = false
    }
    
    // handle notification
    @objc func showSpinningWheel(_ notification: NSNotification) {
        
        if let specialityName = notification.userInfo?[UIConstants.generalF.specialityName] as? String {
            //Set the speciality text field with value
            self.specialityTextField.text = specialityName
        }
        
        if let specialityCode = notification.userInfo?[UIConstants.generalF.specialityCode] as? String {
            //set specialityCode
            self.specialityCode = specialityCode
        }
        
        if let specialitySystem = notification.userInfo?[UIConstants.generalF.specialitySystem] as? String {
            //Set the speciality text field with value
            self.specialitySystem = specialitySystem
        }
        
        if let listData = notification.userInfo?["listData"] as? [Organization] {
            //Hospital list data
            self.hospitalAssociatedTableView.isHidden = listData.count > 0 ? false : true
            self.hospitalListReceived.removeAll()
            self.hospitalListReceived = listData
            self.hospitalAssociatedTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //func modify the nav controller
    func setUpNavBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = UIConstants.signUpView.welcomeTxt
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Poppins-SemiBold", size: 17)!
        ]
        
        //Left bar button item configuration
        let backUIBarButtonItemLeft = UIBarButtonItem(image: UIImage(named: "Logout"), style: .plain, target: self, action: #selector(self.clickButton))
        self.navigationItem.rightBarButtonItem  = backUIBarButtonItemLeft
        
        self.hospitalAssociatedTableView.register(registerCells(cellIdentifier: UIConstants.signUpView.specialityInitialPage), forCellReuseIdentifier: UIConstants.signUpView.specialityInitialPage)
    }
    
    /// Fuction to pop the controller
    @objc func clickButton(){
        //logout action
        getAlertFOrLogOut(controllerToInduce: self)
    }
    
    ///Internal function for
    ///Function for declaring the userType
    internal var UserTypeView: UIButton {
        let size: CGFloat = 25.0
        var filled = UIButton.Configuration.plain()
        filled.image = UIImage(named : UIConstants.signUpView.rightArrowTextField)
        filled.imagePlacement = .trailing
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.tintColor = UIColor.clear
        button.frame = CGRect(x: self.specialityTextField.frame.size.width - size, y: 0.0, width: size, height: size)
        return button
    }
    
    /// Function for register cells
    func registerCells(cellIdentifier : String) -> UINib {
        let nibCell = UINib(nibName: cellIdentifier, bundle: nil)
        return nibCell
    }
    
    //Action outlet
    @IBAction func didClickAddHospitalButton(_ sender : UIButton) {
        pushNavControllerWithvalue(StroryBoardName: Storyboard.storyBoardName.mainBoard, VcID: Storyboard.storyBoardControllerID.SpecialityAdditionPage, ViewControllerName: self, valueToPass: 2, hospitalSelectionList: self.hospitalListReceived)
    }
    
    
    @IBAction func didClickCreateAccountInSpeacilitySelection(_ sender : UIButton) {
        if specialityTextField.text == "" {
            showMessageWithoutAction(message: UIConstants.HomePage.selectSpeciality, title:UIConstants.doctorInfo.alertHeader, controllerToPresent: self)
            
        }else if self.hospitalListReceived.count == 0 {
            showMessageWithoutAction(message: UIConstants.HomePage.organisationSel, title:UIConstants.doctorInfo.alertHeader, controllerToPresent: self)
            
        }else {
            self.markInsertQueryforSIgnUp(success: {status in
                //move to homepage
                //user inserted into the realm
                pushNavControllerStyle(storyBoardName: Storyboard.storyBoardName.homeBoard, vcId: Storyboard.storyBoardControllerID.homeControllerID, viewControllerName: self)
            })
        }
    }
}

//Mark:- Table view extension
extension SpecialityAdditionViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hospitalListReceived.count > 0 ? hospitalListReceived.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalAssociatedTableViewCell") as? HospitalAssociatedTableViewCell else {
            return UITableViewCell()
        }
        
        //Instance creation
        let listData = hospitalListReceived[indexPath.row]
        
        cell.hospitalName.text = listData.name
        cell.deleteButton.tag  = indexPath.row
        
        //Delete closure
        cell.deleteHospitalFromList = { [weak self] indexR in
            guard let self = self else {return}
            
            self.hospitalListReceived.remove(at: indexR)
            
            self.hospitalAssociatedTableView.isHidden = self.hospitalListReceived.isEmpty ? true : false
            self.hospitalAssociatedTableView.reloadData()
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

//Mark:- textfield delegeate
extension SpecialityAdditionViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        pushNavControllerWithvalue(StroryBoardName: Storyboard.storyBoardName.mainBoard, VcID: Storyboard.storyBoardControllerID.SpecialityAdditionPage, ViewControllerName: self, valueToPass: 1, hospitalSelectionList: self.hospitalListReceived)
    }
}

//MARK:- form the update query
extension SpecialityAdditionViewController {
    
    ///Function to update the quer for signup
    func markInsertQueryforSIgnUp(success onTaskSuccess:@escaping OnTaskSuccess) {
        
        //find the practionerRole object based on user reference id
        guard let practitionerCreated = RealmManager.shared.getPractitionerById(practitinerId: UserDefaults.standard.value(forKey: userDefaultsConstants.userD.referenceId) as? String ?? "") else {return}
        
        self.hospitalListReceived.forEach { (listData) in
            let createInstance = PractitionerRole()
            
            createInstance.identifier   = ""
            createInstance.organization = listData
            createInstance.practitioner = practitionerCreated
            createInstance.active       = true
            createInstance.about        = ""
            
            //Practioner availability
            let availability = Availability()
            availability.allDay=true
            availability.availableStartTime  = "09:00"
            availability.availableEndTime    = "05:00"
            availability.daysOfWeek          = "mon|tue|wed|thu|fri"
            createInstance.availableTime     = availability
            
            //adding doctor's code
            let codableConcept    = Codable_Concept()
            let coding            = Coding()
            
            coding.system = "http://terminology.hl7.org/CodeSystem/practitioner-role"
            
            if RealmManager.shared.findUserType() == "doctor" {
                coding.display = "Doctor"
                coding.code = "doctor"
                codableConcept.text = "Doctor"
            }else{
                //Nurse
                coding.display = "Nurse"
                coding.code = "nurse"
                codableConcept.text = "Nurse"
            }
            
            codableConcept.coding.append(coding)
            
            createInstance.code = codableConcept
            // adding doctor's speciality
            let specialityConcept       = Codable_Concept()
            let specialityCoding        = Coding()
            specialityCoding.system     = self.specialitySystem
            specialityCoding.code       = self.specialityCode
            specialityCoding.display    = self.specialityTextField.text
            specialityConcept.coding.append(specialityCoding)
            specialityConcept.text      = self.specialityTextField.text
            
            createInstance.specialty = specialityConcept
            
            RealmManager.shared.insertOrUpdatePractRole(practionerRole: createInstance, id: UserDefaults.standard.value(forKey: userDefaultsConstants.userD.referenceId) as? String ?? "")
        }
        onTaskSuccess(true)
    }
}



