//
//  PrescriptionType3TableViewCell.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 09/05/22.
//

import UIKit

class PrescriptionType3TableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleImageView : UIImageView!
    
    @IBOutlet weak var titleTxt       : UILabel!
    
    @IBOutlet weak var descContent    : UILabel!
    
    @IBOutlet weak var editButton     : UIButton! {
        didSet {
            self.editButton.setImage(UIImage(named: UIConstants.doctorPrescription.editButtonImage), for: .normal)
        }
    }
    
    //closure declaration
    lazy var didTapEditButton : ((_ selectedIndexR : Int) -> ()) = {selectedIndexR in }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didClickeditButton(_ sender : UIButton) {
        
        didTapEditButton(sender.tag)
    }

}
