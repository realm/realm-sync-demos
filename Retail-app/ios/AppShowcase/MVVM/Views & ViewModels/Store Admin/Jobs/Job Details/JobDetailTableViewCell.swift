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
    @IBOutlet weak var assigneeStack: UIStackView!

    // for delivery user
    @IBOutlet weak var receivedByStack: UIStackView!
    @IBOutlet weak var receivedByTF: UITextField!
    @IBOutlet weak var jobStatusStack: UIStackView!
    @IBOutlet weak var jobStatusLbl: UILabel!
    @IBOutlet weak var updateStatusBtn: BorderedButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if updateStatusBtn != nil {
            updateStatusBtn.setRedBorderAndText()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
