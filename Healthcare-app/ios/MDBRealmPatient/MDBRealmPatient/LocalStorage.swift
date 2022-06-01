//
//  LocalStorage.swift
//  LNT-Timesheet
//
//  Created by Apple on 25/04/2022.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

struct LocalStorage {
    
    // MARK: YourNetWork
    static func defaultMenu()  -> NSMutableArray {
        return yourMenuList()
    }
    // MARK: YourNetWork Get Data
    private static func yourMenuList() -> NSMutableArray  {
        let filePath = Bundle.main.path(forResource: "LocalStorage", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: filePath)!
        let menuData = dictionary.value(forKey: "menu") as? NSMutableArray ?? []
        return menuData
    }
}

