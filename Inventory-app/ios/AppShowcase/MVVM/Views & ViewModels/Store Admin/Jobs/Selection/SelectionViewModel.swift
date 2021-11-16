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
}

class SelectionViewModel: NSObject {
    var inventories: [StoreInventory]?
    var stores: [Stores]?
    var users: [Users]?
    var selectionType: SelectionType = .inventories
    
    var rowCount: Int? {
        switch selectionType {
        case .stores:
            return stores?.count
        case .users:
            return users?.count
        default:
            return inventories?.count
        }
    }
    
    func cellRowIndexPath(index:Int) -> String {
        switch selectionType {
        case .stores:
            return stores?[index].name ?? ""
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
            self.stores = RealmManager.shared.getAllStores() ?? []
        } else {
            self.stores = RealmManager.shared.getStoreForSearchKey(key: text) ?? []
        }
    }
    
    func searchUsers(forKey text:String) {
        if text.isEmpty {
            self.users = RealmManager.shared.getAllDeliveryUsers() ?? []
        } else {
            self.users = RealmManager.shared.getDeliveryUserForSearchKey(key: text) ?? []
        }
    }
}
