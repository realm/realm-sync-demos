//
//  CreateOrderViewController.swift
//  AppShowcase
//
//  Created by Brian Christo on 21/02/22.
//

import UIKit
import RealmSwift
import GooglePlaces

class CreateOrderViewController: BaseViewController {

    var viewModel = CreateOrderViewModel()
    @IBOutlet weak var headerView: UITableViewHeaderFooterView!
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            self.tableView.tableHeaderView = headerView
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 60
            self.tableView.register(UINib(nibName: CellIdentifier.addedProductTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.addedProductTableViewCell)
        }
    }
    @IBOutlet weak var orderIDTF: BorderedTextField!
    @IBOutlet weak var dateTF: BorderedTextField!
    @IBOutlet weak var timeTF: BorderedTextField!
    @IBOutlet weak var customerNameTF: BorderedTextField!
    @IBOutlet weak var customerEmailTF: BorderedTextField!
    @IBOutlet weak var deliveryAddressTF: BorderedTextField!
    @IBOutlet weak var addressStackView: UIStackView!
    @IBOutlet weak var pickupStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var storePickupBtn: UIButton!
    @IBOutlet weak var homeDeliveryBtn: UIButton!
    @IBOutlet weak var cashBtn: UIButton!
    @IBOutlet weak var creditcardBtn: UIButton!
    @IBOutlet weak var quantityTF: BorderedTextField!
    @IBOutlet weak var selectProductBtn: BorderedButton!
    @IBOutlet weak var addProductsBtn: BorderedButton!
    @IBOutlet weak var submitBtn: FilledButton!
    var datePicker: DatePicker!
    var timePicker: DatePicker!
    var isEditMode = false

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = isEditMode ? "Edit Order" : "Create New Order"
        self.submitBtn.setTitle(isEditMode ? "Update" : "Next", for: .normal)
        self.addProductsBtn.setRedBorderAndText()
        self.datePicker = DatePicker(presentationController: self, textfield: dateTF, isDate: true)
        self.datePicker.dateDelegate = self
        self.timePicker = DatePicker(presentationController: self, textfield: timeTF, isDate: false)
        self.timePicker.dateDelegate = self
        addressStackView.isHidden = true
        pickupStackViewHeight.constant = 69
        self.view.layoutIfNeeded()

        //  Set some default values to create job.
        if isEditMode ==  true {
            loadOrderInfo()
            disableUIForEditOrder()
        } else {
            // Set default values
            // partion - master, paystatus = paid, orderid = timestamp
            viewModel.order._partition = "master"
            viewModel.order.paymentStatus = Paymentstatus.paid.rawValue
            
            // set myself as created user
            if let user = RealmManager.shared.getMyUserInfo() {
                viewModel.order.createdBy = user
            }
            
            // set timestamp as a reeadale orderID
            var timestamp = "\(Date.timeIntervalSinceReferenceDate)"
            timestamp = timestamp.replacingOccurrences(of: ".", with: "")
            viewModel.order.orderId = timestamp
            self.orderIDTF.text = timestamp
            
            // default to current date time
            viewModel.order.createdDate = Date()
            dateTF.text = viewModel.order.createdDate.getDateStringFromDate()
            timeTF.text = viewModel.order.createdDate.getTimeStringFromDate()

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: -
    
    /// Loads the order data on  screen. (Could be used while we  come here to  edit  an order)
    func loadOrderInfo() {
        orderIDTF.text = viewModel.order.orderId
        dateTF.text = viewModel.order.createdDate.getDateStringFromDate()
        timeTF.text = viewModel.order.createdDate.getTimeStringFromDate()
        customerNameTF.text = viewModel.order.customerName
        customerEmailTF.text = viewModel.order.customerEmail
        if viewModel.order.type?.name == "Store Pickup" {
            selectStorePickup()
        } else {
            selectHomeDelivery()
            deliveryAddressTF.text = viewModel.order.type?.address
        }
        if viewModel.order.paymentType == "Cash" {
            selectCashPaymentMode()
        } else {
            selectCreditCardPaymentMode()
        }
        tableView.reloadData()
    }
    
    func disableUIForEditOrder() {
        orderIDTF.isUserInteractionEnabled = false
        dateTF.isUserInteractionEnabled = false
        timeTF.isUserInteractionEnabled = false
        customerNameTF.isUserInteractionEnabled = false
        customerEmailTF.isUserInteractionEnabled = false
        deliveryAddressTF.isUserInteractionEnabled = false
        storePickupBtn.isUserInteractionEnabled = false
        homeDeliveryBtn.isUserInteractionEnabled = false
        cashBtn.isUserInteractionEnabled = false
        creditcardBtn.isUserInteractionEnabled = false
    }
    
    func selectStorePickup(){
        storePickupBtn.isSelected = true;
        storePickupBtn.setImage(#imageLiteral(resourceName: "Checked"), for: .normal)
        homeDeliveryBtn.isSelected = false;
        homeDeliveryBtn.setImage(#imageLiteral(resourceName: "UnChecked"), for: .normal)
        addressStackView.isHidden = true
        pickupStackViewHeight.constant = 69
        headerView.frame.size.height = 660
        self.view.layoutIfNeeded()
        self.tableView.reloadData()
    }
    func selectHomeDelivery(){
        storePickupBtn.isSelected = false;
        storePickupBtn.setImage(#imageLiteral(resourceName: "UnChecked"), for: .normal)
        homeDeliveryBtn.isSelected = true;
        homeDeliveryBtn.setImage(#imageLiteral(resourceName: "Checked"), for: .normal)
        addressStackView.isHidden = false
        pickupStackViewHeight.constant = 138
        headerView.frame.size.height = 660 + 69
        self.view.layoutIfNeeded()
        self.tableView.reloadData()
    }
    
    func selectCashPaymentMode() {
        cashBtn.isSelected = true;
        cashBtn.setImage(#imageLiteral(resourceName: "Checked"), for: .normal)
        creditcardBtn.isSelected = false;
        creditcardBtn.setImage(#imageLiteral(resourceName: "UnChecked"), for: .normal)
    }
    
    func selectCreditCardPaymentMode() {
        cashBtn.isSelected = false;
        cashBtn.setImage(#imageLiteral(resourceName: "UnChecked"), for: .normal)
        creditcardBtn.isSelected = true;
        creditcardBtn.setImage(#imageLiteral(resourceName: "Checked"), for: .normal)
    }
    
    func openPlacesAutoComplete(){
        let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self

            // Specify the place data types to return.
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                      UInt(GMSPlaceField.placeID.rawValue) |
                                                      UInt(GMSPlaceField.coordinate.rawValue) |
                                                      UInt(GMSPlaceField.addressComponents.rawValue) |
                                                      UInt(GMSPlaceField.formattedAddress.rawValue))
            autocompleteController.placeFields = fields
            // Display the autocomplete view controller.
            present(autocompleteController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func pickupTypeRadioBtnTapped(_ sender: UIButton) {
        view.endEditing(true)
        if self.viewModel.order.type == nil {
            self.viewModel.order.type = Orders_type()
        }
        if sender.tag == 0 {
            self.viewModel.order.type?.name = "Store Pickup"
            selectStorePickup()
        }else {
            self.viewModel.order.type?.name = "Home Delivery"
            selectHomeDelivery()
        }
    }

    @IBAction func payTypeRadioBtnTapped(_ sender: UIButton) {
        view.endEditing(true)
        if sender.tag == 0 {
            self.viewModel.order.paymentType = "Cash"
            selectCashPaymentMode()
        }else {
            self.viewModel.order.paymentType = "Credit Card"
            selectCreditCardPaymentMode()
        }
    }

    @IBAction func selectProductAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.selectionViewController.rawValue) as? SelectionViewController
        vc?.delegate = self
        vc?.viewModel.selectionType = .inventories
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func addProductToOrdersAction(_ sender: UIButton) {
        let name = self.selectProductBtn.titleLabel?.text
        let quantity: Int = Int(self.quantityTF.text ?? "0") ?? 0
        if name?.isEmpty == true || name == "Product Name" {
            self.showMessage(message: "Select a Product")
        } else if quantity == 0 {
            self.showMessage(message: "Enter the quantity of product")
        } else {
            self.viewModel.addProductToOrder(withQuantity: quantity) { completed in
                self.tableView.reloadData()
                self.selectProductBtn.setTitle("Product Name", for: .normal)
                self.quantityTF.text = ""
                self.viewModel.selectedInventory = nil
            }
        }
    }
    
    @IBAction func removeProductFromOrderAction(_ sender: UIButton) {
        self.viewModel.deleteProduct(atIndex: sender.tag)
        tableView.reloadData()
    }
    
    @IBAction func createOrderBtn(_ sender: UIButton) {
        viewModel.validateCreateOrderForm { completed in
            if self.isEditMode == false {
                DispatchQueue.main.async {
                    let viewC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardID.orderSummaryViewController.rawValue) as! OrderSummaryViewController
                    viewC.viewModel.order = self.viewModel.order
                    self.navigationController?.pushViewController(viewC, animated: true)
                }
            } else {
                RealmManager.shared.updateOrder(order: viewModel.order) { status in
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } failure: { errorMsg in
            print(errorMsg)
            self.showErrorAlert(errorMsg)
        }
    }
}

extension CreateOrderViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.rowCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.addedProductTableViewCell, for: indexPath) as? AddedProductTableViewCell ?? AddedProductTableViewCell()
        cell.removeBtn.tag = indexPath.row
        viewModel.configureCell(cell: cell, atIndex: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.frame.width, height: 40))
        label.text = self.viewModel.rowCount ?? 0 > 0 ? "     Added Products" : ""
        label.font = .appSemiBoldFont(withSize: 14)
        label.textColor = UIColor(hexString: "#333333")
        return label
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension CreateOrderViewController: SelectionDelegate{
    func didSelectJobType(type: String) {
        
    }
    
    func didSelectStore(store: Stores) {}
    
    func didSelectUser(user: Users) {}
    
    func didSelectInventory(inventory: StoreInventory) {
        viewModel.selectedInventory = inventory
        self.selectProductBtn.setTitle(inventory.productName.capitalizingFirstLetter(), for: .normal)
    }
}

extension CreateOrderViewController: DatePickerDelegate {
    func didSelectDate(date: Date) {
        viewModel.order.createdDate = date
        dateTF.text = date.getDateStringFromDate()
        timeTF.text = date.getTimeStringFromDate()
    }
}

extension CreateOrderViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            if oldString.isEmpty && string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            var newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
            newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
            switch textField {
            case customerNameTF:
                if newString.count > Maximum.nameLength {
                    return false
                }
                viewModel.order.customerName = newString
            case customerEmailTF:
                if newString.count > Maximum.emailLength {
                    return false
                }
                viewModel.order.customerEmail = newString
            case deliveryAddressTF:
                if newString.count > Maximum.emailLength {
                    return false
                }
                viewModel.order.type?.address = newString
            default: break
                
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == customerNameTF {
            self.customerEmailTF.becomeFirstResponder()
        } else if textField == customerEmailTF {
            self.customerEmailTF.resignFirstResponder()
            self.view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == deliveryAddressTF {
            openPlacesAutoComplete()
        }
    }
}

extension CreateOrderViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        viewModel.order.type?.address = place.formattedAddress
        viewModel.order.location?.latitude = place.coordinate.latitude
        viewModel.order.location?.longitude = place.coordinate.longitude
        self.deliveryAddressTF.text = place.formattedAddress
        dismiss(animated: true, completion: nil)
    }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}
