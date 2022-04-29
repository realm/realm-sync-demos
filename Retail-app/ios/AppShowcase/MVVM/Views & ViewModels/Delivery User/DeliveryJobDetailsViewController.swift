//
//  DeliveryJobDetailsViewController.swift
//  AppShowcase
//
//  Created by Brian Christo on 01/03/22.
//

import UIKit
import RealmSwift

class DeliveryJobDetailsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel =  DeliveryJobDetailsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Job #\(viewModel.job._id)"
        self.tableView.register(UINib(nibName: CellIdentifier.productTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.productTableViewCell)
        
        viewModel.syncStoreData()
        
        viewModel.job.observe { [weak self] _ in
            self?.refreshData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        refreshData()
    }
    
    func refreshData() {
        self.tableView.reloadData()
    }

    // MARK: - Actions
        
    @IBAction func statusChangeBtnAction(_ sender: UIButton) {
        let jobStatus = viewModel.job.status

        let alert = UIAlertController(title: "Update Job Status", message: "", preferredStyle: .actionSheet)
        alert.view.tintColor = .black
        
        // You can change the status of the job, until it is completed/done.
        if jobStatus !=  JobStatus.done.rawValue {
            alert.addAction(UIAlertAction(title: JobStatus.todo.rawValue.capitalizingFirstLetter(), style: .default , handler:{ (UIAlertAction)in
                self.updateJobStatus(status: JobStatus.todo.rawValue)
            }))
            alert.addAction(UIAlertAction(title: JobStatus.inprogress.rawValue.capitalizingFirstLetter(), style: .default , handler:{ (UIAlertAction)in
                self.updateJobStatus(status: JobStatus.inprogress.rawValue)
            }))
         }
        alert.addAction(UIAlertAction(title: JobStatus.done.rawValue.capitalizingFirstLetter(), style: .default , handler:{ (UIAlertAction)in
            if self.viewModel.receivedBy == nil || self.viewModel.receivedBy == "" {
                self.showErrorAlert("Please enter the name of customer who received this job")
            } else {
                self.updateJobStatus(status: JobStatus.done.rawValue)
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func updateJobStatus(status: String) {
        let currentJobStatus = viewModel.job.status
        RealmManager.shared.updateJobStatus(status: status, receivedBy: viewModel.receivedBy, forJob: viewModel.job) { completed in
            if completed == false {
                return
            }
            DispatchQueue.main.async {
                self.refreshData()
                self.showMessage(message: "Job status is updated")
                
                // Location updates
                 if status == JobStatus.inprogress.rawValue {
                     // when delivery user makes a job status to in-progress, start monitoring the user location and update it continuosly in user.location
                     // This location updates is only applicable for jobs which has customer address saved. (ie., delivery/installation jobs created for home-delivery orders)
                     if let orderId = self.viewModel.job.order {
                        let order = RealmManager.shared.getOrder(witId: orderId)
                        if order?.type?.address != nil {
                            self.viewModel.startUpdatingLocation()
                        }
                    }
                } else {
                    self.viewModel.stopUpdatingLocation()
                }
                
                if self.viewModel.job.type == "Delivery" && self.viewModel.job.destinationStore != nil {
                    // update stock count
                    if currentJobStatus == JobStatus.todo.rawValue && status == JobStatus.inprogress.rawValue {
                        let productQuantities = self.viewModel.job.products
                        for pQuantity in  productQuantities {
                            if let prodId = pQuantity.product?._id {
                                if let inventory = RealmManager.shared.getStoreInventory(withProductId: prodId) {
                                    let decreasedQuantity = inventory.quantity! - pQuantity.quantity
                                    RealmManager.shared.updateStockQuantity(forInventory: inventory, withStock: decreasedQuantity) { status in
                                        print("Job moved to in-progress and stock reduced from source store's inventory")
                                    }
                                }
                            }
                        }
                        return
                    } else if currentJobStatus == JobStatus.inprogress.rawValue && status == JobStatus.todo.rawValue {
                        let productQuantities = self.viewModel.job.products
                        for pQuantity in  productQuantities {
                            if let prodId = pQuantity.product?._id {
                                if let inventory = RealmManager.shared.getStoreInventory(withProductId: prodId) {
                                    let increasedQuantity = inventory.quantity! + pQuantity.quantity
                                    RealmManager.shared.updateStockQuantity(forInventory: inventory, withStock: increasedQuantity) { status in
                                        print("Job moved to in-progress and stock reversed/increased in source store's inventory")
                                    }
                                }
                            }
                        }
                        return
                    } else if currentJobStatus == JobStatus.inprogress.rawValue && status == JobStatus.done.rawValue {
                        self.showLoader()
                        UserDefaults.standard.setValue(self.viewModel.job.destinationStore?._id.stringValue, forKey: Defaults.stores)
                        RealmManager.shared.syncStoreRealm { completed in
                            if completed == false {
                                print("Failed to open realm - store")
                            }
                            // do navigation to Home page
                            print("successfully opened realm - store")
                            let productQuantities = self.viewModel.job.products
                            for pQuantity in  productQuantities {
                                if let prodId = pQuantity.product?._id {
                                    if let inventory = RealmManager.shared.getStoreInventory(withProductId: prodId) {
                                        // update
                                        let increasedQuantity = inventory.quantity! + pQuantity.quantity
                                        RealmManager.shared.updateStockQuantity(forInventory: inventory, withStock: increasedQuantity) { status in
                                            print("Job completed and quantity updateed in destination store's inventory")
                                            self.hideLoader()
                                        }
                                    } else {
                                        // insert
                                        let partition = UserDefaults.standard.value(forKey: Defaults.stores) as? String ?? ""
                                        let partitionValue = "store=\(partition)"
                                        
                                        let inventory = StoreInventory()
                                        inventory._partition = partitionValue
                                        inventory.storeId = self.viewModel.job.destinationStore?._id
                                        inventory.productId = prodId
                                        inventory.image = pQuantity.product?.image ?? ""
                                        inventory.productName = pQuantity.product?.name  ??  ""
                                        inventory.quantity = pQuantity.quantity
                                        
                                        RealmManager.shared.insertInventory(inventory: inventory, toStore: self.viewModel.job.destinationStore!._id) { status in
                                            print("Job completed and inventory inserted in destination store")
                                            self.hideLoader()
                                        }
                                    }
                                }
                            }
                            return
                        }
                    }
                }
            }
        }
    }
}
extension DeliveryJobDetailsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? viewModel.job.products.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.deliveryJobDetailTableViewCell, for: indexPath) as? JobDetailTableViewCell
            viewModel.configureJobCell(cell: cell ?? JobDetailTableViewCell())
            return cell!
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.productTableViewCell, for: indexPath) as? ProductTableViewCell
            cell?.productQuantityForOrder = viewModel.job.products[indexPath.row]
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 446 :  UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 446 : 60
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? ""  : "Products"
    }
}

extension DeliveryJobDetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            if oldString.isEmpty && string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            var newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
            newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
            if newString.count > Maximum.nameLength {
                return false
            }
            viewModel.receivedBy = newString
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
