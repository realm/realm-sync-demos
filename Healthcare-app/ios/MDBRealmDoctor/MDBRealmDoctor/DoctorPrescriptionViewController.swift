//
//  DoctorPrescriptionViewController.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import UIKit
import RealmSwift

class DoctorPrescriptionViewController: UIViewController {
    
    @IBOutlet weak var doctorPrescriptionTableView : UITableView! {
        didSet {
            self.doctorPrescriptionTableView.delegate = self
            self.doctorPrescriptionTableView.dataSource = self
        }
    }
    
    //Variable declaration
    var doctor_nurse_ID     : String = ""
    var encounter_ID        : String = ""
    var organisation_ID     : String = ""
    
    //Indexpath 1
    var date_time           : String = ""
    var patientName         : String = ""
    var doctorName_Hospital : String = ""
    var illness_condition   : String = ""
    
    //Indexpath 2
    var concernDes          : String = ""
    var notificationToken   : NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        
        //Table viewCell declaration - Resiger of cells
        doctorPrescriptionTableView.register(registerCells(cellIdentifier: Storyboard.storyBoardControllerID.prescriptionType1), forCellReuseIdentifier: Storyboard.storyBoardControllerID.prescriptionType1)
        
        doctorPrescriptionTableView.register(registerCells(cellIdentifier: Storyboard.storyBoardControllerID.prescriptionType2), forCellReuseIdentifier: Storyboard.storyBoardControllerID.prescriptionType2)
        
        doctorPrescriptionTableView.register(registerCells(cellIdentifier: Storyboard.storyBoardControllerID.prescriptionType3), forCellReuseIdentifier: Storyboard.storyBoardControllerID.prescriptionType3)
        
        //get the list of nurse in the nurse list segment
        RealmManager.shared.nurseList = RealmManager.shared.findUserType() == "doctor" ? RealmManager.shared.nurseListSelection(orgID: self.organisation_ID) : nil
        
        
        let realm = try! Realm()
        let results = realm.objects(Procedure.self)
        
        
        notificationToken = results.observe({ _ in
            self.doctorPrescriptionTableView.reloadData()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.doctorPrescriptionTableView.reloadData()
    }
    
    ///Function for setting up the navigation controller
    func setUpNavBar() {
        self.title = UIConstants.doctorPrescription.pageTitle
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Poppins-SemiBold", size: 17) ?? ""
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
    
    ///Function for navigating to next controller
    func moveToNextController(index : Int) {
        guard let vc = UIStoryboard.init(name: Storyboard.storyBoardName.doctorPrescriptionBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.editMedication_DoctorNotesControllerID) as? EditMedication_DoctorNotesViewController else {return}
        
        vc.isMedicationOrDoctorNotes = index == 2 ? true : false
        
        vc.receivedEnounterID  = self.encounter_ID
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    ///Function to move to doctor notes
    func moveToDocNotes(indexB : Bool, notesReceived : String) {
        
        guard let vc = UIStoryboard.init(name: Storyboard.storyBoardName.doctorPrescriptionBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.editDoctor_nurseNotes) as? EditNotesViewController else {return}
        
        vc.isMedicationOrDoctorNotes = indexB
        //true - doctor false - Nurse
        
        vc.receivedEnounterID  = self.encounter_ID
        
        vc.doctor_NurseNotesText = notesReceived
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
