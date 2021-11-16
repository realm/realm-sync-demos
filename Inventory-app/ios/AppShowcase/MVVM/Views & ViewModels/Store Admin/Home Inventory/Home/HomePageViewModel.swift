//
//  HomePageViewModel.swift
//  AppShowcase
//
//  Created by Gagandeep on 31/08/21.
//

import UIKit
import RealmSwift

class HomePageViewModel: NSObject {
    var products:  Results<StoreInventory>?
    var filteredArray: Results<StoreInventory>?
    var lowStockProducts:  Results<StoreInventory>?
    var notificationToken: NotificationToken?
    var lowStockNotfnToken: NotificationToken?

    func getProducts(){
        self.products = RealmManager.shared.getAllInventories()
        self.filteredArray = self.products
        self.lowStockProducts = RealmManager.shared.getLowStockInventories()
    }
    //check count
    var productCount:  Int {
        return self.filteredArray?.count ?? 0
    }
    //Getting single product
    func cellRowIndexPath(index:Int) -> StoreInventory?{
        return filteredArray?[index]
    }
    func searchList(text:String){
        let filteredResults = products?.filter("productName CONTAINS[c] %@", text.lowercased()).sorted(byKeyPath: "productName", ascending: true)
        filteredArray =  text.isEmpty ? products : filteredResults
//        filteredArray =  text.isEmpty ? products : products.filter{ $0.productName.lowercased().localizedCaseInsensitiveContains(text.lowercased())}.sorted{$0.productName < $1.productName}
      
    }
}
