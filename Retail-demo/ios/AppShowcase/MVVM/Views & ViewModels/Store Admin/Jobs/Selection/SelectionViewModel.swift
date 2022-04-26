//
//  SelectionViewModel.swift
//  AppShowcase
//
//  Created by Brian Christo on 08/09/21.
//

import Foundation
import RealmSwift

enum SelectionType: Int {
    case inventories = 0 //default
    case stores = 1
    case users = 2
    case jobType = 3
}

class SelectionViewModel: NSObject {
    var inventories: [StoreInventory]?
    var stores: Results<Stores>? //[Stores]?
    var users: Results<Users>? //[Users]?
    var jobTypes: [String] = [JobType.delivery.rawValue, JobType.installation.rawValue]
    var selectionType: SelectionType = .inventories
    
    var rowCount: Int? {
        switch selectionType {
        case .stores:
            return stores?.count
        case .users:
            return users?.count
        case .jobType:
            return jobTypes.count
        default:
            return inventories?.count
        }
    }
    
    func cellRowIndexPath(index:Int) -> String {
        switch selectionType {
        case .stores:
            return stores?[index].name ?? ""
        case .jobType:
            return jobTypes[index]
        case .users:
            let firstName = users?[index].firstName ?? ""
            let lastName = users?[index].lastName ?? ""
            return  firstName + " " + lastName
        default:
            return inventories?[index].productName ?? ""
        }
    }

    // MARK: - Search
    
    func searchInventories(forKey text:String) {
        if text.isEmpty {
            self.inventories = Array(RealmManager.shared.getAllInventories()!) //?? []
        } else {
            self.inventories = RealmManager.shared.getInventoryForSearchKey(key: text) ?? []
        }
    }
    
    func searchStores(forKey text:String) {
        if text.isEmpty {
            self.stores = RealmManager.shared.getAllStoresButMyCurrentStore() 
        } else {
            self.stores = RealmManager.shared.getStoreForSearchKey(key: text)
        }
    }
    
    func searchUsers(forKey text:String) {
        if text.isEmpty {
            self.users = RealmManager.shared.getAllDeliveryUsers()
        } else {
            self.users = RealmManager.shared.getDeliveryUserForSearchKey(key: text)
        }
    }
    
}
