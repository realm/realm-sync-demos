//
//  BookingHistoryViewController.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/25/22.
//

import UIKit
import RealmSwift

class BookingHistoryViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewModel: BookingHistoryModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButtonToNav()
        self.title = "Consultations"
        self.tableView.register(UINib(nibName: "DashboardTableViewCell", bundle: nil), forCellReuseIdentifier: "DashboardTableViewCell")
        self.tableView.register(UINib(nibName: "BookingHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingHistoryTableViewCell")
        self.viewModel.getProducts()
    }
    // MARK: - @IBAction
    @objc @IBAction func actionDidSelectDetails(_ sender: UIButton) {
        if let bookingDetailsVC =
            Constants.dashboardStoryBoard.instantiateViewController(withIdentifier: "BookingDetailsViewController") as? BookingDetailsViewController {
            bookingDetailsVC.viewModel.procedureDetailsObject = self.viewModel.procedureUpcomingList?[sender.tag]
            self.navigationController?.pushViewController(bookingDetailsVC, animated: true)
        }
    }
    @objc @IBAction func actionDidSelectPastDetails(_ sender: UIButton) {
        if let bookingDetailsVC =
            Constants.dashboardStoryBoard.instantiateViewController(withIdentifier: "BookingDetailsViewController") as? BookingDetailsViewController {
            bookingDetailsVC.viewModel.procedureDetailsObject = self.viewModel.procedurePastList?[sender.tag]
            self.navigationController?.pushViewController(bookingDetailsVC, animated: true)
        }
    }
}
extension BookingHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.viewModel.procedureUpcomingList?.count ?? 0
        } else {
            return self.viewModel.procedurePastList?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "BookingHistoryTableViewCell", for: indexPath) as? BookingHistoryTableViewCell)!
            cell.clickBtn.tag = indexPath.row
            cell.clickBtn.addTarget(self, action: #selector(actionDidSelectDetails(_:)), for: .touchUpInside)
            let procedure = self.viewModel.procedureUpcomingList?[indexPath.row]
            cell.model = procedure
            return cell
        } else {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell", for: indexPath) as? DashboardTableViewCell)!
            cell.clickBtn.tag = indexPath.row
            cell.clickBtn.addTarget(self, action: #selector(actionDidSelectPastDetails(_:)), for: .touchUpInside)
            let procedure = self.viewModel.procedurePastList?[indexPath.row]
            cell.procedure = procedure
            return cell
        }
    }
}
extension BookingHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        } else {
            return 105
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Upcoming" : "Past"
    }
}
