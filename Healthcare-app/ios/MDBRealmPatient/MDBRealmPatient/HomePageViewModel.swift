//
//  HomePageViewModel.swift
//  AppShowcase
//
//  Created by Gagandeep on 31/08/21.
//

import UIKit
import RealmSwift

class HomePageViewModel: NSObject {
    var organizationList: Results<Organization>?
    var organizationOriginalList: Results<Organization>?
    var notificationToken: NotificationToken?
    
    func getProducts(){
        self.organizationOriginalList = RealmManager.shared.getAllOrganization()
        self.organizationList = self.organizationOriginalList
    }
    func searchList(text:String){
        let filteredResults = self.organizationOriginalList?.filter("name CONTAINS[c] %@", text.lowercased()).sorted(byKeyPath: "name", ascending: true)
        self.organizationList =  text.isEmpty ? self.organizationOriginalList : filteredResults
    }
}
