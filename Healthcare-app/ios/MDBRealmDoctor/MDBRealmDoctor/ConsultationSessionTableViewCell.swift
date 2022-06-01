//
//  ConsultationSessionTableViewCell.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import UIKit

class ConsultationSessionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var patientName : UILabel!
    
    @IBOutlet weak var doctorName_hospital : UILabel!
    
    @IBOutlet weak var illness_Condition : UILabel!
    
    @IBOutlet weak var current_Medication : UILabel!
    
    @IBOutlet weak var concern : UILabel!
    
    @IBOutlet weak var outerView : UIView! {
        didSet {
            cardView(view: outerView)
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

}
