//
//  Condition.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 02/05/22.
//

import Foundation
import RealmSwift


class Condition: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var active: Bool?
    @Persisted var code: Codable_Concept?
    @Persisted var notes: String?
    @Persisted var subject: Reference?
    @Persisted var subjectIdentifier: String?
    
//    override init() {}
//
//    convenience init(_id: ObjectId, code: Codable_Concept?, notes: String?,subject: Reference? ) {
//        self.init()
//
//        self._id    = _id
//        self.code   = code
//        self.notes  = notes
//        self.subject = subject
//    }
}

