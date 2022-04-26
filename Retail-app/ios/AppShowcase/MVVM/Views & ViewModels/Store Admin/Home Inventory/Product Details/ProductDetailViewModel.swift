//
//  ProductDetailViewModel.swift
//  AppShowcase
//
//  Created by Brian Christo on 30/09/21.
//

import Foundation
import RealmSwift

class ProductDetailViewModel: NSObject {
    var inventory:  StoreInventory?
    var product: Products?
    var productNotfnToken: NotificationToken?
    var inventoryNotfnToken: NotificationToken?

    func configureProductCell(cell: ProductDetailsTableViewCell, atIndex index: Int) {
        cell.productNameLbl.text = product?.name.capitalizingFirstLetter()
        cell.priceLbl.text = "$\(product?.price ?? 0.00)"
        cell.quantityLbl.text = "Quantity: \(inventory?.quantity ?? 0) remaining"
        cell.skuLbl.text = "SKU: \(product?.sku ?? 0)"
        
        if let urlStr =  self.product?.image {
            let urlstring = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlStr

            guard let url = URL(string: urlstring) else {
                cell.productImage.image = nil
                return
            }
            cell.productImage.af.setImage(withURL: url)
        } else {
            cell.productImage.image = nil
        }

    }

}
