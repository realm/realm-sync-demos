//
//  SearchViewController.swift
//  AppShowcase
//
//  Created by Gagandeep on 01/09/21.
//

import UIKit

class SearchViewController: BaseViewController {
    @IBOutlet var viewModel: SearchViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshProducts(withKey: "")
    }
    
    // MARK: - Private methods
    private func refreshProducts(withKey searchText: String) {
        self.viewModel.searchProducts(forKey: searchText)
        self.tableView.reloadData()
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        self.refreshProducts(withKey: searchText)
    }
}
extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.searchTableViewCell, for: indexPath) as? SearchTableViewCell ?? SearchTableViewCell()
        cell.model = self.viewModel.cellRowIndexPath(index: indexPath.row).productName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = self.viewModel.cellRowIndexPath(index: indexPath.row)
        let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.productDetailPage.rawValue) as? ProductDetailController
        vc?.viewModel.inventory = result
        vc?.viewModel.product = RealmManager.shared.getProduct(withId: (result.productId)!)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
