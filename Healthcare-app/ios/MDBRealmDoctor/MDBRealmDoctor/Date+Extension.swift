//
//  Date+Extension.swift
//  Practitioner
//
//  Created by Karthick TM on 18/05/22.
//

import Foundation
import UIKit

//MARK: - Date Extension
extension Date {
    
    //Computed property for fetching tomorrow and yesterday date
    var tomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    
    var yesterday: Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    
    //Function to get todays date
    func getTodaysDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    //Function to get tomorrow date
    func tomorrowString() -> String  {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = UIConstants.generalF.dateFormatSuggested
        if let tomorrow = today.tomorrow {
            let tomorrowString = dateFormatter.string(from: tomorrow)
            return tomorrowString
        }
        return ""
    }
    
    func yesterdayDate() -> String  {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = UIConstants.generalF.dateFormatSuggested
        if let tomorrow = today.yesterday {
            let tomorrowString = dateFormatter.string(from: tomorrow)
            return tomorrowString
        }
        return ""
    }
}
