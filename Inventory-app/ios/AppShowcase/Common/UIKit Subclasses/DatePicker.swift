//
//  SearchViewController.swift
//  AppShowcase
//
//  Created by Gagandeep on 01/09/21.
import Foundation
import UIKit

protocol DatePickerDelegate  {
    func didSelectDate(date: Date)
}
open class DatePicker: NSObject {
    private let datePicker: UIDatePicker
    private weak var presentationController: UIViewController?
    private weak var textfield: UITextField?
    var dateDelegate : DatePickerDelegate?
    
    public init(presentationController: UIViewController, textfield: UITextField, isDate:Bool) {
        self.datePicker = UIDatePicker()
        super.init()
        self.presentationController = presentationController
        self.textfield = textfield
        self.showDatePicker(showDate: true, showTime: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func showDatePicker(showDate: Bool, showTime: Bool) {
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.tintColor = .appPrimaryColor()
//        datePicker.backgroundColor = .appPrimaryColor()
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        self.textfield!.inputAccessoryView = toolbar
        self.textfield?.inputView = datePicker
    }
    
    @objc func donedatePicker(){
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEE, MMMM dd, yyyy"
//        self.textfield!.text = formatter.string(from: datePicker.date)
        self.dateDelegate?.didSelectDate(date: datePicker.date)
        self.presentationController?.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.presentationController?.view.endEditing(true)
     }
    
}
