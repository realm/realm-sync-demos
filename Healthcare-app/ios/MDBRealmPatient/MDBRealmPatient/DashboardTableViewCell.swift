//
//  DashboardTableViewCell.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/21/22.
//

import UIKit
import CloudKit
import SDWebImage
import RealmSwift

class DashboardTableViewCell: UITableViewCell {
    @IBOutlet weak var clickBtn             : UIButton!
    @IBOutlet weak var hospitalAddress      : UILabel!
    @IBOutlet weak var hospitalDescription  : UILabel!
    @IBOutlet weak var hospitalName         : UILabel!
    @IBOutlet weak var hospitalImage        : UIImageView! {
        didSet {
            self.hospitalImage.contentMode = .scaleAspectFill
            self.hospitalImage.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var locationImage        : UIImageView! {
        didSet {
            self.locationImage.contentMode = .scaleAspectFit
            self.locationImage.isHidden = true
        }
    }
    @IBOutlet weak var personImage        : UIImageView! {
        didSet {
            self.personImage.contentMode = .scaleAspectFit
            self.personImage.isHidden = true
        }
    }
    var model:Organization?{
        didSet{
            self.hospitalName.text = self.model?.name?.capitalizingFirstLetter()
            self.hospitalAddress.text = "\(self.model?.address.first?.city ?? ""), \(self.model?.address.first?.state ?? ""), \(self.model?.address.first?.country ?? "")"
            self.hospitalDescription.text = self.model?.type?.text
            self.locationImage.image = UIImage(named: "location")
            self.locationImage.isHidden = false
            if let urlStr =  self.model?.photo.first?.url {
                self.logoprofileImage(subImageUrl: urlStr, hospitalImage: self.hospitalImage)
            } else {
                self.hospitalImage.image = UIImage(named: "placeholder")
            }
        }
    }
    func logoprofileImage(subImageUrl: String, hospitalImage: UIImageView) {
        hospitalImage.sd_setImage(with: URL(string: subImageUrl), placeholderImage: UIImage(named: "placeholder"), options: .handleCookies, progress: .none, completed: {_,_,_,_ in
            
        })
    }
    var practitionerModel:PractitionerRole?{
        didSet{
            self.hospitalName.text = self.practitionerModel?.practitioner?.name?.text
            self.hospitalAddress.text = self.practitionerModel?.specialty?.text
            self.hospitalDescription.text = self.practitionerModel?.practitioner?.name?.given
            if let urlStr =  self.practitionerModel?.practitioner?.photo.first?.data {
                self.hospitalImage.image = urlStr.convertBase64ToImage()
            } else {
                self.hospitalImage.image = UIImage(named: "placeholder")
            }
        }
    }
    var procedure:Procedure?{
        didSet{

            let organizationObject = RealmManager.shared.getOrganizationById(organizationId: procedure?.encounter?.serviceProvider?.identifier ?? RealmManager.shared.defaultObjectId)
            self.hospitalName.text = organizationObject?.name?.capitalizingFirstLetter()
            self.hospitalAddress.text = "\(organizationObject?.address.first?.city ?? ""), \(organizationObject?.address.first?.state ?? ""), \(organizationObject?.address.first?.country ?? "")"
            if let urlStr =  organizationObject?.photo.first?.url {
                self.logoprofileImage(subImageUrl: urlStr, hospitalImage: self.hospitalImage)
            } else {
                self.hospitalImage.image = UIImage(named: "placeholder")
            }
            let participantObject = procedure?.encounter?.appointment?.participant
            let practitioner = participantObject?.first{$0.actor?.reference == "Practitioner/Doctor"}
            let practotionerObject = RealmManager.shared.getPractitionerById(practitinerId: practitioner?.actor?.identifier ?? RealmManager.shared.defaultObjectId)
            
            self.hospitalDescription.text = practotionerObject?.name?.given
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    
}
