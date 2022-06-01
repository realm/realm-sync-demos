//
//  HospitalListTableViewCell.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 25/04/22.
//

import UIKit

class HospitalListTableViewCell: UITableViewCell {
    
   // @IBOutlet weak var hospitalName
    
    @IBOutlet weak var hospital_specialistLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
