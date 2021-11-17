//
//  DeliveryUserViewController.swift
//  AppShowcase
//
//  Created by Gagandeep on 03/09/21.
//

import UIKit
import RealmSwift

class DeliveryUserViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewModel: DeliveryUserViewModel!
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 303
        tableView.rowHeight = UITableView.automaticDimension
        
        let userId = UserDefaults.standard.value(forKey: Defaults.userId) as? String ?? ""
        let userIdObj = try! RealmSwift.ObjectId(string: userId)
        let user = RealmManager.shared.getUser(withId: userIdObj)
        self.navigationItem.title = "\(user?.firstName?.capitalizingFirstLetter() ?? "") \(user?.lastName?.capitalizingFirstLetter() ?? "")"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadJobs()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.currentJobsNotificationToken?.invalidate()
        //        viewModel.doneJobsNotificationToken?.invalidate()
    }
    
    // MARK: - Private methods
    
    private func loadJobs() {
        self.viewModel.getJobs()
        self.tableView.reloadData()
        self.observeRealmChanges()
    }
    
    private func observeRealmChanges()  {
        // Observe collection notifications. Keep a strong
        // reference to the notification token or the
        // observation will stop.
        guard let tblView = self.tableView else { return }
        viewModel.currentJobsNotificationToken = viewModel.currentJobs?.observe { [weak self] (changes: RealmCollectionChange) in
            self?.reactToRealmChanges(onCollection: tblView, realmChanges: changes)
        }
    }
    
    func reactToRealmChanges(onCollection tableView: UITableView, realmChanges changes: RealmCollectionChange<Results<Jobs>> )  {
        switch changes {
        case .initial:
            // Results are now populated and can be accessed without blocking the UI
            tableView.reloadData()
        case .update(_, _, _, _):
            // Query results have changed, so apply them to the UITableView
            tableView.reloadData()
        case .error(let error):
            // An error occurred while opening the Realm file on the background worker thread
            fatalError("\(error)")
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func sideMenuBtnAction(){
        self.showAlertViewWithBlock(message: "Do you want to logout?", btnTitleOne: "Yes", btnTitleTwo: "No", completionOk: {()in
            DispatchQueue.main.async {
                RealmManager.shared.logoutAndClearRealmData()
            }
        }, cancel: {()in})
    }
}

extension DeliveryUserViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentJobsCount //(viewModel.currentJobsCount + viewModel.doneJobsCount)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.jobsTableViewCell, for: indexPath) as? JobsTableViewCell
        cell?.model = viewModel.currentJobs?[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Job details page
        let vc = Router.getVC(withId: StoryboardID.KJobDetailsViewController.rawValue, fromStoryboard: Storyboards.storeAdmin) as? JobDetailsViewController
        vc?.viewModel.job = (viewModel.currentJobs?[indexPath.row])!
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
