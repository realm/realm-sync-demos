//
//  PoSOrdersViewController.swift
//  AppShowcase
//
//  Created by Brian Christo on 17/02/22.
//

import UIKit
import RealmSwift

class PoSOrdersViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalCountLbl: UILabel!
    @IBOutlet weak var createOrderBtn: FilledButton!
    @IBOutlet weak var noDataAlertView: UIView! {
        didSet {
            self.noDataAlertView.isHidden = false
        }
    }
    var viewModel = PoSOrdersViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLogoOnNavBarLeftItem()
        self.setStoreInfoOnNavBarRight()
        self.totalCountLbl.makeRoundCornerWithoutBorder(withRadius: 5)
        tableView.estimatedRowHeight = 361
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UINib(nibName: CellIdentifier.ordersTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.ordersTableViewCell)
        if let store = RealmManager.shared.getMyStore() {
            self.navigationItem.title = store.name.capitalizingFirstLetter()
        }
        loadOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Private methods
    
    private func loadOrders() {
        viewModel.getOrders()
        refreshUI()
        observeRealmChanges()
    }
    
    private func refreshUI() {
        self.tableView.reloadData()
        self.totalCountLbl.text = "   Total Items: \(viewModel.currentOrdersCount)  "
        self.noDataAlertView.isHidden = (viewModel.currentOrdersCount > 0)
    }
    
    private func observeRealmChanges()  {
        // Observe collection notifications. Keep a strong
         // reference to the notification token or the
         // observation will stop.
        guard let tblView = self.tableView else { return }
        viewModel.currentOrdersNotificationToken = viewModel.currentOrders?.observe { [weak self] (changes: RealmCollectionChange) in
            self?.reactToRealmChanges(onCollection: tblView, realmChanges: changes)
        }
    }
    
    func reactToRealmChanges(onCollection tableView: UITableView, realmChanges changes: RealmCollectionChange<Results<Orders>> )  {
        switch changes {
        case .initial, .update(_, _, _, _):
            self.refreshUI()
        case .error(let error):
            // An error occurred while opening the Realm file on the background worker thread
            fatalError("\(error)")
        }
    }

    // MARK: - Actions

    @IBAction func optionsAction(_ sender: UIButton) {
        guard let order = viewModel.currentOrders?[sender.tag] else {
            return
        }
        let attributedEdit = NSAttributedString(string: "Edit", attributes: [NSAttributedString.Key.font: UIFont.appSemiBoldFont(withSize: 16), NSAttributedString.Key.foregroundColor: UIColor.appDarkTextColor()])

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: { action in
            let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.createOrderViewController.rawValue) as? CreateOrderViewController
            vc?.viewModel.order = order
            vc?.isEditMode = true
            self.navigationController?.pushViewController(vc!, animated: true)
            actionSheet.dismiss(animated: true)
        })
        editAction.setValue(UIColor.appDarkTextColor(), forKey: "titleTextColor")
        actionSheet.addAction(editAction)

        // For Home delivery orders, there will be option to create jobs for delivery and installation.
        if order.type?.name == "Home Delivery" {
            let addToCreateJobAction = UIAlertAction(title: "Add to Create Job", style: .default, handler: { action in
                let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.createJobForOrderViewController.rawValue) as? CreateJobForOrderViewController
                vc?.viewModel.isFromOrder = true
                vc?.viewModel.addToJob(orderToAdd: order)
                self.navigationController?.pushViewController(vc!, animated: true)
                actionSheet.dismiss(animated: true)
            })
            addToCreateJobAction.setValue(UIColor.appDarkTextColor(), forKey: "titleTextColor")
            actionSheet.addAction(addToCreateJobAction)
        }
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.showAlertViewWithBlock(message: "Are you sure you want to delete the order?", btnTitleOne: "Delete", btnTitleTwo: "Cancel", completionOk: {
                RealmManager.shared.deleteOrder(order: order) { status in
                    
                }
            }, cancel: {
            }, "Delete Order")
            actionSheet.dismiss(animated: true)

        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            actionSheet.dismiss(animated: true)
        }))
        present(actionSheet, animated: true)
    }
    
    @IBAction func createOrderAction(_ sender: UIButton) {
        //Create Job
        let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.createOrderViewController.rawValue) as? CreateOrderViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
extension PoSOrdersViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentOrders?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ordersTableViewCell, for: indexPath) as? OrdersTableViewCell
        cell?.menuButton.tag = indexPath.row
        cell?.model = viewModel.currentOrders?[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Job details page
        let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.orderDetailsViewController.rawValue) as? OrderDetailsViewController
        vc?.viewModel.order = (viewModel.currentOrders?[indexPath.row])!
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

