//
//  ProductQuantityTableViewCell.swift
//  AppShowcase
//
//  Created by Gagandeep on 03/09/21.
//

import UIKit

class ProductQuantityTableViewCell: UITableViewCell {
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var productNameTF: UITextField!
    @IBOutlet weak var quantityTF: UITextField!
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
