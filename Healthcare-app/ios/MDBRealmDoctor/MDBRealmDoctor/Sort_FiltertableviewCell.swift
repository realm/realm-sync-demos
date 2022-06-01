//
//  Sort_FiltertableviewCell.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import UIKit

class Sort_FiltertableviewCell: UITableViewCell {
    
    @IBOutlet weak var checkUncheckButton : UIImageView!
    
    @IBOutlet weak var eventName : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
