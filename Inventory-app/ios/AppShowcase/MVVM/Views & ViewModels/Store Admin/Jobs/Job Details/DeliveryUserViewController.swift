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
        viewModel.doneJobsNotificationToken?.invalidate()
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
        viewModel.doneJobsNotificationToken = viewModel.doneJobs?.observe { [weak self] (changes: RealmCollectionChange) in
            self?.reactToRealmChanges(onCollection: tblView, realmChanges: changes)
         }
    }
    
    func reactToRealmChanges(onCollection tableView: UITableView, realmChanges changes: RealmCollectionChange<Results<Jobs>> )  {
        DispatchQueue.main.async {
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.performBatchUpdates({
                    // Always apply updates in the following order: deletions, insertions, then modifications.
                    // Handling insertions before deletions may result in unexpected behavior.
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                         with: .automatic)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
                }, completion: { finished in
                    // ...
                })
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
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
        return (viewModel.currentJobsCount + viewModel.doneJobsCount)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.jobsTableViewCell, for: indexPath) as? JobsTableViewCell
        if indexPath.row < viewModel.currentJobs?.count ?? 0 {
            cell?.model = viewModel.currentJobs?[indexPath.row]
        } else {
            cell?.model = viewModel.doneJobs?[indexPath.row - viewModel.currentJobsCount]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Job details page
        let vc = Router.getVC(withId: StoryboardID.KJobDetailsViewController.rawValue, fromStoryboard: Storyboards.storeAdmin) as? JobDetailsViewController
        if indexPath.row < viewModel.currentJobs?.count ?? 0 {
            vc?.viewModel.job = (viewModel.currentJobs?[indexPath.row])!
        } else {
            vc?.viewModel.job = (viewModel.doneJobs?[indexPath.row - viewModel.currentJobsCount])!
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
