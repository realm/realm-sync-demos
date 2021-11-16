//
//  ProductTableViewCell.swift
//  AppShowcase
//
//  Created by Brian Christo on 21/09/21.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!

    var model:StoreInventory? {
        didSet{
            self.productNameLbl.text = model?.productName.capitalizingFirstLetter()
            self.quantityLbl.text = "\(model?.quantity ?? 0)"
            if let urlStr =  self.model?.image {
                let urlstring = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlStr

                guard let url = URL(string: urlstring) else {
                    self.productImage.image = nil
                    return
                }
                self.productImage.af.setImage(withURL: url)
            } else {
                self.productImage.image = nil
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productImage.makeRoundCornerWithoutBorder(withRadius: 3.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
