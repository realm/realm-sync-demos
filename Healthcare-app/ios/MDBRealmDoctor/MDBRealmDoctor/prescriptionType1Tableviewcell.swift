//
//  prescriptionType1TableviewcellTableViewCell.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import UIKit

class prescriptionType1Tableviewcell: UITableViewCell {
    
    @IBOutlet weak var timeStamp : UILabel!
    
    @IBOutlet weak var PatientName : UILabel!
    
    @IBOutlet weak var doctorName_HospitalName : UILabel!
    
    @IBOutlet weak var condition_Illness : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
