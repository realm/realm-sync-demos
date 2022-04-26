//
//  OrderDetailsViewController.swift
//  AppShowcase
//
//  Created by Brian Christo on 24/02/22.
//

import UIKit

class OrderDetailsViewController: BaseViewController {
    
    @IBOutlet weak var headerView: UITableViewHeaderFooterView!
    @IBOutlet weak var productsTableView: UITableView! {
        didSet{
            self.productsTableView.tableHeaderView = headerView
            self.productsTableView.rowHeight = UITableView.automaticDimension
            self.productsTableView.estimatedRowHeight = 60
        }
    }

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
    var viewModel = OrderDetailsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productsTableView.register(UINib(nibName: CellIdentifier.productTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.productTableViewCell)
        loadOrderInfo()
    }
    

    // MARK: -
    
    /// Loads the order data on  screen. (Could be used while we  come here to  edit  an order)
    func loadOrderInfo() {
        self.navigationItem.title = "Order #\(viewModel.order.orderId)"
        orderIdLbl.text = viewModel.order.orderId
        dateLbl.text = viewModel.order.createdDate.getDateStringFromDate()
        timeLbl.text = viewModel.order.createdDate.getTimeStringFromDate()
        custNameLbl.text = viewModel.order.customerName
        custEmailLbl.text = viewModel.order.customerEmail
        addressTitleLbl.text  = viewModel.order.type?.name
        addressLbl.text = viewModel.order.type?.address
        payMethodLbl.text  = viewModel.order.paymentType
        payStatusLbl.text  = viewModel.order.paymentStatus
        productsTableView.reloadData()
    }

    @IBAction func deleteAction(_ sender: UIButton) {
        self.showAlertViewWithBlock(message: "Are you sure you want to delete the order?", btnTitleOne: "Delete", btnTitleTwo: "Cancel", completionOk: {
            RealmManager.shared.deleteOrder(order: self.viewModel.order) { status in
                
            }
        })
    }
}

extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
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
