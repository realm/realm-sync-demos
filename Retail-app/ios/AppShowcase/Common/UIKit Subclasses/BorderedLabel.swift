//
//  BorderedLabel.swift
//  AppShowcase
//
//  Created by Brian Christo on 17/09/21.
//

import UIKit

class BorderedLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Do app specific customizations for the button here.
        self.layer.cornerRadius = 5.0
        self.backgroundColor = UIColor.white
        self.textColor = UIColor.appLightTextColor()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.appLightTextColor().cgColor
        self.layer.masksToBounds = true
        self.font = UIFont.systemFont(ofSize: 15)
    }
}
