//
//  Ecounter.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 02/05/22.
//

import Foundation
import RealmSwift

class Encounter: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var appointment: Appointment?
    @Persisted var diagnosis: Diagnosis?
    @Persisted var identifier: String?
    @Persisted var nurseIdentifier: String?
    @Persisted var participant: List<Encounter_Participant>
    @Persisted var practitionerIdentifier: String?
    @Persisted var reasonReference: Reference?
    @Persisted var serviceProvider: Reference?
    @Persisted var status: String?
    @Persisted var subject: Patient?
    @Persisted var subjectIdentifier: String?
    
//    override init() {}
//
//    convenience init(appointment : Appointment?,diagnosis : Diagnosis?,identifier : String, participant : List<Encounter_Participant>, reasonReference : Reference?, serviceProvider : Reference?, status : String, subject :  Patient?) {
//        self.init()
//
//        self.appointment        = appointment
//        self.diagnosis          = diagnosis
//        self.identifier         = identifier
//        self.participant        = participant
//        self.reasonReference    = reasonReference
//        self.serviceProvider    = serviceProvider
//        self.status             = status
//        self.subject            = subject
  //  }
}

class Diagnosis: EmbeddedObject {
    @Persisted var condition: Reference?
    
    @Persisted var rank: Int?
    
    @Persisted var use: Codable_Concept?
    
    override init() {}
    
    convenience init(condition : Reference?,rank : Int, use : Codable_Concept?) {
        self.init()
        
        self.condition = condition
        self.rank      = rank
        self.use       = use
    }
}

class Encounter_Participant: EmbeddedObject {
    @Persisted var individual: Reference?
    
    @Persisted var type: Codable_Concept?
    
    override init() {}
    
    convenience init(individual : Reference,type : Codable_Concept) {
        self.init()
        
        self.individual     = individual
        self.type           = type
    }
}
