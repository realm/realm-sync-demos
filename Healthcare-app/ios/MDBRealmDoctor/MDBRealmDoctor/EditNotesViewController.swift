//
//  EditNotesViewController.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 11/05/22.
//

import UIKit

class EditNotesViewController: UIViewController {
    
    @IBOutlet weak var notesDescTitle : UILabel! {
        didSet{
            self.notesDescTitle.text = UIConstants.doctorPrescription.noteDescTxt
        }
    }
    
    @IBOutlet weak var notesTextField : UITextView! {
        didSet {
                self.notesTextField.layer.cornerRadius = 10
                self.notesTextField.layer.borderWidth = 0.0
                self.notesTextField.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
                self.notesTextField.layer.shadowOpacity = 1.0
                self.notesTextField.layer.shadowRadius = 1.0
                self.notesTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.notesTextField.backgroundColor = UIColor.doctorTextField()
        }
    }
    
    
    @IBOutlet weak var saveButton : UIButton! {
        didSet {
            self.saveButton.setTitle(UIConstants.editMedication.saveTitle, for: .normal)
            self.saveButton.backgroundColor = UIColor.appGeneralThemeClr()
        }
    }
    
    //Variable dec
    var isMedicationOrDoctorNotes       : Bool = false //true - medication false for doctore notes
    var receivedEnounterID              : String? = ""
    var doctor_NurseNotesText           : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        //navigation controller set
        setNavBar()
        
        //hide the keyboard
        self.setupHideKeyboardOnTap()
        
        //set the previous page note to the text field
        self.notesTextField.text = doctor_NurseNotesText
        
        //become first responder
        self.notesTextField.becomeFirstResponder()
    }
    
    ///Function for setting the nav controller
    func setNavBar() {
        self.title = isMedicationOrDoctorNotes == true ? UIConstants.doctorPrescription.doctorNotesTitle : UIConstants.doctorPrescription.nurseNotesTitle
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Poppins-SemiBold", size: 17)!
        ]
        
        //Left bar button item configuration
        let backUIBarButtonItemLeft = UIBarButtonItem(image: UIImage(named: UIConstants.signUpView.leftArrowImage), style: .plain, target: self, action: #selector(self.clickButton))
        self.navigationItem.leftBarButtonItem  = backUIBarButtonItemLeft
    }
    
    /// Fuction to pop the controller
    @objc func clickButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
//MARK: - Action outlet
    @IBAction func didClickSaveButton(_ sender : UIButton) {
        if self.notesTextField.text != "" {
            //check the note available or not
            //get the procedure list
            guard let procedureList = RealmManager.shared.getProcedureDetails(encounterID: receivedEnounterID ?? "") else {return}
            
            RealmManager.shared.getTheProcedureList(listProcedure: procedureList, noteReceived: self.notesTextField.text, receivedObj: UserDefaults.standard.value(forKey: userDefaultsConstants.userD.referenceId) as? String ?? "", success: { [weak self] status in
                guard let self = self else {return}
                if status {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }else {
            showMessageWithoutAction(message: UIConstants.generalF.errorMsgForNoteAdd, controllerToPresent: self)
        }
    }
    
    //MARK: - KeyBoard Dismiss
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
       func setupHideKeyboardOnTap() {
           self.view.addGestureRecognizer(self.endEditingRecognizer())
           self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
       }

       /// Dismisses the keyboard from self.view
       private func endEditingRecognizer() -> UIGestureRecognizer {
           let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
           tap.cancelsTouchesInView = false
           return tap
       }

}
