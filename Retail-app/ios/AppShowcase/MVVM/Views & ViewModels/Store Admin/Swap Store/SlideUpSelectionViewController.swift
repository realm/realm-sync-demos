//
//  SlideUpSelectionViewController.swift
//  AppShowcase
//
//  Created by Brian Christo on 20/02/22.
//

import UIKit

protocol SlideUpSelectionDelegate  {
    func didSwapStore(store: Stores)
}


class SlideUpSelectionViewController: BaseViewController {
    var viewModel = SlideUpSelectionViewModel()
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    var delegate: SlideUpSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = 80 //UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UINib(nibName: CellIdentifier.storesTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.storesTableViewCell)
        titleView.makeRoundCornerWithoutBorder(withRadius: 15)
        refreshData()
    }
    
    func refreshData() {
        self.viewModel.getStores()
        self.tableView.reloadData()
        self.tableHeight.constant = viewModel.rowCount ?? 1 < 4 ? 300 : tableView.contentSize.height
        self.view.layoutIfNeeded()
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
        }
    }
}

//MARK: - UITableView
extension SlideUpSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.rowCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.storesTableViewCell, for: indexPath) as? StoreListTableViewCell ?? StoreListTableViewCell()
        let store = self.viewModel.stores[indexPath.row]
        viewModel.configureStore(storeObj: store, onCell: cell)
        cell.storeName.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = self.viewModel.stores[indexPath.row]
        self.showLoader()
        self.delegate?.didSwapStore(store: store)
        self.navigationController?.popViewController(animated: true)
    }
}
