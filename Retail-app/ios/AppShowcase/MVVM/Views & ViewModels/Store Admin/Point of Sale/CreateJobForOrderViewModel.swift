//
//  CreateJobForOrderViewModel.swift
//  AppShowcase
//
//  Created by Brian Christo on 28/02/22.
//

import Foundation
import RealmSwift

class CreateJobForOrderViewModel: NSObject{
    var job: Jobs = Jobs()
    var rowCount:Int?{
        return job.products.count
    }
    var orderToAddAsJob: Orders?
    var isFromOrder = false

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
     
    func validateCreateJobForm(success onTaskSuccess: OnTaskSuccess, failure onFailure: @escaping OnFailure) {
        if job.type == nil {
            onFailure(FieldValidation.jobTypeEmpty)
            return
        }
        if job.sourceStore == nil {
            onFailure(FieldValidation.sourceStoreEmpty)
            return
        }
        if orderToAddAsJob?.type?.address == nil {
            onFailure(FieldValidation.droppOffAddressEmpty)
            return
        }
        if job.datetime == nil {
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
    
    // MARK: - Add Order to Job
    func addToJob(orderToAdd order: Orders) {
        self.orderToAddAsJob = order
        self.job.setJobInfo(fromOrder: order)
    }
}
