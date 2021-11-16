//
//  BorderedButton.swift
//  WKBoilerPlate
//
//  Created by Brian on 24/07/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import UIKit

class BorderedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Do app specific customizations for the button here.
        self.layer.cornerRadius = 5.0
        self.backgroundColor = UIColor.white
        self.titleLabel?.textColor = UIColor.appLightTextColor()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.appLightTextColor().cgColor
        self.layer.masksToBounds = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
}
