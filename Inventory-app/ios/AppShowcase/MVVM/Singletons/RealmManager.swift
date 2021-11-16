//  RealmManager.swift
//
//  Created by Brian Christo on 09/06/21.
//

import Foundation
import RealmSwift

@objc final class RealmManager: NSObject {
    @objc static let shared = RealmManager()
    let app = App(id: AppConfig.Credentials.realmAppId)
    var masterRealm: Realm?
    var storeRealm: Realm?

    override private init() { }
    
    // MARK: - Login
    
    /// Login to the realm app with email and password
    func appLogin(email: String, pwd: String, onSuccess success: @escaping OnSuccess, onFailure failure: @escaping OnFailure) {
        
        let params: Document = ["email": AnyBSON(stringLiteral: email),
                                "password": AnyBSON(stringLiteral: pwd),
                                "action": AnyBSON(stringLiteral: "login")]

        app.login(credentials: Credentials.function(payload: params)) { (result) in
            switch result {
            case .failure(let error):
                print("Login failed: \(error.localizedDescription)")
                failure(error.localizedDescription)
            case .success(let user):
                print("Successfully logged in as user \(user)")
                // If the user data has been refreshed recently, you can access the
                // custom user data directly on the user object
                print("User custom data: \(user.customData)")
                let userCustomData = user.customData
                // Refresh the custom user data
                // save few data in userdefaults for easy access.
                self.saveUserDataToUserDefaults(userDict: userCustomData as [String : Any])
                success(userCustomData)
            }
        }
    }

    // MARK: - UserDefaults
    
    /// Saves some oftenly  accessed user data in UserDefaults
    /// - Parameter userDict: user json dict received from backend
    func saveUserDataToUserDefaults(userDict: [String: Any]) {
        // save user id, authtoken, and refresh token to UserDefaults
        let userId = userDict[Defaults.userId] as? RealmSwift.AnyBSON ?? ""
        let userRole = userDict[Defaults.userRole] as? RealmSwift.AnyBSON ?? ""
        let userAuthToken = userDict[Defaults.accessToken] as? RealmSwift.AnyBSON ?? ""
        let userRefreshToken = userDict[Defaults.refreshToken] as? RealmSwift.AnyBSON ?? ""
        let partition = userDict[Defaults.partition] as? RealmSwift.AnyBSON ?? ""
        let store = userDict[Defaults.stores] as? RealmSwift.AnyBSON
        let storeString = "\(store?.objectIdValue?.stringValue ?? "")"
        UserDefaults.standard.setValue(userId.stringValue, forKey: Defaults.userId)
        UserDefaults.standard.setValue(userRole.stringValue, forKey: Defaults.userRole)
        UserDefaults.standard.setValue(partition.stringValue, forKey: Defaults.partition)
        UserDefaults.standard.setValue(userAuthToken.stringValue, forKey: Defaults.accessToken)
        UserDefaults.standard.setValue(userRefreshToken.stringValue, forKey: Defaults.refreshToken)
        UserDefaults.standard.setValue(storeString, forKey: Defaults.stores)
    }
    
    /// Reset data stored in Userdefaults
    func clearUserDefaultsData() {
        print("clearUserDefaultsData")
        UserDefaults.standard.removeObject(forKey: Defaults.userId)
        UserDefaults.standard.removeObject(forKey: Defaults.userRole)
        UserDefaults.standard.removeObject(forKey: Defaults.partition)
        UserDefaults.standard.removeObject(forKey: Defaults.accessToken)
        UserDefaults.standard.removeObject(forKey: Defaults.refreshToken)
        UserDefaults.standard.removeObject(forKey: Defaults.stores)
    }
    
    //MARK: - Logout
    
