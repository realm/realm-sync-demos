//
//  FilledButton.swift
//  WKBoilerPlate
//
//  Created by Brian on 23/07/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import UIKit

class FilledButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Do app specific customizations for the button here.
        self.layer.cornerRadius = 0
        self.backgroundColor = UIColor.appPrimaryColor()
        self.titleLabel?.textColor = UIColor.white
    }
    /**
     Sets the common medium font of the app in requested size
     */
    func setBoldFontOfSize(size: CGFloat) {
        self.titleLabel?.font = UIFont.appBoldFont(withSize: size)
        self.titleLabel?.adjustsFontForContentSizeCategory = true
  }
}

class PlainTextButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Do app specific customizations for the button here.
        self.titleLabel?.textColor = UIColor.appDarkTextColor()
        self.setBoldFontOfSize(size: 14)
    }
    /**
     Sets the common medium font of the app in requested size
     */
    func setBoldFontOfSize(size: CGFloat) {
        self.titleLabel?.font = UIFont.appBoldFont(withSize: size)
        self.titleLabel?.adjustsFontForContentSizeCategory = true
  }
}
