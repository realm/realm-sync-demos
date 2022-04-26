//  TextFieldExtension.swift
//  WKBoilerPlate
//
//  Created by Brian on 18/09/19.
//  Copyright © 2019 WeKan. All rights reserved.
//

import UIKit

extension UITextField {
    /**
     Sets the textfield and it's placeholder with the Common Bold font of the app in requested size
     - texColorFor placeholder : app's dark text color with 45% alpha
     - Parameter size: size of the font
     */
    func setBoldFontOfSize(size: CGFloat) {
        self.font = UIFont.appBoldFont(withSize: size)
        self.adjustsFontForContentSizeCategory = true
 }

    /**
     Sets the textfield and it's placeholder with the Common Regular font of the app in requested size
     - texColorFor placeholder : app's dark text color with 45% alpha
     - Parameter size: size of the font
     */
    func setRegularFontOfSize(size: CGFloat) {
        self.font = UIFont.appRegularFont(withSize: size)
        self.adjustsFontForContentSizeCategory = true
    }
}
