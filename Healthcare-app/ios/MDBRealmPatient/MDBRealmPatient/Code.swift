//
//  Condition.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 5/2/22.
//

import Foundation
import RealmSwift

class Code: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var active: Bool?
    @Persisted var category: String?
    @Persisted var code: String?
    @Persisted var comments: String?
    @Persisted var name: String?
    @Persisted var system: String?
}
