//
//  CreateOrderViewModel.swift
//  AppShowcase
//
//  Created by Brian Christo on 21/02/22.
//

import Foundation
import RealmSwift

class CreateOrderViewModel: NSObject {
    var selectedInventory: StoreInventory?
    var order: Orders = Orders()
    var rowCount:Int?{
        return order.products.count
    }
    
    func configureCell(cell: AddedProductTableViewCell, atIndex index: Int) {
        let productQuantity = order.products[index]
        // name
        cell.nameLbl.text = productQuantity.product?.name.capitalizingFirstLetter() ?? "Product"
        // quantity
        cell.quantityLbl.text = "\(productQuantity.quantity)"
        // image
        if let urlStr =  productQuantity.product?.image {
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
    
    func addProductToOrder(withQuantity quantity: Int, success onTaskSuccess:@escaping OnTaskSuccess){
        if let inventory = selectedInventory {
            if let product = RealmManager.shared.getProduct(withId: inventory.productId!) {
                let partition = UserDefaults.standard.value(forKey: Defaults.partition) ?? "master"
                let productQuantity = ProductQuantity()
                productQuantity._partition = partition as! String
                productQuantity.quantity = quantity
                productQuantity.product = product
                // if product is already added, increase count. else add to array
                let productQty = order.products.filter{$0.product?._id == product._id}
                if productQty.isEmpty == true {
                    order.products.insert(productQuantity, at: 0)
                    onTaskSuccess(true)
                    return
                } else {
                    let total = quantity + productQty.first!.quantity
                    productQuantity.quantity = total
                    guard let index = order.products.index(of: productQty.first!) else { return }
                    order.products.replace(index: index, object: productQuantity)
                    onTaskSuccess(true)
                    return
                }
            }
        }
        onTaskSuccess(false)
    }
    
    func deleteProduct(atIndex index:Int){
        order.products.remove(at: index)
    }
    
    func validateCreateOrderForm(success onTaskSuccess: OnTaskSuccess, failure onFailure: @escaping OnFailure) {
        if order.customerName.isEmpty {
            onFailure(FieldValidation.customerNameEmpty)
            return
        }
        if order.customerEmail.isEmpty {
            onFailure(FieldValidation.customerEmailEmpty)
            return
        }
        if order.type?.name == nil || order.type?.name == "" {
            onFailure(FieldValidation.pickupTypeEmpty)
            return
        }
        if order.paymentType.isEmpty {
            onFailure(FieldValidation.payTypeEmpty)
            return
        }
        if order.products.isEmpty {
            onFailure(FieldValidation.productEmpty)
            return
        }
        onTaskSuccess(true)
    }
    
}
