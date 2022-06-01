//
//  Controller+PresenterStyle.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import Foundation
import UIKit

/// Function for pusing the controller to next with navigation controller
func pushNavControllerStyle(storyBoardName : String, vcId : String, viewControllerName : UIViewController) {
    let mainStoryboard: UIStoryboard = UIStoryboard(name: storyBoardName, bundle: nil)
    let loginPageView = mainStoryboard.instantiateViewController(withIdentifier: vcId)
    viewControllerName.navigationController?.pushViewController(loginPageView, animated: true)
}

///function to present a view controller
func presentAController(StroryBoardName : String, storyBoardID: String, ViewControllerName : UIViewController) {
    let mainStoryboard: UIStoryboard = UIStoryboard(name: StroryBoardName, bundle: nil)
    
    let vc = mainStoryboard.instantiateViewController(withIdentifier: storyBoardID)
    
    ViewControllerName.present(vc, animated: true, completion: nil)
}


/// Function for pusing the controller to next with navigation controller
func pushNavControllerWithvalue(StroryBoardName : String, VcID : String, ViewControllerName : UIViewController, valueToPass : Int, hospitalSelectionList : [Organization]?) {
    let mainStoryboard: UIStoryboard = UIStoryboard(name: StroryBoardName, bundle: nil)
    guard let vc = mainStoryboard.instantiateViewController(withIdentifier: VcID) as? SpecialityAddition2ViewController else { return }
    vc.typeOfPage = valueToPass
    vc.hospitalSelectionArray = hospitalSelectionList ?? [Organization]()
    ViewControllerName.navigationController?.pushViewController(vc, animated: true)
}

///Function to push into consultation controller with ID
func pushNavControllerToConsultation(StroryBoardName : String, VcID : String, ViewControllerName : UIViewController, valueToPass : PractitionerRole) {
    let mainStoryboard: UIStoryboard = UIStoryboard(name: StroryBoardName, bundle: nil)
    guard let vc = mainStoryboard.instantiateViewController(withIdentifier: VcID) as? ConsulatationSelectionViewController else { return }
    vc.selectedHospital = valueToPass
    ViewControllerName.navigationController?.pushViewController(vc, animated: true)
}

///Function to push to doctor description page
func pushNavigationToDoctorPrescription(StroryBoardName : String, VcID : String, ViewControllerName : UIViewController, patientName : String, doctorName_Hospital : String, dateTime : String, illness_condition : String, concernDes : String, doctorNurseIDR : String, encounterIDR : String, organisationIDR : String) {
    let mainStoryboard: UIStoryboard = UIStoryboard(name: StroryBoardName, bundle: nil)
    guard let vc = mainStoryboard.instantiateViewController(withIdentifier: VcID) as? DoctorPrescriptionViewController else { return }
    vc.patientName         = patientName
    vc.doctorName_Hospital = doctorName_Hospital
    vc.date_time           = dateTime
    vc.illness_condition   = illness_condition
    
    //index 2
    vc.concernDes          = concernDes
    vc.doctor_nurse_ID     = doctorNurseIDR
    vc.encounter_ID        = encounterIDR
    vc.organisation_ID     = organisationIDR
    ViewControllerName.navigationController?.pushViewController(vc, animated: true)
}
