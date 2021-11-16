//
//  SelectionViewController.swift
//  AppShowcase
//
//  Created by Brian Christo on 08/09/21.
//

import UIKit

protocol SelectionDelegate  {
    func didSelectInventory(inventory: StoreInventory)
    func didSelectStore(store: Stores)
    func didSelectUser(user: Users)
}

class SelectionViewController: BaseViewController {
    var viewModel = SelectionViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var delegate: SelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = viewModel.selectionType == .inventories ? 80 : 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.refreshList(withSearchKey: "")
    }
    
    // MARK: - Private methods
    
    private func refreshList(withSearchKey searchKey: String) {
        switch viewModel.selectionType {
        case .stores:
            self.navigationItem.title = "Select Store"
            self.viewModel.searchStores(forKey: searchKey)
        case .users:
            self.navigationItem.title = "Select User"
            self.viewModel.searchUsers(forKey: searchKey)
        default:
            self.navigationItem.title = "Select Product"
            self.viewModel.searchInventories(forKey: searchKey)
        }
        self.tableView.reloadData()
    }
}

extension SelectionViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        self.refreshList(withSearchKey: searchText)
    }
}

extension SelectionViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.rowCount ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.selectionType == .inventories {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.productTableViewCell, for: indexPath) as? ProductTableViewCell ?? ProductTableViewCell()
            cell.model = self.viewModel.inventories?[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.searchTableViewCell, for: indexPath) as? SearchTableViewCell ?? SearchTableViewCell()
            cell.model = self.viewModel.cellRowIndexPath(index: indexPath.row)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.selectionType {
        case .stores:
            guard let store = self.viewModel.stores?[indexPath.row] else { return }
            self.delegate?.didSelectStore(store: store)
        case .users:
            guard let user = self.viewModel.users?[indexPath.row] else { return }
            self.delegate?.didSelectUser(user: user)
        default:
            guard let inventory = self.viewModel.inventories?[indexPath.row] else { return }
            self.delegate?.didSelectInventory(inventory: inventory)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
