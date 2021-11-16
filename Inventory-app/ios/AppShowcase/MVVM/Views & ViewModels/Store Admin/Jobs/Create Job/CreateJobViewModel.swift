//
//  CreateJobViewModel.swift
//  AppShowcase
//
//  Created by Gagandeep on 01/09/21.
//

import Foundation
import RealmSwift

class CreateJobViewModel: NSObject{
    var selectedInventory: StoreInventory?
    var job: Jobs = Jobs()
    var rowCount:Int?{
        return job.products.count
    }
    func configureCell(cell: AddedProductTableViewCell, atIndex index: Int) {
        let productQuantity = job.products[index]
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
    
    func addProductToJob(withQuantity quantity: Int, success onTaskSuccess:@escaping OnTaskSuccess){
        if let inventory = selectedInventory {
            if let product = RealmManager.shared.getProduct(withId: inventory.productId!) {
                let partition = UserDefaults.standard.value(forKey: Defaults.partition) ?? "master"
                let productQuantity = ProductQuantity(_partition: partition as! String, quantity: quantity, product: product)
                // if product is already added, increase count. else add to array
                let productQty = job.products.filter{$0.product?._id == product._id}
                if productQty.isEmpty == true {
                    job.products.insert(productQuantity, at: 0)
                    onTaskSuccess(true)
                    return
                } else {
                    let total = quantity + productQty.first!.quantity
                    productQuantity.quantity = total
                    guard let index = job.products.index(of: productQty.first!) else { return }
                    job.products.replace(index: index, object: productQuantity)
                    onTaskSuccess(true)
                    return
                }
            }
        }
        onTaskSuccess(false)
    }
    
    func deleteProduct(atIndex index:Int){
        job.products.remove(at: index)
    }
    
    func validateCreateJobForm(success onTaskSuccess: OnTaskSuccess, failure onFailure: @escaping OnFailure) {
        if job.sourceStore == nil {
            onFailure(FieldValidation.sourceStoreEmpty)
            return
        }
        if job.destinationStore == nil {
            onFailure(FieldValidation.destinationStoreEmpty)
            return
        }
        if job.pickupDatetime == nil {
            onFailure(FieldValidation.dateTimeEmpty)
            return
        }
        if job.assignedTo == nil {
            onFailure(FieldValidation.assigneeEmpty)
            return
        }
        if job.products.isEmpty {
            onFailure(FieldValidation.productEmpty)
            return
        }
        onTaskSuccess(true)
    }
    
}
