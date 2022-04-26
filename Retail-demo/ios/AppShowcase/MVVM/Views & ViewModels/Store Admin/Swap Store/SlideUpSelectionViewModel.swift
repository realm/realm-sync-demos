//
//  SlideUpSelectionViewModel.swift
//  AppShowcase
//
//  Created by Brian Christo on 20/02/22.
//

import Foundation
import RealmSwift

class SlideUpSelectionViewModel: NSObject {
    var stores = RealmSwift.List<Stores>()
    var rowCount: Int? {
        return stores.count
    }
    var storesSelected = [Stores]()

    // MARK: -
    
    func cellRowIndexPath(index:Int) -> String {
        return stores[index].name
    }

    func getStores() {
        let myUserInfo = RealmManager.shared.getMyUserInfo()
        self.stores = myUserInfo?.stores ?? List<Stores>()
    }

    func configureStore(storeObj store: Stores, onCell cell: StoreListTableViewCell) {
        let storeId = UserDefaults.standard.value(forKey: Defaults.stores) as? String ?? ""
        cell.storeName.text = store.name
        cell.radioSelectButton.isHighlighted = (store._id.stringValue == storeId)
    }
}
