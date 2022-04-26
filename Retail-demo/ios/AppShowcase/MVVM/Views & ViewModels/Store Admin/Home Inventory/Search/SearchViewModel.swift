//
//  SearchViewModel.swift
//  AppShowcase
//
//  Created by Gagandeep on 01/09/21.
//

import Foundation
class SearchViewModel:NSObject{
    var filteredInventories:[StoreInventory] = [StoreInventory]()

    var count:Int?{
        return filteredInventories.count
    }
    
    func cellRowIndexPath(index:Int) -> StoreInventory {
        return filteredInventories[index]
    }
    
    //Matching Search keywords
    func searchProducts(forKey text:String) {
        if text.isEmpty {
            self.filteredInventories = Array(RealmManager.shared.getAllInventories()!)//?? []
        } else {
            self.filteredInventories = RealmManager.shared.getInventoryForSearchKey(key: text) ?? []
        }
    }
}