    /// Logout user from realm and clear data from userdefaults and send  user to login screen
    func logoutAndClearRealmData() {
        app.currentUser?.logOut(completion: { error in
            if error == nil {
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                    print("realm.deleteAll")
                    self.clearUserDefaultsData()
                    DispatchQueue.main.async {
                        Router.setRootViewController()
                    }
                }
            }
        })
        
    }

    // MARK: - Sync
    
    /// Sync data from master realm
    /// - Parameter onTaskSuccess: on success block, save master realm to singleton
    func syncMasterRealm(success onTaskSuccess:@escaping OnTaskSuccess) {
        let user = app.currentUser
        let partition = UserDefaults.standard.value(forKey: Defaults.partition) as? String ?? ""
        let partitionValue = partition
        let configuration = user!.configuration(partitionValue: partitionValue)
        // Open a Realm asynchronously with this configuration. This
        // downloads any changes to the synced Realm from the server
        // before opening it. If this is the first time opening this
        // synced Realm, it downloads the entire Realm to disk before
        // opening it.
        Realm.asyncOpen(configuration: configuration) { result in
            switch result {
            case .failure(let error):
                print("Failed to open realm: \(error.localizedDescription)")
                // handle error
                onTaskSuccess(false)
            case .success(let realm):
                print("Successfully opened realm: \(realm)")
                // Use realm
                RealmManager.shared.masterRealm = realm
                onTaskSuccess(true)
            }
        }
    }
    
    /// Sync data from store realm partition.
    /// - Parameter onTaskSuccess: on success block, save store realm to singleton
    func syncStoreRealm(success onTaskSuccess:@escaping OnTaskSuccess) {
        let user = app.currentUser
        let partition = UserDefaults.standard.value(forKey: Defaults.stores) as? String ?? ""
        let partitionValue = "store=\(partition)"
        let configuration = user!.configuration(partitionValue: partitionValue)
        // Open a Realm asynchronously with this configuration. This
        // downloads any changes to the synced Realm from the server
        // before opening it. If this is the first time opening this
        // synced Realm, it downloads the entire Realm to disk before
        // opening it.
        Realm.asyncOpen(configuration: configuration) { result in
            switch result {
            case .failure(let error):
                print("Failed to open store realm: \(error.localizedDescription)")
                // handle error
                onTaskSuccess(false)
            case .success(let realm):
                print("Successfully opened store realm: \(realm)")
                // Use realm
                RealmManager.shared.storeRealm = realm
                onTaskSuccess(true)
            }
        }
    }
    
    func openOfflineRealm(success onTaskSuccess:@escaping OnTaskSuccess) {
        let user = app.currentUser
        let partition = UserDefaults.standard.value(forKey: Defaults.partition) as? String ?? ""
        let partitionValue = partition
        let configuration = user!.configuration(partitionValue: partitionValue)
        if app.currentUser != nil {
            // If you have logged-in user credentials, open the realm.
            masterRealm = try! Realm(configuration: configuration)
            openOfflineRealmStore { completed in
                onTaskSuccess(true)
            }
        } else {
            // If the user is not logged in, proceed to the login flow.
            print("Current user is not logged in.")
            onTaskSuccess(false)
        }
    }
    func openOfflineRealmStore(success onTaskSuccess:@escaping OnTaskSuccess) {
        let user = app.currentUser
        let partition = UserDefaults.standard.value(forKey: Defaults.stores) as? String ?? ""
        let partitionValue = "store=\(partition)"
        let configuration = user!.configuration(partitionValue: partitionValue)
        if app.currentUser != nil {
            // If you have logged-in user credentials, open the realm.
            storeRealm = try! Realm(configuration: configuration)
        } else {
            // If the user is not logged in, proceed to the login flow.
            print("Current user is not logged in.")
        }
    }
    
    // MARK: - Store Inventory
    
    /// Get all products
    /// - Returns: products array
    func getAllInventories() -> Results<StoreInventory>? {
        let results = storeRealm?.objects(StoreInventory.self).sorted(byKeyPath: "productName", ascending: true)
        return results
    }
    
    /// Get all low stock products
    /// - Returns: inventories array
    func getLowStockInventories() -> Results<StoreInventory>? {
        let results = storeRealm?.objects(StoreInventory.self).filter("quantity < %@", 5).sorted(byKeyPath: "productName", ascending: true)
        return results
    }

    /// Get products with names starting  with key.
    /// - Returns: products array
    func getInventoryForSearchKey(key: String) -> [StoreInventory]? {
        let results = storeRealm?.objects(StoreInventory.self).filter{$0.productName.localizedCaseInsensitiveContains(key)}.sorted{$0.productName < $1.productName}
        if results?.count ?? 0 > 0 {
            return Array(results!)
        }
        return nil
    }
    
    // MARK: - Product
    
    func getProduct(withId productId: ObjectId) -> Products? {
        let results = masterRealm?.objects(Products.self).filter{$0._id == productId}
        if results?.count ?? 0 > 0 {
            return results!.first
        }
        return nil
    }
        
    // MARK: - Store
    
    /// Get all stores
    /// - Returns: stores array or nil
    func getAllStores() -> [Stores]? {
        let storeId = UserDefaults.standard.value(forKey: Defaults.stores)
        let storeObjId = try! RealmSwift.ObjectId(string: storeId as! String)
        let results = masterRealm?.objects(Stores.self).filter{$0._id != storeObjId}
        if results?.count ?? 0 > 0 {
            return Array(results!)
        }
        return nil
    }

    /// Get stores with names starting  with key.
    /// - Returns: stores array or nil
    func getStoreForSearchKey(key: String) -> [Stores]? {
        let storeId = UserDefaults.standard.value(forKey: Defaults.stores)
        let storeObjId = try! RealmSwift.ObjectId(string: storeId as! String)
        let results = masterRealm?.objects(Stores.self).filter{$0._id != storeObjId && $0.name.localizedCaseInsensitiveContains(key)}.sorted{$0.name < $1.name}
        if results?.count ?? 0 > 0 {
            return Array(results!)
        }
        return nil
    }
    
    /// Get store for given storeId
    /// - Parameter storeId: _id of the store
    /// - Returns: Store object or nil
    func getStore(withId storeId: ObjectId) -> Stores? {
        let results = masterRealm?.objects(Stores.self).filter{$0._id == storeId}
        if results?.count ?? 0 > 0 {
            return results!.first
        }
        return nil
    }
    
    func getMyStore() -> Stores? {
        let storeId = UserDefaults.standard.value(forKey: Defaults.stores)
        let storeObj = try! RealmSwift.ObjectId(string: storeId as! String)
        guard let store = getStore(withId: storeObj) else { return nil }
        return store
    }
    
    // MARK: - User
    
    /// Get all users with role delivery-user
    /// - Returns: users array or nil
    func getAllDeliveryUsers() -> [Users]? {
        let results = masterRealm?.objects(Users.self).filter{ $0.userRole == UserRole.deliveryUser.rawValue }
        if results?.count ?? 0 > 0 {
            return Array(results!)
        }
        return nil
    }

    /// Get delivery users with names starting  with key.
    /// - Returns: users array or nil
    func getDeliveryUserForSearchKey(key: String) -> [Users]? {
        let results = masterRealm?.objects(Users.self).filter{$0.firstName?.starts(with: key) ?? false || $0.lastName?.starts(with: key) ?? false}
        if results?.count ?? 0 > 0 {
            return Array(results!)
        }
        return nil
    }
    
    /// Get user for given user id
    /// - Parameter userId: _id of user
    /// - Returns: User object
    func getUser(withId userId: ObjectId) -> Users? {
        let results = masterRealm?.objects(Users.self).filter{$0._id == userId}
        if results?.count ?? 0 > 0 {
            return results!.first
        }
        return nil
    }

    func getMyUserInfo() -> Users? {
        let userId = UserDefaults.standard.value(forKey: Defaults.userId)
        let userIdObj = try! RealmSwift.ObjectId(string: userId as! String)
        guard let user = getUser(withId: userIdObj) else { return nil }
        return user
    }
    
    // MARK: - Jobs
    
    /// Get jobs I created as a  store admin
    /// - Returns: jobs array
    func getStoreAdminJobs() -> (Results<Jobs>?, Results<Jobs>?) {
        let userId = UserDefaults.standard.value(forKey: Defaults.userId) as? String ?? ""
        let userIdObj = try! RealmSwift.ObjectId(string: userId)
        let user = self.getUser(withId: userIdObj)
        let currentJobResults = masterRealm?.objects(Jobs.self).filter("createdBy = %@ AND status != %@", user!, "done").sorted(byKeyPath: "pickupDatetime", ascending: true)
        let doneJobResults = masterRealm?.objects(Jobs.self).filter("createdBy = %@ AND status = %@", user!, "done").sorted(byKeyPath: "pickupDatetime", ascending: true)
        return (currentJobResults, doneJobResults)
    }
    
    /// Get jobs I got assigned as a delivery user
    /// - Returns: jobs array
    func getDeliveryJobs() -> (Results<Jobs>?, Results<Jobs>?) {
        let userId = UserDefaults.standard.value(forKey: Defaults.userId) as? String ?? ""
        let userIdObj = try! RealmSwift.ObjectId(string: userId)
        let user = self.getUser(withId: userIdObj)
        let currentJobResults = masterRealm?.objects(Jobs.self).filter("assignedTo = %@ AND status != %@", user!, "done").sorted(byKeyPath: "pickupDatetime", ascending: true)
        let doneJobResults = masterRealm?.objects(Jobs.self).filter("assignedTo = %@ AND status = %@", user!, "done").sorted(byKeyPath: "pickupDatetime", ascending: true)
        return (currentJobResults, doneJobResults)
    }
    
    func getJob(withId jobId: ObjectId) -> Jobs? {
        let results = masterRealm?.objects(Jobs.self).filter{$0._id == jobId}
        print("getJob: \(results?.count ?? 0)")
        if results?.count ?? 0 > 0 {
            return results!.first
        }
        return nil
    }

    func createJob(job: Jobs, success onTaskSuccess:@escaping OnTaskSuccess) {
        try! masterRealm?.write {
            // Add the instance to the realm.
            masterRealm?.add(job)
            onTaskSuccess(true)
            return
        }
        onTaskSuccess(false)
    }
    
    func updateJobStatus(status: String, forJob job: Jobs, success onTaskSuccess:@escaping OnTaskSuccess) {
        let job = masterRealm?.objects(Jobs.self).filter{$0._id == job._id}.first!
        // Open a thread-safe transaction
        try! masterRealm?.write {
            job?.status = status
            onTaskSuccess(true)
            return
        }
        onTaskSuccess(false)
    }
    
    func updateAssignee(user: Users, forJob job: Jobs, success onTaskSuccess:@escaping OnTaskSuccess) {
        let job = masterRealm?.objects(Jobs.self).filter{$0._id == job._id}.first!
        // Open a thread-safe transaction
        try! masterRealm?.write {
            job?.assignedTo = user
            onTaskSuccess(true)
            return
        }
        onTaskSuccess(false)
    }

    // MARK: - Product Quantity

    func getProductQuantity(withId _id: ObjectId) -> ProductQuantity? {
        let results = masterRealm?.objects(ProductQuantity.self).filter{$0._id == _id}
        if results?.count ?? 0 > 0 {
            return results!.first
        }
        return nil
    }

    func getInventoryQuantity(withId _id: ObjectId) -> StoreInventory? {
        let results = storeRealm?.objects(StoreInventory.self).filter{$0.productId == _id}
        if results?.count ?? 0 > 0 {
            return results!.first
        }
        return nil
    }

 }
