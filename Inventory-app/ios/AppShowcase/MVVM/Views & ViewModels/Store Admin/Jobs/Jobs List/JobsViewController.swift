//
//  JobsViewController.swift
//  AppShowcase
//
//  Created by Gagandeep on 01/09/21.
//

import UIKit
import RealmSwift

class JobsViewController: BaseViewController {
    @IBOutlet var viewModel: JobsViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalCountLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 303
        tableView.rowHeight = UITableView.automaticDimension
        
        if let store = RealmManager.shared.getMyStore() {
            self.navigationItem.title = store.name.capitalizingFirstLetter()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        loadJobs()
    }
    
    // MARK: - Private methods
    
    private func loadJobs() {
        viewModel.getJobs()
        tableView.reloadData()
        totalCountLbl.text = "Total Items: \(viewModel.currentJobsCount)"
        observeRealmChanges()
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
            self.totalCountLbl.text = "Total Items: \(self.viewModel.currentJobsCount)"
        case .update(_, _, _, _):
            // Query results have changed, so apply them to the UITableView
            tableView.reloadData()
            self.totalCountLbl.text = "Total Items: \(self.viewModel.currentJobsCount)"
        case .error(let error):
            // An error occurred while opening the Realm file on the background worker thread
            fatalError("\(error)")
        }
    }

    // MARK: - Actions

    @IBAction func createJobBTN(_ sender: UIBarButtonItem) {
        //Create Job
        let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.KCreateJobViewController.rawValue) as? CreateJobViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
extension JobsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentJobsCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.jobsTableViewCell, for: indexPath) as? JobsTableViewCell
        cell?.model = viewModel.currentJobs?[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Job details page
        let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.KJobDetailsViewController.rawValue) as? JobDetailsViewController
        vc?.viewModel.job = (viewModel.currentJobs?[indexPath.row])!
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
