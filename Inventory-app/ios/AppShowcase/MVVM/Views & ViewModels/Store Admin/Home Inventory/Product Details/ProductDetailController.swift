//
//  ProductDetailController.swift
//  AppShowcase
//
//  Created by Gagandeep on 31/08/21.
//

import UIKit

class ProductDetailController: BaseViewController {
    
    @IBOutlet weak var productTableView: UITableView!
    var viewModel = ProductDetailViewModel()
    
    // MARK: - View Controller Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.product = RealmManager.shared.getProduct(withId: (viewModel.inventory?.productId)!)
        loadData()
        viewModel.product?.observe { [weak self] change in
            self?.loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Private methods

    private func loadData(){
        self.navigationItem.title = viewModel.product?.name.capitalizingFirstLetter()
        self.productTableView.reloadData()
    }
}

extension ProductDetailController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.productDetailTableViewCell, for: indexPath) as? ProductDetailsTableViewCell
            viewModel.configureProductCell(cell: cell ?? ProductDetailsTableViewCell(), atIndex: indexPath.row)
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "Description"
            cell.detailTextLabel?.text = viewModel.product?.detail?.capitalizingFirstLetter()
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 414 : 60
    }
}
