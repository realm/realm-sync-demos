//  FontExtension.swift
//  WKBoilerPlate

import UIKit

extension UIFont {
    /// scales the font for different devices
    func adaptiveResize() -> UIFont {
        let scaleFactor = (UIScreen.main.scale == 3.0) ? 1.2 : (UIScreen.main.scale == 2.0) ? 1.1 : 1.0
        let size = self.pointSize * CGFloat(scaleFactor)
        if #available(iOS 11.0, *) {
            return UIFontMetrics.default.scaledFont(for: self.withSize(size))
        } else {
            return self.withSize(size)
        }
    }

    // MARK: - Open Sans

    class func appRegularFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: size)?.adaptiveResize() ?? UIFont(name: "Poppins-Regular", size: size)!
    }
    
    class func appBoldFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Bold", size: size)?.adaptiveResize() ?? UIFont(name: "Poppins-Bold", size: size)!
    }
    class func appSemiBoldFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: size)?.adaptiveResize() ?? UIFont(name: "Poppins-SemiBold", size: size)!
    }
    class func poppinsBoldFont(withSize size: CGFloat) -> UIFont {
        guard let boldFont = UIFont(name: "Poppins-Bold", size: size) else {
            return UIFont.boldSystemFont(ofSize: size)
        }
        return boldFont.adaptiveResize()
    }

    class func poppinsSemiBoldFont(withSize size: CGFloat) -> UIFont {
        guard let regFont = UIFont(name: "Poppins-SemiBold", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return regFont.adaptiveResize()
    }
    
    class func poppinsMediumFont(withSize size: CGFloat) -> UIFont {
        guard let regFont = UIFont(name: "Poppins-Medium", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return regFont.adaptiveResize()
    }

}
