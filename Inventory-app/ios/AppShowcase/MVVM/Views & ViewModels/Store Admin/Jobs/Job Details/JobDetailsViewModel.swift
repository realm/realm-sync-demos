//
//  JobDetailsViewModel.swift
//  AppShowcase
//
//  Created by Gagandeep on 03/09/21.
//

import Foundation
class JobDetailsViewModel:NSObject{
    var job =  Jobs()

    //Set user type
    var deliveryUser = false
    
    func configureJobCell(cell: JobDetailTableViewCell) {
        cell.pickupStoreNameTF.text = job.sourceStore?.name.capitalizingFirstLetter()
        cell.dropStoreNameTF.text = job.destinationStore?.name.capitalizingFirstLetter()
        cell.dateTF.text = job.pickupDatetime?.getDateStringFromDate()
        cell.timeTF.text = job.pickupDatetime?.getTimeStringFromDate()
        if let fName = job.assignedTo?.firstName, let lName = job.assignedTo?.lastName {
            cell.assigneeBtn.setTitle(fName.capitalizingFirstLetter() + " " + lName.capitalizingFirstLetter(), for: .normal)
        }
        if RealmManager.shared.getMyUserInfo()?.userRole == UserRole.deliveryUser.rawValue {
            cell.assigneeBtn.isUserInteractionEnabled = false
            cell.assigneeDropdown.isHidden = true
        } else {
            cell.assigneeBtn.isUserInteractionEnabled = true
            cell.assigneeDropdown.isHidden = false
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
