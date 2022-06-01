//
//  BookingHistoryModel.swift
//  MDBRealmPatient
//
//  Created by Mackbook on 08/05/22.
//

import Foundation
import RealmSwift

class BookingHistoryModel: NSObject {
    var practitionerRole: PractitionerRole?
    var procedureUpcomingList: Results<Procedure>?
    var procedurePastList: Results<Procedure>?
    var procedureDetailsObject: Procedure?
    
    func getProducts(){
        self.procedureUpcomingList = RealmManager.shared.getAllProcedure(filterByDate: "Upcoming")
        self.procedurePastList = RealmManager.shared.getAllProcedure(filterByDate: "Past")
    }
    func getDetailsProducts() {
        _ = self.procedureDetailsObject?.encounter?.appointment?.participant
    }
}
