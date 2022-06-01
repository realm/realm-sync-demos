//
//  Code.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 02/05/22.
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
    
    override init() {}
    
    convenience init(id: ObjectId,active: Bool, category: String?,code: String?, comments: String?, name: String?, system: String?) {
        self.init()
        
        self.active     = active
        self._id        = id
        self.category   = category
        self.code       = code
        self.comments   = comments
        self.name       = name
        self.system     = system
    }
}
