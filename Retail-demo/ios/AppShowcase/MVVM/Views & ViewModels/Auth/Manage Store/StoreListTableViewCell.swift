//
//  StoreListTableViewCell.swift
//  AppShowcase
//
//  Created by Karthick TM on 28/01/22.
//

import UIKit

class StoreListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var baseView : UIView! 
    
    @IBOutlet weak var storeImageView : UIImageView! {
        didSet {
            self.storeImageView.image = UIImage(named: "Store")
        }
    }
    
    @IBOutlet weak var storeName : UILabel!
        
    @IBOutlet weak var radioSelectButton : UIButton! {
            didSet {
                self.radioSelectButton.setTitle("", for: .normal)
                self.radioSelectButton.setImage(UIImage(named: "radio"), for: .normal)
                self.radioSelectButton.setImage(UIImage(named: "radio_select"), for: .highlighted)
            }
        }
    
    //MARK: - 

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
