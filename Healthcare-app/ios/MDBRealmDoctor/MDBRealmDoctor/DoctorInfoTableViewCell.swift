//
//  DoctorInfoTableViewCell.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 25/04/22.
//

import UIKit

class DoctorInfoTableViewCell: UITableViewCell {
    
    //Mark:- Outlets
    
    @IBOutlet weak var imageLoadImageView : UIImageView! {
        didSet {
            self.imageLoadImageView.layer.cornerRadius = self.imageLoadImageView.frame.size.height / 2
            cardViewImageView(view: self.imageLoadImageView)
            self.imageLoadImageView.image = UIImage(systemName: "person")
        }
    }
    
    @IBOutlet weak var imageAddButton : UIButton! {
        didSet {
            self.imageAddButton.layer.cornerRadius = self.imageAddButton.frame.size.height / 2
        }
    }
    
    //variable declaration
    var didSelectImageCliked : ((_ selectedIndexP : Int?) -> ()) = {selectedIndexP in }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
        //MARK: - Action outlet
    @IBAction func didClickAddPhoto(_ sender : UIButton) {
        didSelectImageCliked(sender.tag)
    }

}
