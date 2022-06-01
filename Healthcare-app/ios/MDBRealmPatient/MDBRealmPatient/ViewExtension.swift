//
//  ViewExtension.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/22/22.
//

import Foundation
import UIKit

extension UIView {
    
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
     Make rounded corner for the view without border
     - cornerRadius : height / 2
     */
    func makeRoundCornerWithoutBorder(withRadius radius: CGFloat? = 0.0) {
        self.layer.cornerRadius = radius == 0.0 ? self.bounds.height/2: radius!
        self.layer.borderWidth = 0.0
        self.layer.masksToBounds = true
    }
}

@IBDesignable class customShadowView: UIView {
    var shadowAdded: Bool = false

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if shadowAdded { return }
        shadowAdded = true

        let shadowLayer = UIView(frame: self.frame)
        shadowLayer.layer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
        shadowLayer.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        shadowLayer.layer.shadowOpacity = 0.5
        shadowLayer.layer.shadowRadius = 1
        shadowLayer.layer.masksToBounds = true
        shadowLayer.clipsToBounds = false
        shadowLayer.backgroundColor = UIColor.clear

        self.superview?.addSubview(shadowLayer)
        self.superview?.bringSubviewToFront(self)
    }
}
