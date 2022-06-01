//
//  SidemenuTableViewCell.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 25/04/22.
//

import UIKit

class SidemenuTableViewCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var menuImageView : UIImageView!
    
    @IBOutlet weak var menuName      : UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
