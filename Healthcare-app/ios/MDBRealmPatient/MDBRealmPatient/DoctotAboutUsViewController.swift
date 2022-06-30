//
//  DoctotAboutUsViewController.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/25/22.
//

import UIKit

class DoctotAboutUsViewController: BaseViewController {
    @IBOutlet weak var bookingButton : UIButton! {
        didSet {
            self.bookingButton.setTitle(ConstantsID.BookingControllerID.bookingButtonName, for: .normal)
        }
    }
    @IBOutlet weak var doctorImage        : UIImageView! {
        didSet {
            self.doctorImage.contentMode = .scaleAspectFill
            self.doctorImage.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var doctorName               : UILabel!
    @IBOutlet weak var doctorDescription        : UILabel!
    @IBOutlet weak var doctorAbout              : UILabel!
    var practitionerRole: PractitionerRole?
    @IBOutlet var viewModel: DoctotAboutUsModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButtonToNav()
        self.title = "Doctor Information"
        self.setUserRoleAndNameOnNavBar()
        self.viewModel.getPratitioner()
        self.practionerData()
        self.observeRealmChanges() 
    }
    // MARK: - IBAction
    @IBAction func actionDidCreate(_ sender: UIButton) {
        if let bookingVC =
            Constants.dashboardStoryBoard.instantiateViewController(withIdentifier: "BookingSlotViewController") as? BookingSlotViewController {
            let practitionerRole = self.practitionerRole
            bookingVC.viewModel.practitionerRole = practitionerRole
            self.navigationController?.pushViewController(bookingVC, animated: true)
        }
    }
    // MARK: - Private methods
    private func observeRealmChanges()  {
        // Observe collection notifications. Keep a strong
         // reference to the notification token or the
         // observation will stop.
        viewModel.notificationToken = viewModel.practitionerObject?.observe { [weak self] change in
            self?.practionerData()
        }
    }
    func practionerData() {
        if let urlStr =  self.practitionerRole?.practitioner?.photo.first?.data {
            self.doctorImage.image = urlStr.convertBase64ToImage()
        } else {
            self.doctorImage.contentMode = .scaleAspectFit
            self.doctorImage.image = UIImage(named: "placeholder")
        }
        self.doctorName.text = self.practitionerRole?.practitioner?.name?.text
        self.doctorDescription.text = self.practitionerRole?.practitioner?.name?.given
        self.doctorAbout.text = self.practitionerRole?.practitioner?.about
    }
}
