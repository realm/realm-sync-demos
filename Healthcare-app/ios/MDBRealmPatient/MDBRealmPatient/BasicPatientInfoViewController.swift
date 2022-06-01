//
//  BasicPatientInfoViewController.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/21/22.
//

import UIKit
import RealmSwift

class BasicPatientInfoViewController: BaseViewController {
    @IBOutlet var tableView         : UITableView!
    @IBOutlet weak var conditionTextField: UITextField! {
        didSet {
            self.conditionTextField.placeholder = ConstantsID.SignUpControllerID.condition
            self.conditionTextField.backgroundColor = UIColor.init(hexString: UIColor.Colors.textFieldBackClr, alpha: 1)
        }
    }
    @IBOutlet weak var createButton : UIButton! {
        didSet {
            self.createButton.setTitle(ConstantsID.SignUpControllerID.nextText, for: .normal)
        }
    }
    @IBOutlet weak var addConditionButton : UIButton! {
        didSet {
            
            self.addConditionButton.layer.borderColor = UIColor.init(hexString: UIColor.Colors.appThemeColorOrange, alpha: 1).cgColor
            self.addConditionButton.layer.borderWidth = 1
            self.addConditionButton.layer.backgroundColor = UIColor.white.cgColor
            self.addConditionButton.setTitleColor(UIColor.init(hexString: UIColor.Colors.appThemeColorOrange, alpha: 1), for: .normal)
        }
    }
    @IBOutlet weak var conditionNote: UITextView!
    
    // MARK:- Variable Declarations
    @IBOutlet weak var viewModel: BasicPatientInfoViewModel!
    var isHiddenNextButton = false
    lazy private var singleTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onSingleTapped))
        gesture.cancelsTouchesInView = true
        return gesture
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(singleTapGesture)
        self.addBackButtonToNav()
        self.title = "Basic Patient Info"
        self.createButton.isHidden = self.isHiddenNextButton
        self.tableView.isHidden = self.isHiddenNextButton
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableView.automaticDimension
        self.createButton.disableTap()
        
    }
    // MARK: - Keyboard Functions
    @objc func onSingleTapped() {
        view.endEditing(true)
    }
    @IBAction func actionDidCreate(_ sender: UIButton) {
        if let dashboardVC =
            Constants.dashboardStoryBoard.instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController {
            self.navigationController?.pushViewController(dashboardVC, animated: true)
        }
    }
    @IBAction func actionDidOpen(_ sender: UIButton) {
        self.view.endEditing(true)
        if let conditionVC = Constants.mainStoryBoard.instantiateViewController(withIdentifier: "ConditionViewController") as? ConditionViewController {
            conditionVC.modalPresentationStyle = .overCurrentContext
            conditionVC.delegate = self
            self.present(conditionVC, animated: false, completion: nil)
            
        }
    }
    @IBAction func actionDidAddCondition(_ sender: UIButton) {
        self.showLoader()
        self.viewModel.createCondition(onSuccess: {response in
            self.hideLoader()
            self.conditionTextField.text = ""
            self.conditionNote.text = ""
            if self.isHiddenNextButton {
                self.showAlertViewWithBlock(message: "Added Successfully", btnTitleOne: "Ok", btnTitleTwo: "", completionOk: {()in
                    self.navigationController?.popViewController(animated: true)
                }, cancel: {()in})
            } else {
                self.loadConditionObject()
            }
        }, onFailure: {errorMessage in
            self.hideLoader()
            self.showMessage(message: errorMessage)
        })
    }
   
}
extension BasicPatientInfoViewController: ConditionDataSource {
    func didSelectForRowAt(object: Any) {
        if let getobject = object as? Code {
            self.conditionTextField.text = getobject.name
            let coding = Coding()
            coding.code = getobject.code
            coding.display = getobject.name
            coding.system = getobject.system
            self.viewModel.codingList.append(coding)
            viewModel.conditionOption = getobject.name ?? ""
        }
    }
}
// MARK:- UITextFieldDelegate
extension BasicPatientInfoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            if oldString.isEmpty && string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            var newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
            newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
            if textField == conditionTextField {
                viewModel.conditionOption = newString
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField)  {
        if textField == conditionTextField {
            viewModel.conditionOption = textField.text ?? ""
        }
    }
}
// MARK:- UITextViewDelegate
extension BasicPatientInfoViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let oldString = textView.text {
            if oldString.isEmpty && text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            var newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: text)
            newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
            if textView == conditionNote {
                viewModel.conditionNotes = newString
            }
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == conditionNote {
            viewModel.conditionNotes = textView.text ?? ""
        }
    }
}
extension BasicPatientInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.conditionBookingList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let condition = self.viewModel.conditionBookingList?[indexPath.row]
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
extension BasicPatientInfoViewController: UITableViewDelegate {
    
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
    func deleteConditionObject(index: IndexPath) {
        self.showLoader()
        let condition = self.viewModel.conditionBookingList?[index.row]
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
    func loadConditionObject() {
        self.viewModel.getConditionObject()
        self.tableView.reloadData()
        if self.viewModel.conditionBookingList?.count ?? 0 > 0 {
            self.createButton.enableTap()
        }
    }
}
