//
//  HospitalAssociatedTableViewCell.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 25/04/22.
//

import UIKit

class HospitalAssociatedTableViewCell: UITableViewCell {
    
    //Outlet
    
    @IBOutlet weak var initialImageView : UIImageView! {
        didSet {
            self.initialImageView.image = UIImage(named: "hospital 1")
        }
    }
    
    @IBOutlet weak var hospitalName : UILabel!
    
    @IBOutlet weak var deleteButton : UIButton! {
        didSet {
            self.deleteButton.setImage(UIImage(named: "trash-2"), for: .normal)
            self.deleteButton.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet weak var outerView : UIView! {
        didSet {
            cardView(view: self.outerView)
        }
    }
    
    //Variable declaration
    var deleteHospitalFromList : ((_ tagSelected : Int) -> ()) = {tagSelected in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Action outlet
    
    @IBAction func didClickDeleteButton(_ sender : UIButton) {
        deleteHospitalFromList(sender.tag)
    }



}
