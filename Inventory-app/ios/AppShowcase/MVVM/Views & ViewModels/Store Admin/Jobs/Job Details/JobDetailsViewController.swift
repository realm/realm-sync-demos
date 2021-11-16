//
//  CreateJobViewController.swift
//  AppShowcase
//
//  Created by Gagandeep on 01/09/21.
//

import UIKit
import RealmSwift

class JobDetailsViewController: BaseViewController {
    var viewModel =  JobDetailsViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Job #\(viewModel.job._id)"
        //viewModel.job = RealmManager.shared.getJob(withId: viewModel.job._id)
        viewModel.job.observe { [weak self] change in
            self?.refreshData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        refreshData()
        if RealmManager.shared.getMyUserInfo()?.userRole == UserRole.deliveryUser.rawValue {
            statusBtn.isUserInteractionEnabled = true
        } else {
            statusBtn.isUserInteractionEnabled = false
        }
    }
    
    func refreshData() {
        self.tableView.reloadData()
        self.statusBtn.setTitle(self.viewModel.job.status.capitalizingFirstLetter(), for: .normal)
    }

    // MARK: - Actions
    
    @objc func assigneeChangeBtnAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.kSelectionViewController.rawValue) as? SelectionViewController
        vc?.delegate = self
        vc?.viewModel.selectionType = .users
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func statusChangeBtnAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Update Job Status", message: "", preferredStyle: .actionSheet)
        alert.view.tintColor = .black
        
        alert.addAction(UIAlertAction(title: JobStatus.todo.rawValue.capitalizingFirstLetter(), style: .default , handler:{ (UIAlertAction)in
            self.updateJobStatus(status: JobStatus.todo.rawValue)
        }))
        alert.addAction(UIAlertAction(title: JobStatus.inprogress.rawValue.capitalizingFirstLetter(), style: .default , handler:{ (UIAlertAction)in
            self.updateJobStatus(status: JobStatus.inprogress.rawValue)
        }))
        alert.addAction(UIAlertAction(title: JobStatus.done.rawValue.capitalizingFirstLetter(), style: .default , handler:{ (UIAlertAction)in
            self.updateJobStatus(status: JobStatus.done.rawValue)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func updateJobStatus(status: String) {
        RealmManager.shared.updateJobStatus(status: status, forJob: viewModel.job) { completed in
            DispatchQueue.main.async {
                self.refreshData()
                self.showMessage(message: "Job status is updated")
            }
        }
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
            cell?.assigneeDropdown.addTarget(self, action: #selector(assigneeChangeBtnAction(_:)), for: .touchUpInside)
            cell?.assigneeStack.isHidden = self.viewModel.deliveryUser
            viewModel.configureJobCell(cell: cell ?? JobDetailTableViewCell())
            return cell!
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.productQuantityTableViewCell, for: indexPath) as? ProductQuantityTableViewCell
            viewModel.configureProductCell(cell: cell ?? ProductQuantityTableViewCell(), atIndex: indexPath.row)
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? self.viewModel.deliveryUser == true ? 360-50 : 360 :  60
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? ""  : "Products"
    }
}

extension JobDetailsViewController: SelectionDelegate{
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
