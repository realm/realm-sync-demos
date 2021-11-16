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
        return UIFont.systemFont(ofSize: size).adaptiveResize()
    }
    
    class func appBoldFont(withSize size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size).adaptiveResize()
    }
}
