//
//  OrderSummaryViewController.swift
//  AppShowcase
//
//  Created by Brian Christo on 22/02/22.
//

import UIKit

class OrderSummaryViewController: BaseViewController {

    @IBOutlet weak var productsTableView: UITableView! {
        didSet{
            self.productsTableView.tableHeaderView = UIView()
            self.productsTableView.tableFooterView = footerView
            self.productsTableView.rowHeight = UITableView.automaticDimension
            self.productsTableView.estimatedRowHeight = 60
        }
    }

    @IBOutlet weak var footerView: UITableViewHeaderFooterView!
    @IBOutlet weak var orderIdTitleLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    
    @IBOutlet weak var deliveryInfoTitleLbl: UILabel!
    @IBOutlet weak var customerInfoTitleLbl: UILabel!
    @IBOutlet weak var paymentInfoTitleLbl: UILabel!
    
    @IBOutlet weak var addressTitleLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var datetimeTitleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var custNameTitleLbl: UILabel!
    @IBOutlet weak var custNameLbl: UILabel!
    @IBOutlet weak var custEmailTitleLbl: UILabel!
    @IBOutlet weak var custEmailLbl: UILabel!
    @IBOutlet weak var payMethodTitleLbl: UILabel!
    @IBOutlet weak var payMethodLbl: UILabel!
    @IBOutlet weak var payStatusTitleLbl: UILabel!
    @IBOutlet weak var payStatusLbl: UILabel!

    var viewModel = OrderSummaryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Order Summary"
        productsTableView.register(UINib(nibName: CellIdentifier.productTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.productTableViewCell)
        loadOrderInfo()
    }
    

    // MARK: -
    
    /// Loads the order data on  screen. (Could be used while we  come here to  edit  an order)
    func loadOrderInfo() {
//        orderIdLbl.text = viewModel.order.orderId
        dateLbl.text = viewModel.order.createdDate.getDateStringFromDate()
        timeLbl.text = viewModel.order.createdDate.getTimeStringFromDate()
        custNameLbl.text = viewModel.order.customerName
        custEmailLbl.text = viewModel.order.customerEmail
        addressTitleLbl.text  = viewModel.order.type?.name
        addressLbl.text = viewModel.order.type?.address
        payMethodLbl.text  = viewModel.order.paymentType
        productsTableView.reloadData()
    }
    
    @IBAction func createOrderBtn(_ sender: UIButton) {
        RealmManager.shared.createOrder(order: viewModel.order) { completed in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

extension OrderSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.order.products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.productTableViewCell, for: indexPath) as? ProductTableViewCell
        cell?.productQuantityForOrder = viewModel.order.products[Int(indexPath.row)]
        return cell!
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  "Products"
    }
}
