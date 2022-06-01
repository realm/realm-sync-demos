//
//  GenderSelectionViewController.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/29/22.
//

import UIKit
protocol SelectGender {
    func didSelectGender(_ gender: String)
}

class GenderSelectionViewController: BaseViewController {
    @IBOutlet weak var buttomVerticalSpace: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerData: [String] = [String]()
    @IBOutlet weak var doneButton : UIButton!
    @IBOutlet weak var cancelButton : UIButton!
    var selectedGender: String = ""
    var delegate: SelectGender!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect data:
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
                
        // Input the data into the array
        pickerData = ["Male", "Female", "Others"]
        if self.selectedGender == "" {
            self.selectedGender = "Male"
        }
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

    // MARK: - IBAction
    @IBAction func actionDidDone(_ sender: UIButton) {
        if self.cancelButton == sender {
            self.dismiss(animated: false, completion: nil)
        } else if doneButton == sender {
            if self.delegate != nil {
                self.delegate.didSelectGender(selectedGender)
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

}
extension GenderSelectionViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
        
    // The data to return fopr the row and component (column) that's being passed
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    // The select object from didselectrow method
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.delegate != nil {
            self.selectedGender = pickerData[row]
            self.delegate.didSelectGender(pickerData[row])
        }
    }
}
