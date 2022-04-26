//
//  HomePageController.swift
//  AppShowcase
//
//  Created by Gagandeep on 31/08/21.
//

import UIKit
import RealmSwift

class HomePageController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lowStockCollectionView: UICollectionView! {
        didSet {
            self.lowStockCollectionView.makeRoundCornerWithoutBorder(withRadius: 5)
            self.lowStockCollectionView.setShadow()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.delegate = self
            self.searchBar.placeholder = "Search"
        }
    }
    @IBOutlet weak var totalCountLbl: UILabel! {
        didSet {
            self.totalCountLbl.makeRoundCornerWithoutBorder(withRadius: 5)
        }
    }
    @IBOutlet var viewModel: HomePageViewModel!

    // MARK: - View Controller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLogoOnNavBarLeftItem()
        observeRealmChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        loadProducts()
    }
    
    private func observeRealmChanges()  {
        // Observe collection notifications. Keep a strong
         // reference to the notification token or the
         // observation will stop.
        viewModel.notificationToken = viewModel.products?.observe { [weak self] (changes: RealmCollectionChange) in
             guard let collectionView = self?.collectionView else { return }
            self?.reactToRealmChanges(onCollection: collectionView, realmChanges: changes)
         }
        viewModel.lowStockNotfnToken = viewModel.lowStockProducts?.observe { [weak self] (changes: RealmCollectionChange) in
             guard let collectionView = self?.lowStockCollectionView else { return }
            self?.reactToRealmChanges(onCollection: collectionView, realmChanges: changes)
            self?.lowStockCollectionView.isHidden = self?.viewModel.lowStockProducts?.count == 0
         }
    }
    
    func reactToRealmChanges(onCollection collectionView: UICollectionView,realmChanges changes: RealmCollectionChange<Results<StoreInventory>> )  {
        
        collectionView.reloadData()
    }
    // MARK: - Private methods
    
    private func loadProducts() {
        self.viewModel.getProducts()
        self.collectionView.reloadData()
        if self.viewModel.lowStockProducts == nil || self.viewModel.lowStockProducts?.count == 0 {
            self.lowStockCollectionView.isHidden = true
        } else {
            self.lowStockCollectionView.isHidden = false
            self.lowStockCollectionView.reloadData()
        }
        self.totalCountLbl.text = "  Total Items: \(viewModel.filteredArray?.count ?? 0)  "
        self.setStoreInfoOnNavBarRight()
    }
    
    // MARK: - Button Actions
    
    @IBAction private func openSearchbar(_ sender: UIBarButtonItem) {
        searchBar.placeholder = "Search"
    }

    private func cancelBarButtonItemClicked() {
        self.searchBarCancelButtonClicked(self.searchBar)
    }
    
    @objc private func searchBarOpenAction(){
        searchBar.placeholder = "Search"
    }
}

// MARK:- Collection view Delegate and Data source methods

extension HomePageController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView ==  lowStockCollectionView ? self.viewModel.lowStockProducts?.count ?? 0 : self.viewModel.filteredArray?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView ==  lowStockCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.lowStockCell, for: indexPath) as? ProductsCollectionViewCell
            cell?.productImage.makeRoundCornerWithoutBorder(withRadius: 5.0)
            let inventory = self.viewModel.lowStockProducts?[indexPath.row]
            cell?.model = inventory
            cell?.productQty.text = "Stock: Only \(inventory?.quantity ?? 0) Remaining"
            return cell!
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.productCollectionViewCell, for: indexPath) as? ProductsCollectionViewCell
//            cell?.contentView.makeRoundCorner(withRadius: 0)
            cell?.makeRoundCornerWithoutBorder(withRadius: 15)
            cell?.setShadow()
            cell?.productImage.makeRoundCornerWithoutBorder(withRadius: 5.0)
            cell?.model = self.viewModel.cellRowIndexPath(index: indexPath.row)
            return cell!
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView ==  lowStockCollectionView {
            let result = self.viewModel.lowStockProducts?[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.productDetailPage.rawValue) as? ProductDetailController
            vc?.viewModel.inventory = result
            vc?.viewModel.product = RealmManager.shared.getProduct(withId: (result?.productId)!)
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            let result = self.viewModel.cellRowIndexPath(index: indexPath.row)
            let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.productDetailPage.rawValue) as? ProductDetailController
            vc?.viewModel.inventory = result
            vc?.viewModel.product = RealmManager.shared.getProduct(withId: (result?.productId)!)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           if collectionView ==  lowStockCollectionView {
               return CGSize(width: UIScreen.main.bounds.width -  16.0 * 2.0, height: 70)
           } else {
               let collectionViewWidth = (UIScreen.main.bounds.width - 16.0 * 3.0) / 2.0
               return CGSize(width: collectionViewWidth, height: 180)
           }
       }
       
}

// MARK: - SearchBar Delegates
extension HomePageController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        self.viewModel.searchList(text: searchText)
        self.collectionView.reloadData()
    }
    @objc func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.loadProducts()
    }
}
