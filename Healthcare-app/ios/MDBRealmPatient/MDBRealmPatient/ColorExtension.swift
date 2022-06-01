//
//  ColorExtension.swift
//  MDBRealmPatient
//
//  Created by Ram on 01/06/22.
//

import Foundation
//
//  Color+Extension.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import Foundation
import UIKit

extension UIColor {
    // MARK: - Color codes used in the app -
    /**
     List of Color code Constants used in the app
     */
    struct Colors {
        static let appPrimaryColor  = "#EE4557"
        static let appScreenBG      = "#FFFFFF"
        static let appDarkText      = "#000000"
        static let appLightText     = "#B4B4B4"
        static let appTextFieldText = "#000000"
        static let appTextFieldPlaceholder = "#231F20"
        static let appTextFieldBorder   = "#FFFFFF"
        static let calendarlightGray    = "#F2F2F2"
        static let appRedColor          = "#EE4557"
        static let textFieldBackClr     = "#F0F0F0"
        static let appThemeColorOrange  = "#F15A56"
        static let appGreeenColor       = "#22AA0C"
        static let appPopupDarkBG       = "#292E3A"
        static let backgroundColorTextfield      = "#767680"
        static let textColorInSearchBar         = "#3C3C43"
        static let doctorInfotextFieldBacClr     = "#F8F8F8"
        static let greenClr                      = "#22AA0C"
    }
    
    // MARK: - Initializations -
    
    /**
     Initializes the UIColor using hexa color code and alpha value
     - Parameter hexString: the hexa color code with or without '#'
     - Parameter alpha: transparency to be applied between 0.0 to 1.0, defaults to 1.0
     */
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let rInt = Int(color >> 16) & mask
        let gInt = Int(color >> 8) & mask
        let bInt = Int(color) & mask
        
        let red = CGFloat(rInt) / 255.0
        let green = CGFloat(gInt) / 255.0
        let blue = CGFloat(bInt) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    /**
     Converts UIColor to hexa colorcode
     - returns: the hexa color code of the UIColor prefixed with #
     */
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
        return String(format: "#%06x", rgb)
    }
    
    /// Checks whether the color is bright shaded or dark shaded
    /// - Parameter color: the given color to be checked
    /// - returns: true - for bright colors, false - for dark colors, default - true when color components are undefined
    func isBrightColor() -> Bool {
        guard let colors: [CGFloat] = self.cgColor.components else { return true }
        let colorBrightness: CGFloat = ((colors[0] * 299) + (colors[1] * 587) + (colors[2] * 114)) / 1000
        return colorBrightness >= 0.5
    }
    
    // MARK: - UIColors used in the app -
    
    class func appCalendarSelectBGColor() -> UIColor {
        return UIColor(hexString: Colors.appPrimaryColor, alpha: 1.0)
    }
    
    class func appPrimaryColor() -> UIColor {
        return UIColor(hexString: Colors.appPrimaryColor, alpha: 1.0)
    }
    
    class func appDarkTextColor() -> UIColor {
        return UIColor(hexString: Colors.appDarkText, alpha: 1.0)
    }
    
    class func appLightTextColor() -> UIColor {
        return UIColor(hexString: Colors.appLightText, alpha: 1.0)
    }
    
    class func appCalendarLightGrayColor() -> UIColor {
        return UIColor(hexString: Colors.calendarlightGray, alpha: 1.0)
    }
    
    class func appBGColor() -> UIColor {
        return UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    }
    
    class func appRedColor() -> UIColor {
        return UIColor(hexString: Colors.appRedColor, alpha: 1.0)
    }
    
    class func appBorderColor() -> UIColor {
        return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.27)
    }
    
    class func appGreenColor() -> UIColor {
        return UIColor(hexString: Colors.appGreeenColor, alpha: 1.0)
    }
    
    class func appTextFieldBG() -> UIColor  {
        return UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.12)
    }
    
    class func appPopupDarkBGColor() -> UIColor {
        return UIColor(red: 0.161, green: 0.18, blue: 0.227, alpha: 1)
    }
    
    class func appGrayBG() -> UIColor {
        return UIColor(red: 0.942, green: 0.942, blue: 0.942, alpha: 1)
    }
    
    class func appGeneralThemeClr() -> UIColor {
        return UIColor(hexString: Colors.appThemeColorOrange, alpha: 1.0)
    }
    
    class func doctorTextField() -> UIColor {
        return UIColor.init(hexString: Colors.doctorInfotextFieldBacClr, alpha: 0.6)
    }
    
    class func textfieldClrSet(alpha : CGFloat) -> UIColor {
        return UIColor.init(hexString: Colors.textFieldBackClr, alpha: alpha)
    }
    
    class func greenClr() -> UIColor {
        return UIColor.init(hexString: Colors.greenClr, alpha: 1)
    }
    
    class func textClrSearch() -> UIColor {
        return UIColor.init(hexString: Colors.textColorInSearchBar, alpha: 1)
    }
    
}
