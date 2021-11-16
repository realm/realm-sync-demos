//  ViewExtension.swift
//  WKBoilerPlate
//
//  Created by Brian on 24/07/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /**
     Make rounded corner for the view with a gray border
     - borderColor : appDarkTextColor
     - borderWidth : 1.0
     - cornerRadius : height / 2
     */
    func makeRoundCorner() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.borderColor = UIColor.appDarkTextColor().cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }

    /**
     Make rounded corner for the view without border
     - cornerRadius : height / 2
     */
    func makeRoundCornerWithoutBorder() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.borderWidth = 0.0
        self.layer.masksToBounds = true
    }

    /**
     Make rounded corner for the view with custom radius
     - borderColor : appDarkTextColor
     - borderWidth : 1.0
     - cornerRadius : height / 2
     - Parameter radius: value for the cornerRadius
     */
    func makeRoundCorner(withRadius radius: CGFloat, borderColor border: UIColor? = nil) {
        self.layer.cornerRadius = radius
        self.layer.borderColor = (border != nil) ? border?.cgColor :  UIColor.appDarkTextColor().cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
    
    /**
     Make rounded corner for the view without border
     - cornerRadius : height / 2
     */
    func makeRoundCornerWithoutBorder(withRadius radius: CGFloat? = 0.0) {
        self.layer.cornerRadius = radius == 0.0 ? self.bounds.height/2: radius!
        self.layer.borderWidth = 0.0
        self.layer.masksToBounds = true
    }

    /**
     Adds shadow for the view
     - shadowRadius : 3.0
     - shadowOpacity : 1.0
     - shadowColor : black 50%
     - shadowOffset : CGSize(0,1)
     */
    func setShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowColor = UIColor(hexString: "#000000", alpha: 0.5).cgColor
    }

    /**
     To animate and bring a view from top of the screen
     */
    func showFromTopWithAnimation() {
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y = 0
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }

    /**
     To animate and send a view off to the top
     */
    func hideToTopWithAnimation() {
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
    
    /// To blink or flash a  view
    func blink() {
        self.alpha = 0.3
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }

}

extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}
