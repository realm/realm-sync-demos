//
//  ConditionBookingViewModel.swift
//  MDBRealmPatient
//
//  Created by Mackbook on 07/05/22.
//

import Foundation
import RealmSwift

class ConditionBookingViewModel: NSObject {
    var ConditionBookingList    : Results<Condition>?
    func getConditionObject(){
        self.ConditionBookingList = RealmManager.shared.getUserCondition()
    }
    ///  Delete Condition API call
    /// - Parameters: Condition Object
    ///   - completionHandler: completionHandler with success and error
    func deleteCondition(condition: Condition, onSuccess success: @escaping OnSuccess,
               onFailure failure: @escaping OnFailure) {
        RealmManager.shared.deleteCondition(condition: condition, success: { completed in
            success(completed)
        })
    }
}
