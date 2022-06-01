//
//  ListOfHospitalTableViewCell.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import UIKit
import RealmSwift

class ListOfHospitalTableViewCell: UITableViewCell {
    
    //Mark:- Outklets
    
    @IBOutlet weak var outerView : UIView! {
        didSet{
            self.outerView.layer.cornerRadius = 10
            cardView(view: outerView)
        }
    }
    
    @IBOutlet weak var hospitalImageView : UIImageView! {
        didSet {
            self.hospitalImageView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var hospitalName : UILabel!
    
    @IBOutlet weak var locationName : UILabel!
    
    @IBOutlet weak var addressDetails : UILabel!
    
    @IBOutlet weak var sampleButtonTap  : UIButton!
    
    //Variable declaration
    var buttonActionClosure : ((_ senderTag : Int) -> ()) = {_ in}
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Action outlet
    @IBAction func didCilckNextpageButton(_ sender : UIButton) {
        buttonActionClosure(sender.tag)
    }
    
    //Function for config the cells
    func setUpCellDetails(listDetails : PractitionerRole?) {
        
        self.hospitalName.text = listDetails?.organization?.name
        
        self.addressDetails.text = listDetails?.organization?.type?.text
        
        self.locationName.text = "\(listDetails?.organization?.address.first?.city ?? ""), \(listDetails?.organization?.address.first?.state ?? ""), \(listDetails?.organization?.address.first?.country ?? "")"

        ImageDownloader.shared.downloadImage(with: listDetails?.organization?.photo.first?.url ?? "", completionHandler: {[weak self] (image, cache) in
            guard let self = self else {return}
            self.hospitalImageView.image = image
        }, placeholderImage: UIImage(named: UIConstants.HomePage.placeHolderImage))
    }

}
