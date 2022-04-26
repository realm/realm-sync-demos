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
    @IBOutlet weak var createJobBtn: FilledButton! 
    @IBOutlet weak var noDataAlertView: UIView! {
        didSet {
            self.noDataAlertView.isHidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLogoOnNavBarLeftItem()
        self.setStoreInfoAndFilterOnNavBar()
        tableView.estimatedRowHeight = 303
        tableView.rowHeight = UITableView.automaticDimension
        self.totalCountLbl.makeRoundCornerWithoutBorder(withRadius: 5)

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
    
    func setStoreInfoAndFilterOnNavBar() {
        var image = UIImage(named: "storeRed")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style:.plain, target: self, action: #selector(filterBTN(_:)))
        if let store = RealmManager.shared.getMyStore() {
            let label = UILabel()
            label.text = store.name.capitalizingFirstLetter()
            label.textAlignment = .right
            self.navigationItem.titleView = label
        }
    }
    
    private func loadJobs() {
        viewModel.getJobs()
        refreshUI()
        observeRealmChanges()
    }
    
    private func refreshUI() {
        self.tableView.reloadData()
    }
    
    private func refreshJobsCount() {
        self.totalCountLbl.text = "  Total Items: \(viewModel.currentJobsCount)  "
        self.noDataAlertView.isHidden = (viewModel.currentJobsCount > 0)
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
        case .initial, .update(_, _, _, _):
            // Query results are now available or have changed, so apply them to the UITableView
            self.refreshUI()
        case .error(let error):
            // An error occurred while opening the Realm file on the background worker thread
            fatalError("\(error)")
        }
    }

    // MARK: - Actions
    @IBAction func filterBTN(_ sender: Any) {
        let viewC = self.storyboard?.instantiateViewController(withIdentifier: "JobsFilterViewController") as! JobsFilterViewController
        viewC.delegate = self
        viewC.modalPresentationStyle = .popover
        viewC.modalTransitionStyle = .coverVertical
        self.navigationController?.present(viewC, animated: true, completion: {
            
        })
    }
    
    @IBAction func createJobBTN(_ sender: UIBarButtonItem) {
        //Create Job
        let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.createJobViewController.rawValue) as? CreateJobViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
extension JobsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        refreshJobsCount()
        return 1
    }
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
        let vc = self.storyboard?.instantiateViewController(identifier: StoryboardID.jobDetailsViewController.rawValue) as? JobDetailsViewController
        vc?.viewModel.job = (viewModel.currentJobs?[indexPath.row])!
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension JobsViewController: JobsFilterDelegate {
    func didSelectFilters(jobType: JobType?, jobStatus: JobStatus?) {
        viewModel.getFilteredJobs(jobtype: jobType, jobStatus: jobStatus)
        tableView.reloadData()
    }
}
