//
//  AddedProductTableViewCell.swift
//  AppShowcase
//
//  Created by Gagandeep on 01/09/21.
//

import UIKit

class AddedProductTableViewCell: UITableViewCell {

    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
