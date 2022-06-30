//
//  DoctorPrescription+TableviewExtension.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import Foundation
import UIKit
import RealmSwift

extension DoctorPrescriptionViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.storyBoardControllerID.prescriptionType1) as? prescriptionType1Tableviewcell else {return UITableViewCell()}
            
            cell.timeStamp.text = convertDateFormat(inputDate: self.date_time)
            
            cell.PatientName.text = self.patientName
            
            cell.doctorName_HospitalName.text = self.doctorName_Hospital
            
            cell.condition_Illness.text = "Illness Condition - \(self.illness_condition)"
            
            return cell
            
        case 1:
            //Concern view
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.storyBoardControllerID.prescriptionType3) as? PrescriptionType3TableViewCell else {return UITableViewCell()}
            
            cell.titleImageView.image = UIImage(named: UIConstants.doctorPrescription.concernSmilieImage)
            
            cell.titleTxt.text = UIConstants.doctorPrescription.concernTitle
            
            cell.editButton.isHidden = true
            
            cell.descContent.text = self.concernDes == "" ? UIConstants.doctorPrescription.notAvailableTxt : self.concernDes
            
            return cell
            
        case 2:
            //Medication Prescribed
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.storyBoardControllerID.prescriptionType3) as? PrescriptionType3TableViewCell else {return UITableViewCell()}
            
            cell.titleImageView.image = UIImage(named: UIConstants.doctorPrescription.medicationPrescribedImage)
            
            cell.titleTxt.text = UIConstants.doctorPrescription.medicationPresTitle
            
            cell.editButton.tag = indexPath.row
            
            //find the type of user and hide the edit button for nurse
            cell.editButton.isHidden = RealmManager.shared.findUserType() == "doctor" ? false : true
            
            //content
            cell.descContent.text = RealmManager.shared.getTheMedicationPrescribed(encounterID: self.encounter_ID) == "" ? UIConstants.doctorPrescription.notAvailableTxt : RealmManager.shared.getTheMedicationPrescribed(encounterID: self.encounter_ID)
            
            //  Navigate to edit medication screen
            cell.didTapEditButton = {[weak self] indexR in
                guard let self = self else {return}
                self.moveToNextController(index: indexR)
            }
            
            return cell
            
        case 3:
            //Doctor notes
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.storyBoardControllerID.prescriptionType3) as? PrescriptionType3TableViewCell else {return UITableViewCell()}
            
            cell.titleImageView.image = UIImage(named: UIConstants.doctorPrescription.doctorNotesTitleImage)
            
            cell.titleTxt.text = UIConstants.doctorPrescription.doctorNotesTitle
            
            cell.editButton.tag = indexPath.row
            
            cell.editButton.isHidden = RealmManager.shared.findUserType() == "doctor" ? false : true
            
            //      Navigate to edit medication screen
            cell.didTapEditButton = { [weak self] indexReceved in
                
                guard let self = self else {return}
                
                //Move to edit screen of doctor
                self.moveToDocNotes(indexB: true, notesReceived: (cell.descContent.text == UIConstants.doctorPrescription.notAvailableTxt ? "" : cell.descContent.text) ?? "")
            }
            
            //get doctor or nurse notes based
            cell.descContent.text = RealmManager.shared.getDoctorNotes(referenceID: encounter_ID, isDoctorNurseID: doctor_nurse_ID, typeOfUser: "doc")
            
            return cell
            
        case 4:
            //nurse show the edit button hide for doctor
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.storyBoardControllerID.prescriptionType2) as? PrescriptionType2TBCell else {return UITableViewCell()}
            
            cell.titleImageView.image = UIImage(named: UIConstants.doctorPrescription.doctorNotesTitleImage)
            
            cell.titleTxt.text = UIConstants.doctorPrescription.nurseNotesTitle
            
            cell.editButton.isHidden = RealmManager.shared.findUserType() == "doctor" ? true : false
            
            cell.selectNurseTextField.text = RealmManager.shared.showSelectedNurse(encounter_ID: self.encounter_ID)
            cell.isNurseAssigned =  !cell.selectNurseTextField.text!.isEmpty
            //nurse seletion
            if RealmManager.shared.findUserType() == "doctor" {
                //doctor
                cell.selectNurseLabel.isHidden = false
                
                cell.selectNurseTextField.isHidden = false
                
               
                
                cell.parentVC = self;
                cell.pickerSelectedData = { listData in
                    self.title = UIConstants.doctorPrescription.pageTitle
                    
                    
                    RealmManager.shared.updateSelectedNurseByDoctor(nurseID: listData.practitioner?._id ?? ObjectId(""), nurseIdentifier: listData.practitioner?.identifier ?? "", encounterID: self.encounter_ID, success: { [weak self] status in
                        guard let self = self else {return}
                        if status {
                            self.view.endEditing(true)
                            //move the view down
                            if self.view.frame.origin.y != 0 {
                                self.view.frame.origin.y = 0
                            }
                            showMessageWithoutAction(message: "Nurse added to the consultation", controllerToPresent: self)
                        }
                    })
                }
                
                //move the view down
                cell.moveView = { [weak self] in
                    guard let self = self else {return}
                    self.view.endEditing(true)
                    self.title = UIConstants.doctorPrescription.pageTitle
                    //move the view down
                    if self.view.frame.origin.y != 0 {
                        self.view.frame.origin.y = 0
                    }
                    if RealmManager.shared.findUserType() == "doctor" {
                        cell.selectNurseTextField.text = RealmManager.shared.showSelectedNurse(encounter_ID: self.encounter_ID)
                    }
                }
                
                //move the keyboard up
                cell.moveTheViewUp = { [weak self] in
                    guard let self = self else {return}
                    self.title = ""
                    //move the view up
                    if self.view.frame.origin.y == 0 {
                        self.view.frame.origin.y -= 150
                    }
                }
                
            }else {
                //nurse
                cell.selectNurseLabel.isHidden = true
                cell.selectNurseTextField.isHidden = true
            }
            
            //Nurse edit the note
            cell.didTapEditButton = { [weak self] _ in
                guard let self = self else {return}
                self.moveToDocNotes(indexB: false, notesReceived: (cell.descContent.text == UIConstants.doctorPrescription.notAvailableTxt ? "" : cell.descContent.text) ?? "")
            }
            
            cell.descContent.text = RealmManager.shared.getDoctorNotes(referenceID: encounter_ID, isDoctorNurseID: doctor_nurse_ID, typeOfUser: "Nurse")
            
            return cell
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 140
            
        case 4:
            return 150
            
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 140
            
        case 4:
            return 150
            
        default:
            return UITableView.automaticDimension
        }
    }
}
