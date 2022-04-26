//
//  ProductDetailsTableViewCell.swift
//  AppShowcase
//
//  Created by Brian Christo on 30/09/21.
//

import UIKit

class ProductDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var skuLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productImage.makeRoundCornerWithoutBorder(withRadius: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
