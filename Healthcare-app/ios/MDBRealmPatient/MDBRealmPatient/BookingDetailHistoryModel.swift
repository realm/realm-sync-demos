//
//  BookingDetailHistoryModel.swift
//  MDBRealmPatient
//
//  Created by Mackbook on 10/05/22.
//

import Foundation
import RealmSwift

class BookingDetailsHistoryModel: NSObject {
    var procedureDetailsObject: Procedure?
    var notificationToken: NotificationToken?
    
    func setProcedureObject(procedure: ObjectId) {
        procedureDetailsObject = RealmManager.shared.getProcedureById(procedureId: procedure)
    }
}
