//
//  Procedure.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 02/05/22.
//

import Foundation
import RealmSwift

class Procedure: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
     @Persisted var encounter: Encounter?
     @Persisted var identifier: String?
     @Persisted var note: List<Procedure_Notes>
     @Persisted var nurseIdentifier: String?
     @Persisted var patientIdentifier: String?
     @Persisted var practitionerIdentifier: String?
     @Persisted var status: String?
     @Persisted var subject: Patient?
     @Persisted var usedReference: List<Medication>
    
//    override init() {}
//
//    convenience init(_id: ObjectId,identifier : String, note : List<Procedure_Notes>, status : String,subject : Patient, usedReference : List<Medication>, encounter : Encounter?) {
//        self.init()
//
//        self._id                = _id
//        self.identifier         = identifier
//        self.note               = note
//        self.status             = status
//        self.subject            = subject
//        self.usedReference      = usedReference
//        self.encounter          = encounter
//    }
}

class Procedure_Notes: EmbeddedObject {
    @Persisted var author: Reference?

    @Persisted var text: String?

    @Persisted var time: Date?
    
    override init() {}
    
    convenience init(author : Reference?,text : String,time : Date) {
        self.init()
        self.author         = author
        self.text           = text
        self.time           = time
    }
}

class Reference: EmbeddedObject {
    
    @Persisted var coding: List<Coding>

    @Persisted var identifier: ObjectId?

    @Persisted var reference: String?

    @Persisted var text: String?

    @Persisted var type: String?
    
    override init() {}
    
    convenience init(coding : List<Coding>, identifier : ObjectId?, reference : String, text: String, type: String ) {
        self.init()
        
        self.coding     = coding
        self.identifier = identifier
        self.reference  = reference
        self.text       = text
        self.type       = type
    }
}

class Coding: EmbeddedObject {
    @Persisted var code: String?

    @Persisted var display: String?

    @Persisted var system: String?
}

class Medication: EmbeddedObject {
    @Persisted var amount: Int?

    @Persisted var code: Codable_Concept?

    @Persisted var form: Codable_Concept?

}

class Codable_Concept: EmbeddedObject {
    @Persisted var coding: List<Coding>

    @Persisted var text: String?
}
