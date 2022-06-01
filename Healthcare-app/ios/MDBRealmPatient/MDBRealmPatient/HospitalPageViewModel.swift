//
//  HospitalPageViewModel.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/29/22.
//

import Foundation
import RealmSwift

class HospitalPageViewModel: NSObject {
    var organization: Organization?
    var practitionerRoleList = [PractitionerRole]()
    var notificationToken: NotificationToken?
    var practitionerObject: Results<Practitioner>?
    var practitionerId: ObjectId?
    func getPractitionerRole(){
        self.practitionerRoleList = RealmManager.shared.getAllPractitioner(hospitalId: organization!._id)
        
        self.practitionerObject = RealmManager.shared.getAllPractitioner()
    }
}
