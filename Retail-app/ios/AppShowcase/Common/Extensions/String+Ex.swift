//
//  String+Ex.swift
//  AppShowcase
//
//  Created by Gagandeep on 31/08/21.
//

import Foundation


import UIKit
struct Validator{
    enum Validate {
        case regularExp(SRegularExpression)
        case predicate(SPredicate)
        
        func formatter(in string: String)->Bool{
            switch self {
             case .regularExp(let field):
                return field.firstMatch(in: string)
            case .predicate(let field):
                return field.evaluate(with: string)
            }
        }
    }
    enum SRegularExpression {
        case alphanumeric
        case alphanumericWithSpace
        case email
        case specialChar
        case address
        case onlyNumbers
        case onlyNumbersWithPlus
        case onlyAlphabet
        
        var regularExp:String{
            switch self {
                
            case .alphanumeric: return "[^a-zA-Z0-9 ]"
            case .alphanumericWithSpace: return "[^A-Z0-9a-z ]"
            case .email:
                return"^(?!(?:(?:\\x22?\\x5C[\\x00-\\x7E]\\x22?)|(?:\\x22?[^\\x5C\\x22]\\x22?)){255,})(?!(?:(?:\\x22?\\x5C[\\x00-\\x7E]\\x22?)|(?:\\x22?[^\\x5C\\x22]\\x22?)){65,}@)(?:(?:[\\x21\\x23-\\x27\\x2A\\x2B\\x2D\\x2F-\\x39\\x3D\\x3F\\x5E-\\x7E]+)|(?:\\x22(?:[\\x01-\\x08\\x0B\\x0C\\x0E-\\x1F\\x21\\x23-\\x5B\\x5D-\\x7F]|(?:\\x5C[\\x00-\\x7F]))*\\x22))(?:\\.(?:(?:[\\x21\\x23-\\x27\\x2A\\x2B\\x2D\\x2F-\\x39\\x3D\\x3F\\x5E-\\x7E]+)|(?:\\x22(?:[\\x01-\\x08\\x0B\\x0C\\x0E-\\x1F\\x21\\x23-\\x5B\\x5D-\\x7F]|(?:\\x5C[\\x00-\\x7F]))*\\x22)))*@(?:(?:(?!.*[^.]{64,})(?:(?:(?:xn--)?[a-z0-9]+(?:-+[a-z0-9]+)*\\.){1,126}){1,}(?:(?:[a-z][a-z0-9]*)|(?:(?:xn--)[a-z0-9]+))(?:-+[a-z0-9]+)*)|(?:\\[(?:(?:IPv6:(?:(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){7})|(?:(?!(?:.*[a-f0-9][:\\]]){7,})(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,5})?::(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,5})?)))|(?:(?:IPv6:(?:(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){5}:)|(?:(?!(?:.*[a-f0-9]:){5,})(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,3})?::(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,3}:)?)))?(?:(?:25[0-5])|(?:2[0-4][0-9])|(?:1[0-9]{2})|(?:[1-9]?[0-9]))(?:\\.(?:(?:25[0-5])|(?:2[0-4][0-9])|(?:1[0-9]{2})|(?:[1-9]?[0-9]))){3}))\\]))$"
            case .specialChar: return ".*[^A-Za-z0-9 ].*"
            case .address: return ".*[^A-Za-z0-9._@#/()-+*., ].*"
            case .onlyNumbers: return ".*[^A-Za-z ].*"
            case .onlyNumbersWithPlus: return ".*[^0-9+].*"
            case .onlyAlphabet: return ".*[^A-Za-z ].*"
                
            }
        }
        var expression:NSRegularExpression? {
            switch self {
            case .email:
                return try? NSRegularExpression(pattern: self.regularExp, options: .caseInsensitive)
            default :
                return try? NSRegularExpression(pattern: self.regularExp, options: [])
            }
        }
        
        func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = []) -> Bool{
            guard let expression = expression, !string.isEmpty else { return false}
            return expression.firstMatch(in: string, options: options, range: NSMakeRange(0, string.count)) == nil ? false : true
        }
    }
    enum SPredicate {
        case password
        case phoneNumber
        case validateUrl
        var regularExp:String{
            switch self {
            case .password: return "^(?=.*[A-Z])(?=.*[0-9])(?=.*[@$#]).{8,}$"
            case .phoneNumber: return "^\\d{3}-\\d{3}-\\d{4}$"
            case .validateUrl: return "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
                
            }
        }
        var predicate:NSPredicate{
            return NSPredicate(format: "SELF MATCHES %@", self.regularExp)
        }
        func evaluate(with object: Any?) -> Bool{
            return predicate.evaluate(with: object)
        }
        
        
    }
    
}


extension String{
    //MARK:- String Validation
    
    //MARK:- validFormatter
    func validFormatter(_ formate:Validator.Validate)->Bool{
        guard !self.isEmpty else {return false}
        return formate.formatter(in: self)
    }
    //MARK:- isAlphanumericWithSpace
    var isAlphanumericWithSpace: Bool {
        return validFormatter(.regularExp(.alphanumericWithSpace))
    }
    //MARK:- isAlphanumeric
    var isAlphanumeric: Bool {
        return validFormatter(.regularExp(.alphanumeric))
    }
    //MARK:- isEmail
    var isvalidEmail: Bool {
        return validFormatter(.regularExp(.email))
    }
    //MARK:- isSpecialChar
    var isSpecialChar: Bool {
        return validFormatter(.regularExp(.specialChar))
    }
    //MARK:- isAddress
    var isAddress: Bool {
        return validFormatter(.regularExp(.address))
    }
    
    //MARK:- onlyNumbers
    var isOnlyNumbers : Bool {
        return validFormatter(.regularExp(.onlyNumbers))
    }
    //MARK:- onlyNumbersWithPlus
    var isOnlyNumbersWithPlus: Bool {
        return validFormatter(.regularExp(.onlyNumbersWithPlus))
    }
    //MARK:- onlyAlphabet
    var isOnlyAlphabet:  Bool{
        return validFormatter(.regularExp(.onlyAlphabet))
    }
    //MARK:- isValidPassword
    var isPassword: Bool{
        return validFormatter(.predicate(.password))
    }
    
    //MARK:- isPhoneNumber
    var isPhoneNumber:Bool{
        return validFormatter(.predicate(.phoneNumber))
    }
    
    //MARK:- isValidateUrl
    var isValidateUrl : Bool {
        return validFormatter(.predicate(.validateUrl))
    }
    
    //MARK:- removeSpace
    var removeSpace:String{
        return self.components(separatedBy: .whitespaces).joined(separator: "")
    }
    //MARK:- containsAlphabets
    var containsAlphabets: Bool {
        //Checks if all the characters inside the string are alphabets
        let set = CharacterSet.letters
        return self.utf16.contains( where: { return set.contains(UnicodeScalar($0)!)  } )
    }

    //MARK:- safelyLimitedTo
    func safelyLimitedTo(length n: Int)->String {
        let c = String(self)
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
    //MARK:- height
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    //MARK:- width
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
    //MARK:- urlQueryEncoding
    /// Returns a new string made from the `String` by replacing all characters not in the unreserved
    /// character set (As defined by RFC3986) with percent encoded characters.
    
    var urlQueryEncoding: String? {
        let allowedCharacters = CharacterSet.urlQueryAllowed
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        
    }
    //MARK:- isEqualTo
    func isEqualTo(other:String)->Bool{
        return self.caseInsensitiveCompare(other) == .orderedSame ? true : false
    }
}
