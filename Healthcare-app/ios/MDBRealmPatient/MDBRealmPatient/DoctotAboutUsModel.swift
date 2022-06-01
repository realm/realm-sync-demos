//
//  DoctotAboutUsModel.swift
//  MDBRealmPatient
//
//  Created by Mackbook on 5/23/22.
//

import Foundation
import RealmSwift

class DoctotAboutUsModel: NSObject {
    var practitionerObject: Practitioner?
    var practitionerId: ObjectId?
    var notificationToken: NotificationToken?
    func getPratitioner(){
        self.practitionerObject = RealmManager.shared.getPractitionerById(practitinerId: practitionerId ?? RealmManager.shared.defaultObjectId)
    }
}
