//
//  JobDetailsViewModel.swift
//  AppShowcase
//
//  Created by Gagandeep on 03/09/21.
//

import Foundation
class JobDetailsViewModel:NSObject{
    var job =  Jobs()
    var deliveryUser = false
    
    func configureJobCell(cell: JobDetailTableViewCell) {
        // pickup and drop stores
        cell.pickupStoreNameTF.text = job.sourceStore?.name.capitalizingFirstLetter()
        cell.dropStoreNameTF.text = job.destinationStore?.name.capitalizingFirstLetter()
        if let destination = job.destinationStore {
            cell.dropStoreNameTF.text = destination.name.capitalizingFirstLetter()
        } else {
            cell.dropStoreNameTF.text = ""
            if let orderId =  job.order {
                let order = RealmManager.shared.getOrder(witId: orderId )
                if order != nil {
                    cell.dropStoreNameTF.text = order?.type?.address
                }
            }
        }
        // date and time
        cell.dateTF.text = job.datetime?.getDateStringFromDate()
        cell.timeTF.text = job.datetime?.getTimeStringFromDate()
        cell.dateTF.isUserInteractionEnabled = false
        cell.timeTF.isUserInteractionEnabled = false
        // job status
        cell.jobStatusLbl.text = job.status.capitalized
        cell.assigneeBtn.isUserInteractionEnabled = true
        if let fName = job.assignedTo?.firstName, let lName = job.assignedTo?.lastName {
            cell.assigneeBtn.setTitle(fName.capitalizingFirstLetter() + " " + lName.capitalizingFirstLetter(), for: .normal)
        }
    }
    
    func configureProductCell(cell: ProductQuantityTableViewCell, atIndex index: Int) {
        let productQuantity = job.products[index]
        // name
        cell.productNameTF.text = productQuantity.product?.name.capitalizingFirstLetter()
        // quantity
        cell.quantityTF.text = "\(productQuantity.quantity)"
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
}
