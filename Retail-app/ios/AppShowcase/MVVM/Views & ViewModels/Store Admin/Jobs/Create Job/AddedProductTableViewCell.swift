//
//  AddedProductTableViewCell.swift
//  AppShowcase
//
//  Created by Gagandeep on 01/09/21.
//

import UIKit

class AddedProductTableViewCell: UITableViewCell {

    @IBOutlet weak var outerBGView: UIView!{
        didSet{
            self.outerBGView.setShadow()
        }
    }
    @IBOutlet weak var nameLbl: UILabel! {
        didSet{
            self.nameLbl.font = .appRegularFont(withSize: 12)
        }
    }
    @IBOutlet weak var quantityLbl: UILabel!{
        didSet{
            self.quantityLbl.font = .appBoldFont(withSize: 16)
        }
    }
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var removeBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
