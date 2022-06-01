//
//  BasicPatientInfoViewModel.swift
//  MDBRealmPatient
//
//  Created by Mackbook on 06/05/22.
//

import Foundation
import RealmSwift

class BasicPatientInfoViewModel:NSObject{
    var conditionBookingList    : Results<Condition>?
    var conditionOption: String = ""
    var conditionNotes: String = ""
    var codingList = List<Coding>()
    
    func getConditionObject(){
        self.conditionBookingList = RealmManager.shared.getUserCondition()
    }
    /// Condition API call
    /// - Parameters:
    ///   - completionHandler: completionHandler with success and error
    func createCondition(onSuccess success: @escaping OnSuccess,
               onFailure failure: @escaping OnFailure) {
        validateForm { taskSuccess in
            RealmManager.shared.createCondition(condition: updateConditionData(), success: { completed in
                success(completed)
                if completed {
                    self.conditionOption = ""
                    self.conditionNotes = ""
                    self.codingList.removeAll()
                }
            })
        } failure: { error in
            failure(error)
        }
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
    func updateConditionData() -> Condition {
        let user = RealmManager.shared.app.currentUser?.customData as? Dictionary<String, AnyObject>
        var userIdString = ""
        if let userId = user?["_id"] as? RealmSwift.AnyBSON {
            userIdString = userId.stringValue ?? ""
        }
        let userObjId = try! RealmSwift.ObjectId(string: userIdString)
        let reference = Reference()
        reference.identifier = userObjId
        reference.reference = "Patient"
        reference.type = "Relative"
        
        let codableConcept = Codable_Concept()
        codableConcept.text = self.conditionOption
        codableConcept.coding = self.codingList
        
        let condition = Condition()
        condition.code = codableConcept
        condition.notes = self.conditionNotes
        condition.subject = reference
        condition._id = ObjectId.generate()
        condition.active = true
        condition.subjectIdentifier = RealmManager.shared.getPatientIdentifier()
        return condition
    }
    
    /// Validates the login form
    func validateForm(success onTaskSuccess: OnTaskSuccess, failure onFailure: @escaping OnFailure) {
        let conditionOption = self.conditionOption.trimmingCharacters(in: .whitespacesAndNewlines)
        let conditionNotes = self.conditionNotes
        
        if conditionOption.isEmpty {
            onFailure(FieldValidation.kConditionOptionEmpty)
            return
        }
        if conditionNotes.isEmpty {
            onFailure(FieldValidation.kConditionNotesEmpty)
            return
        }
        onTaskSuccess(true)
    }
}




