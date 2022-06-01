//
//  BookingHistoryTableViewCell.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/25/22.
//

import UIKit
import RealmSwift

class BookingHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var clickBtn: UIButton!
    @IBOutlet weak var dateAndTimelbl: UILabel!
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var hospitalAddr: UILabel!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var locationIV: UIImageView!
    @IBOutlet weak var hospitalImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var model:Procedure?{
        didSet{
            
            self.dateAndTimelbl.text = model?.encounter?.appointment?.start?.getDateStringFromDate()
            let organizationObject = RealmManager.shared.getOrganizationById(organizationId: model?.encounter?.serviceProvider?.identifier ?? RealmManager.shared.defaultObjectId)
            self.hospitalName.text = organizationObject?.name?.capitalizingFirstLetter()
            self.hospitalAddr.text = "\(organizationObject?.address.first?.city ?? ""), \(organizationObject?.address.first?.state ?? ""), \(organizationObject?.address.first?.country ?? "")"
            if let urlStr =  organizationObject?.photo.first?.url {
                self.logoprofileImage(subImageUrl: urlStr, hospitalImage: self.hospitalImage)
            } else {
                self.hospitalImage.image = UIImage(named: "placeholder")
            }
            let participantObject = model?.encounter?.appointment?.participant
            let practitioner = participantObject?.first{$0.actor?.reference == "Practitioner/Doctor"}
            let practotionerObject = RealmManager.shared.getPractitionerById(practitinerId: practitioner?.actor?.identifier ?? RealmManager.shared.defaultObjectId)
            self.doctorName.text = practotionerObject?.name?.given
        }
    }
    func logoprofileImage(subImageUrl: String, hospitalImage: UIImageView) {
        hospitalImage.sd_setImage(with: URL(string: subImageUrl), placeholderImage: UIImage(named: "placeholder"), options: .handleCookies, progress: .none, completed: {_,_,_,_ in
            
        })
    }
    
}
