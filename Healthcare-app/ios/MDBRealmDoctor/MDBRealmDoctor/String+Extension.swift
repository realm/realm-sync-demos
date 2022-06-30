//
//  String+Extension.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 27/04/22.
//

import Foundation


extension String {
    
    //Check the email format 
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    /**
     Makes the First letter of the string to UpperCase
     */
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    /**
     Makes the First letter of the string to UpperCase
     */
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
