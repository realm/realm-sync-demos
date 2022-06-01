//
//  ConditionBookingViewController.swift
//  MDBRealmPatient
//
//  Created by Mackbook on 07/05/22.
//

import UIKit

class ConditionBookingViewController: BaseViewController {
    @IBOutlet var tableView         : UITableView!
    @IBOutlet var viewModel         : ConditionBookingViewModel!
    var delegate                    : ConditionDataSource!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButtonToNav()
        self.title = "Select Concern"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadConditionObject()
    }
    func loadConditionObject() {
        self.viewModel.getConditionObject()
        self.tableView.reloadData()
    }
    @IBAction func actionDidOpen(_ sender: UIButton) {
        if let patientInfoVC =
            Constants.mainStoryBoard.instantiateViewController(withIdentifier: "BasicPatientInfoViewController") as? BasicPatientInfoViewController {
            patientInfoVC.isHiddenNextButton = true
            self.navigationController?.pushViewController(patientInfoVC, animated: true)
        }
    }
    func deleteConditionObject(index: IndexPath) {
        self.showLoader()
        let condition = self.viewModel.ConditionBookingList?[index.row]
        self.viewModel.deleteCondition(condition: condition!, onSuccess: {response in
            DispatchQueue.main.async {
                self.hideLoader()
                self.loadConditionObject()
            }
        }, onFailure: {errorMessage in
            self.hideLoader()
            self.showMessage(message: errorMessage)
        })
    }
}
extension ConditionBookingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.ConditionBookingList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let condition = self.viewModel.ConditionBookingList?[indexPath.row]
        cell.textLabel?.text = condition?.code?.text
        cell.detailTextLabel?.text = condition?.notes
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 4
        cell.textLabel?.font = .poppinsSemiBoldFont(withSize: 12)
        cell.detailTextLabel?.font = .appRegularFont(withSize: 10)
        cell.detailTextLabel?.textColor = .darkGray
        return cell
    }
}
extension ConditionBookingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.delegate != nil {
            let condition = self.viewModel.ConditionBookingList?[indexPath.row]
            self.delegate.didSelectForRowAt(object: condition as Any)
            self.navigationController?.popViewController(animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.showAlertViewWithBlock(message: "Do you want to Delete?", btnTitleOne: "Yes", btnTitleTwo: "No", completionOk: {()in
                self.deleteConditionObject(index: indexPath)
            }, cancel: {()in})
        }
    }
}

