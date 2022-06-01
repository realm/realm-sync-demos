//
//  DOBViewController.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/29/22.
//

import UIKit
protocol SelectDafeOfBirth {
    func didSelectDateofBirth(_ dob: String)
}
class DOBViewController: BaseViewController {
    @IBOutlet weak var buttomVerticalSpace: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIDatePicker!
    @IBOutlet weak var doneButton : UIButton!
    @IBOutlet weak var cancelButton : UIButton!
    var selectedDate: String = ""
    var delegate: SelectDafeOfBirth!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.maximumDate = Date()
        pickerView.addTarget(self, action: #selector(DOBViewController.datePickerValueChanged(_:)), for: .valueChanged)
        if self.selectedDate == "" {
            self.selectedDate = dateFormat().string(from: Date())
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.buttomVerticalSpace.constant = 0
        UIView.animate(withDuration: 0.50) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
           
        self.selectedDate = dateFormat().string(from: sender.date)
        if self.delegate != nil {
            self.delegate.didSelectDateofBirth(selectedDate)
        }
    }
    func dateFormat() -> DateFormatter {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }
    @IBAction func actionDidClosed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    // MARK: - IBAction
    @IBAction func actionDidDone(_ sender: UIButton) {
        if self.cancelButton == sender {
            self.dismiss(animated: false, completion: nil)
        } else if doneButton == sender {
            if self.delegate != nil {
                self.delegate.didSelectDateofBirth(selectedDate)
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}

