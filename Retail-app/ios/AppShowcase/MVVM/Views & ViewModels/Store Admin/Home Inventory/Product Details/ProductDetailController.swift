//
//  ProductDetailController.swift
//  AppShowcase
//
//  Created by Gagandeep on 31/08/21.
//

import UIKit

class ProductDetailController: BaseViewController {
    
    @IBOutlet weak var productScrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel! {
        didSet {
            
        }
    }
    @IBOutlet weak var skuLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var minusBtn: UIButton!{
        didSet {
            self.minusBtn.setTitle(nil, for: .normal)
        }
    }
    @IBOutlet weak var plusBtn: UIButton! {
        didSet {
            self.plusBtn.setTitle(nil, for: .normal)
        }
    }
    @IBOutlet weak var editStockTxtFld: UITextField! {
        didSet {
            self.editStockTxtFld.isUserInteractionEnabled = false
        }
    }

    var viewModel = ProductDetailViewModel()
    
    // MARK: - View Controller Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        observeRealmChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Private methods
    
    private func observeRealmChanges()  {
        // Observe collection notifications. Keep a strong
         // reference to the notification token or the
         // observation will stop.
        viewModel.productNotfnToken = viewModel.product?.observe { [weak self] change in
            self?.loadData()
        }
        viewModel.inventoryNotfnToken = viewModel.inventory?.observe { [weak self] change in
            self?.loadData()
        }
    }

    private func loadData(){
        self.navigationItem.title = viewModel.product?.name.capitalizingFirstLetter()
        self.productNameLbl.text = viewModel.product?.name.capitalizingFirstLetter()
        self.priceLbl.text = "$\(viewModel.product?.price ?? 0.00)"
        self.quantityLbl.text = "Quantity: \(viewModel.product?.totalQuantity ?? 0) remaining"
        self.skuLbl.text = "SKU: \(viewModel.product?.sku ?? 0)"
        self.descriptionLbl.text = viewModel.product?.detail?.capitalizingFirstLetter()
        self.editStockTxtFld.text = "\(viewModel.inventory?.quantity ?? 0)"
    
        if let urlStr =  viewModel.product?.image {
            let urlstring = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlStr

            guard let url = URL(string: urlstring) else {
                self.productImage.image = nil
                return
            }
            self.productImage.af.setImage(withURL: url)
        } else {
            self.productImage.image = nil
        }
        
    }
    
    // MARK: - Button Actions
    
    @IBAction private func minusAction(_ sender: UIButton) {
        if let quantity = Int(self.editStockTxtFld.text ?? "0") {
            RealmManager.shared.updateStockQuantity(forInventory: viewModel.inventory!, withStock: quantity-1) { status in
            }
        }
    }
    
    @IBAction private func plusAction(_ sender: UIButton) {
        if let quantity = Int(self.editStockTxtFld.text ?? "0") {
            RealmManager.shared.updateStockQuantity(forInventory: viewModel.inventory!, withStock: quantity+1) { status in
            }
        }
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
