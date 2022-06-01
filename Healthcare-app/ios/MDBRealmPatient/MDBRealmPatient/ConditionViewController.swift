//
//  ConditionViewController.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 5/2/22.
//

import UIKit

protocol ConditionDataSource {
    func didSelectForRowAt(object: Any)
}

class ConditionViewController: BaseViewController {
    @IBOutlet weak var buttomVerticalSpace: NSLayoutConstraint!
    @IBOutlet var tableView         : UITableView!
    @IBOutlet var viewModel         : ConditionViewModel!
    var delegate:ConditionDataSource!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.loadConditions()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.buttomVerticalSpace.constant = 0
        UIView.animate(withDuration: 0.50) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func actionDidClosed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    // MARK: - Private methods
    
    private func loadConditions() {
        self.viewModel.getMasterCodes()
        self.tableView.reloadData()
    }
}
extension ConditionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.MasterCodeList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell)
        let condition = self.viewModel.MasterCodeList?[indexPath.row]
        cell.textLabel?.text = condition?.name
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
extension ConditionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.delegate != nil {
            let condition = self.viewModel.MasterCodeList?[indexPath.row]
            self.delegate.didSelectForRowAt(object: condition as Any)
            self.dismiss(animated: false, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
