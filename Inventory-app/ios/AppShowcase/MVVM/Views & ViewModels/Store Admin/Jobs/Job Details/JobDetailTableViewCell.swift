//
//  JobDetailTableViewCell.swift
//  AppShowcase
//
//  Created by Gagandeep on 03/09/21.
//

import UIKit

class JobDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pickupStoreMapBtn: UIButton!
    @IBOutlet weak var pickupStoreNameTF: UITextField!
    @IBOutlet weak var dropStoreMapBtn: UIButton!
    @IBOutlet weak var dropStoreNameTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var assigneeBtn: UIButton!
    @IBOutlet weak var assigneeDropdown: UIButton!
    @IBOutlet weak var assigneeStack: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
