//
//  Consultation+TableViewExtension.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import Foundation
import UIKit
import RealmSwift

extension ConsulatationSelectionViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == true {
            return self.filteredconsultationList.count > 0 ? self.filteredconsultationList.count : 0
        }
        return self.consultationList.count > 0 ? self.consultationList.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.storyBoardControllerID.consultantCellID) as? ConsultationSessionTableViewCell else { return UITableViewCell() }
        
        //instamce creation
        let listData  = searchActive == true ? self.filteredconsultationList[indexPath.row] : self.consultationList[indexPath.row]
        
        //patient name
        cell.patientName.text = "\(listData.subject?.name?.text ?? "")"
        
        //hospital name and doctor name
        if let dataReceived = RealmManager.shared.getOrganisationPractionerDetails(practReferenceID: listData.participant.first?.individual?.identifier?.stringValue ?? "", hospitalID: listData.serviceProvider?.identifier?.stringValue ?? "") {
            cell.doctorName_hospital.text = "\(dataReceived.first?.practitioner?.name?.text ?? ""),\(dataReceived.first?.organization?.name ?? "")"
        }
        
        //illness or condition
        cell.illness_Condition.text = "Illness/ Condition - \(RealmManager.shared.getConsultationIllness(referenceID: (listData.reasonReference?.identifier?.stringValue) ?? "", illness: true))"
        
        //current medication
        cell.current_Medication.text = "Current Medications - \(RealmManager.shared.getConsultationIllness(referenceID: (listData.reasonReference?.identifier?.stringValue) ?? "", illness: false))"
        
        //concern
        cell.concern.text = "Concern - \(RealmManager.shared.getConsultationIllness(referenceID: (listData.reasonReference?.identifier?.stringValue) ?? "", illness: false))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        view.endEditing(true)

        //instamce creation
        let listData    = searchActive == true ? self.filteredconsultationList[indexPath.row] : self.consultationList[indexPath.row]
        
        let patientName = "\(listData.subject?.name?.text ?? "")"
        
        var doctor_HospitalName : String?
        
        //hospital name and doctor name
        if let dataReceived = RealmManager.shared.getOrganisationPractionerDetails(practReferenceID: listData.participant.first?.individual?.identifier?.stringValue ?? "", hospitalID: listData.serviceProvider?.identifier?.stringValue ?? "") {
            doctor_HospitalName = "\(dataReceived.first?.practitioner?.name?.text ?? ""), \(dataReceived.first?.organization?.name ?? "")"
        }
        
        pushNavigationToDoctorPrescription(StroryBoardName: Storyboard.storyBoardName.doctorPrescriptionBoard, VcID: Storyboard.storyBoardControllerID.doctorPrescriptionControllerID, ViewControllerName: self, patientName: patientName, doctorName_Hospital: doctor_HospitalName ?? "", dateTime: "\(listData.appointment?.start ?? Date())", illness_condition: "\(RealmManager.shared.getConsultationIllness(referenceID: (listData.reasonReference?.identifier?.stringValue) ?? "", illness: true))", concernDes: "\(RealmManager.shared.getConsultationIllness(referenceID: (listData.reasonReference?.identifier?.stringValue) ?? "", illness: false))", doctorNurseIDR: listData.participant.first?.individual?.identifier?.stringValue ?? "", encounterIDR: listData._id.stringValue , organisationIDR: self.selectedHospital?.organization?._id.stringValue ?? "")
    }
}
