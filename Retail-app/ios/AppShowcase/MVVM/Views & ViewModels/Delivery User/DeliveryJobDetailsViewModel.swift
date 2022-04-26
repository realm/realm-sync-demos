//
//  DeliveryJobDetailsViewModel.swift
//  AppShowcase
//
//  Created by Brian Christo on 01/03/22.
//

import Foundation
import CoreLocation

class DeliveryJobDetailsViewModel: NSObject{
    var job =  Jobs()
    //Set user type
    var deliveryUser = false
    var receivedBy: String?
    let locationManager = CLLocationManager()
    
    func syncStoreData() {
        UserDefaults.standard.setValue(job.sourceStore?._id.stringValue, forKey: Defaults.stores)
        RealmManager.shared.syncStoreRealm { completed in
            if completed == false {
                print("Failed to open realm - store")
            }
            print("successfully opened realm - store")
            return
        }
    }

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
        // date time
        cell.dateTF.text = job.datetime?.getDateStringFromDate()
        cell.timeTF.text = job.datetime?.getTimeStringFromDate()
        cell.dateTF.isUserInteractionEnabled = false
        cell.timeTF.isUserInteractionEnabled = false
        // job status
        cell.jobStatusLbl.text = job.status.capitalized
        //receivedby
        cell.receivedByTF.text = job.receivedBy ?? ""
        // Assignee for store user and status update for delivery user
        cell.assigneeBtn.isUserInteractionEnabled = false
        cell.assigneeStack.isHidden = true
        cell.updateStatusBtn.isHidden = (job.status ==  JobStatus.done.rawValue)
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

extension DeliveryJobDetailsViewModel: CLLocationManagerDelegate {
    func startUpdatingLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func updateLocationOnUserRealm(location: CLLocation) {
        RealmManager.shared.updatelocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { status in
            print("Location Updated in User Realm")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(String(describing: manager.location))")
        updateLocationOnUserRealm(location: manager.location ?? locations[0])
    }
                                            
}
