//
//  CreateJobViewController.swift
//  AppShowcase
//
//  Created by Gagandeep on 01/09/21.
//

import UIKit
import RealmSwift
import CoreLocation

class JobDetailsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel =  JobDetailsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Job #\(viewModel.job._id)"
        self.tableView.register(UINib(nibName: CellIdentifier.productTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.productTableViewCell)
        viewModel.job.observe { [weak self] change in
            self?.refreshData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        refreshData()
    }
    
    func refreshData() {
        self.tableView.reloadData()
    }

    // MARK: - Actions
    
    @objc func assigneeChangeBtnAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.selectionViewController.rawValue) as? SelectionViewController
        vc?.delegate = self
        vc?.viewModel.selectionType = .users
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}
extension JobDetailsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? viewModel.job.products.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.jobDetailTableViewCell, for: indexPath) as? JobDetailTableViewCell
            cell?.assigneeBtn.addTarget(self, action: #selector(assigneeChangeBtnAction(_:)), for: .touchUpInside)
            viewModel.configureJobCell(cell: cell ?? JobDetailTableViewCell())
            return cell!
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.productTableViewCell, for: indexPath) as? ProductTableViewCell
            cell?.productQuantityForOrder = viewModel.job.products[indexPath.row]
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 446 :  UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 446 : 60
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? ""  : "Products"
    }
}

extension JobDetailsViewController: SelectionDelegate{
    func didSelectJobType(type: String) {
        
    }
    
    func didSelectUser(user: Users) {
        RealmManager.shared.updateAssignee(user: user, forJob: viewModel.job) { completed in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func didSelectInventory(inventory: StoreInventory) {
    }
    func didSelectStore(store: Stores) {
    }
}
