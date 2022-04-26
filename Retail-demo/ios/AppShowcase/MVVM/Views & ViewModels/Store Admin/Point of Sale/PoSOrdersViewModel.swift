//
//  PoSOrdersViewModel.swift
//  AppShowcase
//
//  Created by Brian Christo on 17/02/22.
//

import UIKit
import RealmSwift

class PoSOrdersViewModel: NSObject {
    var currentOrders: Results<Orders>?
    var currentOrdersNotificationToken: NotificationToken?
    var currentOrdersCount: Int {
        return currentOrders?.count ?? 0
    }

    func getOrders() {
        currentOrders = RealmManager.shared.getOrdersForStoreUser()
    }
}
