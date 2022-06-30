//
//  BookingDetailsViewController.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/26/22.
//

import UIKit
import RealmSwift

class BookingDetailsViewController: BaseViewController {
    var procedure_id: ObjectId?
    @IBOutlet var viewModel         : BookingDetailsHistoryModel!
    @IBOutlet weak var dateAndTimelbl   : UILabel!
    @IBOutlet weak var hospitalName     : UILabel!
    @IBOutlet weak var hospitalAddr     : UILabel!
    @IBOutlet weak var hospitalDescription : UILabel!
    
    @IBOutlet weak var doctorName       : UILabel!
    @IBOutlet weak var doctorPosition   : UILabel!
    @IBOutlet weak var doctorAbout      : UILabel!
    @IBOutlet weak var hospitalImage    : UIImageView!
    
    @IBOutlet weak var concern          : UILabel!
    @IBOutlet weak var medicationInformation: UILabel!
    @IBOutlet weak var doctorNotes: UILabel! {
        didSet {
            self.doctorNotes.text = "Not Available"
        }
    }
    @IBOutlet weak var nurseNotes: UILabel! {
        didSet {
            self.doctorNotes.text = "Not Available"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButtonToNav()
        self.title = "Consultations"
        self.setUserRoleAndNameOnNavBar()
        if(self.procedure_id != nil){
            let result = RealmManager.shared.getProcedureById(procedureId: self.procedure_id!);
            viewModel.notificationToken = result?.observe({ [weak self]_ in
                self?.viewModel.setProcedureObject(procedure: self?.viewModel.procedureDetailsObject?._id ?? ObjectId("00000000000000000000000000"))
                self?.setHeaderHospitalInfo()
            })
            self.viewModel.procedureDetailsObject = result?.first
        }
    }
    func setHeaderHospitalInfo() {
        
        
        
        // Hospital information
        let organizationObject = RealmManager.shared.getOrganizationById(organizationId: viewModel?.procedureDetailsObject?.encounter?.serviceProvider?.identifier ?? RealmManager.shared.defaultObjectId)
        self.hospitalName.text = organizationObject?.name?.capitalizingFirstLetter()
        self.hospitalAddr.text = "\(organizationObject?.address.first?.city ?? ""), \(organizationObject?.address.first?.state ?? ""), \(organizationObject?.address.first?.country ?? "")"
        self.hospitalDescription.text = organizationObject?.type?.text
        
        self.dateAndTimelbl.text = viewModel?.procedureDetailsObject?.encounter?.appointment?.start?.getDateStringFromDate()

        let participantObject =  viewModel?.procedureDetailsObject?.encounter?.appointment?.participant
        let practitioner = participantObject?.first{$0.actor?.reference == "Practitioner/Doctor"}
        
        let practotionerObject = RealmManager.shared.getPractitionerById(practitinerId: practitioner?.actor?.identifier ?? RealmManager.shared.defaultObjectId)
        self.doctorName.text = practotionerObject?.name?.given
        self.doctorAbout.text = practotionerObject?.about
        self.doctorPosition.text = practotionerObject?.name?.text
        if let urlStr =  practotionerObject?.photo.first?.data {
            self.hospitalImage.image = urlStr.convertBase64ToImage()
        } else {
            self.hospitalImage.image = UIImage(named: "placeholder")
        }
    
        self.concern.text = self.viewModel.procedureDetailsObject?.encounter?.appointment?.patientInstruction
        
        let getMedicationInformation = self.viewModel.procedureDetailsObject?.usedReference.first?.code?.coding.compactMap{ $0.display}.joined(separator: "\n")
        
        self.medicationInformation.text = getMedicationInformation != nil && getMedicationInformation != "" ? getMedicationInformation : "Not Available"
        
        let doctorNotes = self.viewModel.procedureDetailsObject?.note.first{$0.author?.reference?.uppercased() == "Practitioner/Doctor".uppercased()}
        
        let nurseNotes = self.viewModel.procedureDetailsObject?.note.first{$0.author?.reference?.uppercased() == "Practitioner/Nurse".uppercased()}
        
        self.doctorNotes.text = doctorNotes?.text != nil && doctorNotes?.text != "" ? doctorNotes?.text : "Not Available"
        self.nurseNotes.text = nurseNotes?.text != nil && nurseNotes?.text != "" ? nurseNotes?.text : "Not Available"

    }
    // MARK: - Private methods
//
//    private func observeRealmChanges()  {
//        // Observe collection notifications. Keep a strong
//         // reference to the notification token or the
//         // observation will stop.
//
//        = viewModel.procedureDetailsObject?.observe { [weak self] change in
//
//        }
//    }
//
    
}
