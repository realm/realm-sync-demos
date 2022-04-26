//
//  ProductsCollectionViewCell.swift
//  AppShowcase
//
//  Created by Gagandeep on 31/08/21.
//

import UIKit
class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var productQty: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView! {
        didSet {
            self.productImage.contentMode = .scaleAspectFit
        }
    }
    
    var model:StoreInventory?{
        didSet{
            self.productName.text = self.model?.productName.capitalizingFirstLetter()
            self.productQty.text = "Stock: \(self.model?.quantity ?? 0)"
            self.productQty.textColor = UIColor(hexString: self.model?.quantity ?? 0 < Minimum.inventoryCount  ? "#F67457" : "#22AA0C")

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
    
}
