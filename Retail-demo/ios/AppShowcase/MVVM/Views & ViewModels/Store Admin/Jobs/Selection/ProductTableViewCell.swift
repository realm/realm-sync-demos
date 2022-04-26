//
//  ProductTableViewCell.swift
//  AppShowcase
//
//  Created by Brian Christo on 21/09/21.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var outerBGView: UIView! {
        didSet{
            self.outerBGView.backgroundColor = .appGrayBG()
            self.outerBGView.makeRoundCornerWithoutBorder(withRadius: 5)
        }
    }
    @IBOutlet weak var productNameLbl: UILabel!{
        didSet {
            self.productNameLbl.font = UIFont.appRegularFont(withSize: 12)
        }
    }
    @IBOutlet weak var quantityLbl: UILabel!{
        didSet {
            self.quantityLbl.font = UIFont.appSemiBoldFont(withSize: 14)
        }
    }
    @IBOutlet weak var productImage: UIImageView! {
        didSet {
            self.productImage.backgroundColor = .white
            self.productImage.makeRoundCornerWithoutBorder(withRadius: 5)
        }
    }

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
    
    var productQuantityForOrder: ProductQuantity? {
        didSet {
            self.productNameLbl.text = productQuantityForOrder?.product?.name.capitalizingFirstLetter()
            self.quantityLbl.text = "\(productQuantityForOrder?.quantity ?? 0)"
            if let urlStr =  self.productQuantityForOrder?.product?.image {
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
    
    // MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
