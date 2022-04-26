//
//  BorderedTextField.swift
//  WKBoilerPlate
//
//  Created by Brian on 24/07/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import UIKit

class BorderedTextField: UITextField, UITextFieldDelegate {
    let padding = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Round the corners
        self.layer.cornerRadius = 5.0
        // set Common font
        self.setRegularFont(ofSize: 14)
        layer.borderColor = UIColor.appLightTextColor().cgColor
        self.backgroundColor = UIColor.appTextFieldBG()
        setPlaceholderText(placeholderText: placeholder ?? "")
    }
    
    /// Sets the style for placeholder
    /// - Parameter placeholderText: placeholder  text for the textfield
    func setPlaceholderText(placeholderText: String) {
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]

        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes:attributes)
    }

    /**
     Sets the common light font of the app in requested size
     */
    func setRegularFont(ofSize size: CGFloat) {
        self.font = UIFont.appRegularFont(withSize: size)
        self.adjustsFontForContentSizeCategory = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.appLightTextColor().cgColor
    }
}
