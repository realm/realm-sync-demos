//
//  DoctorDetailsViewController.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/22/22.
//

import UIKit
import RealmSwift

class DoctorDetailsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewModel: HospitalPageViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButtonToNav()
        self.title = "Hospitals"
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "DashboardTableViewCell", bundle: nil), forCellReuseIdentifier: "DashboardTableViewCell")
        let nib = UINib(nibName: "HeaderTableViewCell", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "HeaderTableViewCell")
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 380
        self.loadProducts()
        self.observeRealmChanges()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight : CGFloat = 490
        if scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0 {
            scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        }else if scrollView.contentOffset.y >= sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0)
        }
    }
    // MARK: - Private methods
    
    private func observeRealmChanges()  {
        // Observe collection notifications. Keep a strong
         // reference to the notification token or the
         // observation will stop.
        viewModel.notificationToken = viewModel.practitionerObject?.observe { [weak self] (change: RealmCollectionChange) in
            switch change {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self?.loadProducts()
            case .update(_, _, _, _):
                self?.loadProducts()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
            
        }
    }
    // MARK: - Private methods
    private func loadProducts() {
        self.viewModel.getPractitionerRole()
        self.tableView.reloadData()
    }

    @IBAction func actionDidSelectDetails(_ sender: UIButton) {
        if let doctorAboutVC =
            Constants.dashboardStoryBoard.instantiateViewController(withIdentifier: "DoctotAboutUsViewController") as? DoctotAboutUsViewController {
            let practitionerRole = self.viewModel.practitionerRoleList[sender.tag]
            doctorAboutVC.practitionerRole = practitionerRole
            doctorAboutVC.viewModel.practitionerId = practitionerRole.practitioner?._id
            self.navigationController?.pushViewController(doctorAboutVC, animated: true)
        }
    }

}
extension DoctorDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.practitionerRoleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell", for: indexPath) as? DashboardTableViewCell)!
        cell.clickBtn.tag = indexPath.row
        cell.clickBtn.addTarget(self, action: #selector(actionDidSelectDetails(_:)), for: .touchUpInside)
        let practitioner = self.viewModel.practitionerRoleList[indexPath.row]
        cell.practitionerModel = practitioner
        return cell
    }
}
extension DoctorDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderTableViewCell")  as! HeaderTableViewCell
        view.model = self.viewModel.organization
        view.sliderCollectionView.reloadData()
        return view
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}
