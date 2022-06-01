//
//  ConditionViewModel.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 5/2/22.
//

import Foundation
import RealmSwift

class ConditionViewModel: NSObject {
    var MasterCodeList: Results<Code>?
        
    func getMasterCodes(){
        self.MasterCodeList = RealmManager.shared.getAllMasterCode(category: "conditions")
    }
}
