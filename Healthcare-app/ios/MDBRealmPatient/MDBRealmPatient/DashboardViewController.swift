//
//  DashboardViewController.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/21/22.
//

import UIKit
import RealmSwift

class DashboardViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewModel: HomePageViewModel!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.delegate = self
            self.searchBar.placeholder = "Search"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.addRightButtonToNav()
        self.title = "Hospitals"
        self.setUserRoleAndNameOnNavBar()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "DashboardTableViewCell", bundle: nil), forCellReuseIdentifier: "DashboardTableViewCell")
        self.loadProducts()
        self.observeRealmChanges()
    }
    @objc override func rightBtn(button:UIBarButtonItem)  {
        if let menuVC =
            Constants.dashboardStoryBoard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController {
            self.navigationController?.pushViewController(menuVC, animated: true)
        }
    }
    @objc @IBAction func actionDidMenuScreen(_ sender: UIButton) {
        
    }
    @objc @IBAction func actionDetailsPage(_ sender: UIButton) {
        if let doctorDetailsVC =
            Constants.dashboardStoryBoard.instantiateViewController(withIdentifier: "DoctorDetailsViewController") as? DoctorDetailsViewController {
            doctorDetailsVC.viewModel.organization =  self.viewModel.organizationList?[sender.tag]
            self.navigationController?.pushViewController(doctorDetailsVC, animated: true)
        }
    }
    @IBAction func actionDidSelectDetails(_ sender: UIButton) {
        if let doctorDetailsVC =
            Constants.dashboardStoryBoard.instantiateViewController(withIdentifier: "DoctorDetailsViewController") as? DoctorDetailsViewController {
            self.navigationController?.pushViewController(doctorDetailsVC, animated: true)
        }
    }
    // MARK: - Private methods
    private func loadProducts() {
        self.viewModel.getProducts()
        self.tableView.reloadData()
    }
    // MARK: - Private methods
    private func observeRealmChanges()  {
        // Observe collection notifications. Keep a strong
         // reference to the notification token or the
         // observation will stop.
        viewModel.notificationToken = viewModel.organizationOriginalList?.observe { [weak self] (change: RealmCollectionChange) in
            switch change {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self?.loadProducts()
            case .update(_, _, _, _):
                self?.loadProducts()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
            
        }
    }
}
extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.organizationList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell", for: indexPath) as? DashboardTableViewCell)!
        cell.clickBtn.tag = indexPath.row
        cell.clickBtn.addTarget(self, action: #selector(actionDetailsPage(_:)), for: .touchUpInside)
        let organization = self.viewModel.organizationList?[indexPath.row]
        cell.model = organization
        return cell
    }
}
extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}
// MARK: - SearchBar Delegates
extension DashboardViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        self.viewModel.searchList(text: searchText)
        self.tableView.reloadData()
    }
    @objc func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.loadProducts()
    }
}
