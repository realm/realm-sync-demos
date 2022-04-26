//
//  ManageStoreViewController.swift
//  AppShowcase
//
//  Created by Brian Christo on 10/02/22.
//

import UIKit

class ManageStoreViewController: BaseViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var screenTitleLabel : UILabel! {
       didSet {
           self.screenTitleLabel.text = ConstantsID.ManageStoreControllerUI.screenTitleText
       }
    }
    @IBOutlet weak var createButton : UIButton! {
        didSet {
            self.createButton.setTitle(ConstantsID.ManageStoreControllerUI.submitButtonText, for: .normal)
        }
    }
    @IBOutlet weak var storeListTableView : UITableView! {
        didSet {
            self.storeListTableView.delegate = self
            self.storeListTableView.dataSource = self
        }
    }
    
    //MARK: - Variables
    var viewModel = ManageStoreViewModel()

    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Cell identifier registration
        self.storeListTableView.register(UINib(nibName: CellIdentifier.storesTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.storesTableViewCell)
        
        viewModel.getStores()
        storeListTableView.reloadData()
    }
    
    //MARK: - Button Actions
        
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        self.viewModel.updateStoresForUser { status in
            DispatchQueue.main.async {
                self.syncRealmDataAndGotoHome()
            }
        }
    }

    @IBAction func radioSelectStoreAction(_ sender: UIButton) {
        
    }

}

//MARK: -  UITableView

extension ManageStoreViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allStores?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.storesTableViewCell) as! StoreListTableViewCell
        cell.radioSelectButton.tag = indexPath.row
        let store = viewModel.allStores?[indexPath.row]
        viewModel.configureStore(storeObj: store!, onCell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ConstantsID.ManageStoreControllerUI.screenSubHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store =  viewModel.allStores?[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as!  StoreListTableViewCell
        if cell.radioSelectButton.isHighlighted {
            let stores = viewModel.storesSelected.filter{$0._id != store?._id}
            viewModel.storesSelected = stores
        } else {
            viewModel.storesSelected.append(store!)
        }
        tableView.reloadData()
    }
    
}

