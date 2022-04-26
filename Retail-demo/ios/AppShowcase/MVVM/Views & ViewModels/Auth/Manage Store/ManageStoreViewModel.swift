//
//  ManageStoreViewModel.swift
//  AppShowcase
//
//  Created by Brian Christo on 10/02/22.
//

import Foundation
import RealmSwift

class ManageStoreViewModel {
    var allStores: Results<Stores>?
    var storesSelected = [Stores]() //RealmSwift.List<Stores>()

    func getStores(){
        self.allStores = RealmManager.shared.getAllStores()
    }

    func updateStoresForUser(success onTaskSuccess: @escaping OnTaskSuccess) {
        if storesSelected.isEmpty == false {
            RealmManager.shared.updateStoresForStoreUser(stores: storesSelected) { status in
                onTaskSuccess(status)
            }
        }
    }
    
    func configureStore(storeObj store: Stores, onCell cell: StoreListTableViewCell) {
        cell.storeName.text = store.name
        let filteredSelectedStore = storesSelected.filter{$0._id == store._id}
        cell.radioSelectButton.isHighlighted = (filteredSelectedStore.count > 0)
    }
}
