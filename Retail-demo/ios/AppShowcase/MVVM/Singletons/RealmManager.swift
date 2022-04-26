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
    
    // MARK: - Signup / Create user
    
    /// registration - create user  with first & last name, role,  email and password
    func userCreation(firstName: String, lastName: String, userRole: UserRole?, email: String, pwd: String, onSuccess success: @escaping OnSuccess, onFailure failure: @escaping OnFailure) {
        
        let params: Document = ["firstName": AnyBSON(stringLiteral: firstName),
                                "lastName": AnyBSON(stringLiteral: lastName),
                                "userRole": AnyBSON(stringLiteral: userRole?.rawValue ?? UserRole.storeUser.rawValue),
                                "email": AnyBSON(stringLiteral: email),
                                "password": AnyBSON(stringLiteral: pwd),
                                "action": AnyBSON(stringLiteral: "register")]

        app.login(credentials: Credentials.function(payload: params)) { (result) in
            switch result {
            case .failure(let error):
                print("register failed: \(error.localizedDescription)")
                failure(error.localizedDescription)
            case .success(let user):
                print("Successfully registereed  as user \(user)")
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
    
    /// Add the stores for the store user. this is generally done right after signup/create user for store-users
    /// - Parameters:
    ///   - stores: stores associated to the store user. this is the  value to be updated in realm
    ///   - user: store user
    func updateStoresForStoreUser(stores: [Stores], success onTaskSuccess:@escaping OnTaskSuccess) {
        let userId = UserDefaults.standard.value(forKey: Defaults.userId) as? String ?? ""
        let userIdObj = try! RealmSwift.ObjectId(string: userId)
        let storeUser = masterRealm?.objects(Users.self).filter("_id == %@", userIdObj).first!
        let storesList = List<Stores>()
        storesList.append(objectsIn: stores)
        // Open a thread-safe transaction
        try! masterRealm?.write {
            storeUser?.stores = storesList
            onTaskSuccess(true)
            return
        }
        onTaskSuccess(false)
    }
    
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
        let partition = userDict[Defaults.partition] as? RealmSwift.AnyBSON ?? ""
        UserDefaults.standard.setValue(userId.stringValue, forKey: Defaults.userId)
        UserDefaults.standard.setValue(userRole.stringValue, forKey: Defaults.userRole)
        UserDefaults.standard.setValue(partition.stringValue, forKey: Defaults.partition)
    }
    
    /// Reset data stored in Userdefaults
    func clearUserDefaultsData() {
        print("clearUserDefaultsData")
        UserDefaults.standard.removeObject(forKey: Defaults.userId)
        UserDefaults.standard.removeObject(forKey: Defaults.userRole)
        UserDefaults.standard.removeObject(forKey: Defaults.partition)
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
        print("partition: \(partitionValue)")
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
        let storeId = UserDefaults.standard.value(forKey: Defaults.stores) as? String ?? ""
        let partitionValue = "store=\(storeId)"
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
        let storeId = UserDefaults.standard.value(forKey: Defaults.stores) as? String ?? ""
        if storeId != "" {
            let storeObj = try! RealmSwift.ObjectId(string: storeId )
            let results = storeRealm?.objects(StoreInventory.self).filter("storeId == %@", storeObj).sorted(byKeyPath: "productName", ascending: true)
            return results
        }
        return nil
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
    
    /// Get Inventory Info using it's  _id
    /// - Parameter inventoryId: id of the inventory
    /// - Returns: StoreInventory? object
    func getStoreInventory(withId inventoryId: ObjectId) -> StoreInventory? {
        let results = storeRealm?.objects(StoreInventory.self).filter{$0._id == inventoryId}
        if results?.count ?? 0 > 0 {
            return results!.first
        }
        return nil
    }
    
    /// Get store inventory from  product id. (could be used to show order details)
    /// - Parameter productId: product id of the inventory
    /// - Returns: inventory
    func getStoreInventory(withProductId productId: ObjectId) -> StoreInventory? {
        let results = storeRealm?.objects(StoreInventory.self).filter{$0.productId == productId}
        if results?.count ?? 0 > 0 {
            return results!.first
        }
        return nil
    }
    
    func getStoreInventory(withProductId productId: ObjectId, forJob jobId: ObjectId) -> StoreInventory? {
        let results = storeRealm?.objects(StoreInventory.self).filter{$0.productId == productId}
        if results?.count ?? 0 > 0 {
            return results!.first
        }
        return nil
    }
    
    /// To increase or decreast the stock quantity of any inventories in store-user's stores
    /// - Parameters:
    ///   - inventory: inventory realm object  for which the quantity should be updated
    ///   - quantity: the new stock quantity value to updattee
    func updateStockQuantity(forInventory inventory: StoreInventory, withStock quantity: Int, success onTaskSuccess:@escaping OnTaskSuccess) {
        // when increasing inventory quantity from store partition, decreasee the same quantity from product totalquantiity in master partition. and vice versa.
        guard let existingQuantity = inventory.quantity else { return }
        let inventoryToUpdate = storeRealm?.objects(StoreInventory.self).filter{$0._id == inventory._id}.first!
        // Open a thread-safe transaction
        try! storeRealm?.write {
            inventoryToUpdate?.quantity = quantity
            let isIncrement = !(existingQuantity < quantity)
            if let productId = inventory.productId {
                self.updateProductTotalQuantity(forProduct: productId, isIncrement: isIncrement) { status in
                    onTaskSuccess(status)
                    return
                }
            }
        }
        onTaskSuccess(false)
    }
    
    /// To increase/decrease total stock of the product in master, when user decreases/increases their inventory stock.
    /// - Parameters:
    ///   - productId: productid of the inventory
    ///   - increment: flag that says whether it is an increment or decrement to be done
    func updateProductTotalQuantity(forProduct productId: ObjectId, isIncrement increment: Bool, success onTaskSuccess:@escaping OnTaskSuccess) {
        let productToUpdate = masterRealm?.objects(Products.self).filter{$0._id == productId}.first!
        // Open a thread-safe transaction
        try! masterRealm?.write {
            if increment == true {
                productToUpdate?.totalQuantity += 1
            } else {
                productToUpdate?.totalQuantity -= 1
            }
            onTaskSuccess(true)
            return
        }
        onTaskSuccess(false)
    }

    func insertInventory(inventory: StoreInventory, toStore: ObjectId, success onTaskSuccess:@escaping OnTaskSuccess) {
        try! storeRealm?.write {
            // Add the instance to the realm.
            storeRealm?.add(inventory)
            onTaskSuccess(true)
            return
        }
        onTaskSuccess(false)
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
    func getAllStores() ->  Results<Stores>? { //RealmSwift.List<Stores>? {
        let results = masterRealm?.objects(Stores.self).sorted(byKeyPath: "name", ascending: true)
        if results?.count ?? 0 > 0 {
            return results
        }
        return nil
    }
    
    /// Get all stores by excludiing my store which is currently selected/active  in the app.
    /// - Returns: list of stores
    func getAllStoresButMyCurrentStore() ->  Results<Stores>? { //RealmSwift.List<Stores>? {
        let storeId = UserDefaults.standard.value(forKey: Defaults.stores)
        let storeObjId = try! RealmSwift.ObjectId(string: storeId as! String)
        let results = masterRealm?.objects(Stores.self).filter("_id != %@", storeObjId).sorted(byKeyPath: "name", ascending: true)
        if results?.count ?? 0 > 0 {
            return results
        }
        return nil
    }


    /// Get stores with names starting  with key.
    /// - Returns: stores array or nil
    func getStoreForSearchKey(key: String) -> Results<Stores>? { //}[Stores]? {
        let storeId = UserDefaults.standard.value(forKey: Defaults.stores)
        let storeObjId = try! RealmSwift.ObjectId(string: storeId as! String)
        let results = masterRealm?.objects(Stores.self).filter("_id != %@ AND name CONTAINS[c] %@", storeObjId, key).sorted(byKeyPath: "name", ascending: true)
        if results?.count ?? 0 > 0 {
            return results
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
    func getAllDeliveryUsers() -> Results<Users>? {
        let results = masterRealm?.objects(Users.self).filter("userRole == %@",UserRole.deliveryUser.rawValue).sorted(byKeyPath: "firstName", ascending: true)
        if results?.count ?? 0 > 0 {
            return results
        }
        return nil
    }

    /// Get delivery users with names starting  with key.
    /// - Returns: users array or nil
    func getDeliveryUserForSearchKey(key: String) -> Results<Users>?  {
        let results = masterRealm?.objects(Users.self).filter("firstName BEGINSWITH %@ OR lastName BEGINSWITH %@", key, key).sorted(byKeyPath: "firstName", ascending: true)
        if results?.count ?? 0 > 0 {
            return results
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
    
    func updatelocation(latitude lat: Double, longitude long: Double, success onTaskSuccess:@escaping OnTaskSuccess) {
        let userId = UserDefaults.standard.value(forKey: Defaults.userId)
        let userIdObj = try! RealmSwift.ObjectId(string: userId as! String)
        guard let user = getUser(withId: userIdObj) else { return }
        // Open a thread-safe transaction
        try! masterRealm?.write {
            user.location = RealmSwift.List()
            user.location.append(objectsIn: [lat, long])
            onTaskSuccess(true)
            return
        }
        onTaskSuccess(false)
    }
    
    // MARK: - Jobs
    
    /// Get jobs I created as a  store admin
    /// - Returns: jobs array
    func getStoreAdminJobs() -> Results<Jobs>? { //}(Results<Jobs>?, Results<Jobs>?) {
        let userId = UserDefaults.standard.value(forKey: Defaults.userId) as? String ?? ""
        if userId != "" {
            let userIdObj = try! RealmSwift.ObjectId(string: userId)
            let user = self.getUser(withId: userIdObj)
            let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
            let currentJobResults = masterRealm?.objects(Jobs.self).filter("createdBy = %@ AND datetime >= %@", user!, date).sorted(byKeyPath: "datetime", ascending: true)
            return currentJobResults
        }
        return nil
    }
        
    func getStoreAdminJobsWithFilters(jobType: JobType?, jobStatus: JobStatus?) -> Results<Jobs>? {
        let userId = UserDefaults.standard.value(forKey: Defaults.userId) as? String ?? ""
        if userId != "" {
            let userIdObj = try! RealmSwift.ObjectId(string: userId)
            let user = self.getUser(withId: userIdObj)
            let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
            var filters = [String]()
            if jobType != nil {
                filters.append("type == '\(jobType!.rawValue)'")
            }
            if jobStatus != nil {
                filters.append("status == '\(jobStatus!.rawValue)'")
            }
            let currentJobResults = masterRealm?.objects(Jobs.self).filter("\(filters.joined(separator: " AND ")) AND datetime >= %@ AND createdBy = %@", date, user!).sorted(byKeyPath: "datetime", ascending: true)
            return currentJobResults
        }
        return nil
    }
    
    /// Get jobs I got assigned as a delivery user
    /// - Returns: jobs array
    func getDeliveryJobs() -> Results<Jobs>? {  //(Results<Jobs>?, Results<Jobs>?) {
        let userId = UserDefaults.standard.value(forKey: Defaults.userId) as? String ?? ""
        if userId != "" {
            let userIdObj = try! RealmSwift.ObjectId(string: userId)
            let user = self.getUser(withId: userIdObj)
            let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
            let currentJobResults = masterRealm?.objects(Jobs.self).filter("assignedTo = %@ AND datetime >= %@", user!, date).sorted(byKeyPath: "datetime", ascending: true)
            return currentJobResults
        }
        return nil
    }

    /// Get jobs I got assigned as a delivery user
    /// - Returns: jobs array
    func getDeliveryJobs(withStatus status: String) -> Results<Jobs>? {  //(Results<Jobs>?, Results<Jobs>?) {
        let userId = UserDefaults.standard.value(forKey: Defaults.userId) as? String ?? ""
        if userId != "" {
            let userIdObj = try! RealmSwift.ObjectId(string: userId)
            let user = self.getUser(withId: userIdObj)
            let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
            let currentJobResults = masterRealm?.objects(Jobs.self).filter("status = %@ AND assignedTo = %@ AND datetime >= %@", status, user!, date).sorted(byKeyPath: "datetime", ascending: true)
            return currentJobResults
        }
        return nil
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
    
    func updateJobStatus(status: String, receivedBy: String?, forJob job: Jobs, success onTaskSuccess:@escaping OnTaskSuccess) {
        let job = masterRealm?.objects(Jobs.self).filter{$0._id == job._id}.first!
        // Open a thread-safe transaction
        try! masterRealm?.write {
            job?.status = status
            if receivedBy != nil {
                job?.receivedBy = receivedBy
            }
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

    // MARK: - Orders
    
    /// Get orders I created as a  store admin
    /// - Returns: orders array
    func getOrdersForStoreUser() -> Results<Orders>? {
        let userId = UserDefaults.standard.value(forKey: Defaults.userId) as? String ?? ""
        if userId != "" {
            let userIdObj = try! RealmSwift.ObjectId(string: userId)
            let user = self.getUser(withId: userIdObj)
            let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
            let ordersResults = masterRealm?.objects(Orders.self).filter("createdBy = %@ AND createdDate >= %@", user!, date).sorted(byKeyPath: "createdDate", ascending: true)
            return ordersResults
        }
        return nil
    }
    
    func getOrder(witId orderId: ObjectId) -> Orders? {
        let ordersResults = masterRealm?.objects(Orders.self).filter("_id = %@", orderId)
        if ordersResults?.count ?? 0 > 0 {
            return ordersResults?[0]
        }
        return nil
    }

    func createOrder(order: Orders, success onTaskSuccess:@escaping OnTaskSuccess) {
        try! masterRealm?.write {
            // Add the instance to the realm.
            masterRealm?.add(order)
            onTaskSuccess(true)
            return
        }
        onTaskSuccess(false)
    }
    
    func updateOrder(order: Orders, success onTaskSuccess:@escaping OnTaskSuccess) {
        let existingOrder = masterRealm?.objects(Orders.self).filter{$0._id == order._id}.first!
        // Open a thread-safe transaction
        try! masterRealm?.write {
            existingOrder?.products = order.products
            onTaskSuccess(true)
            return
        }
        onTaskSuccess(false)
    }
    
    func deleteOrder(order: Orders, success onTaskSuccess:@escaping OnTaskSuccess) {
        guard let existingOrder = masterRealm?.objects(Orders.self).filter({$0._id == order._id}).first! else { return }
        // Open a thread-safe transaction
        try! masterRealm?.write {
            masterRealm?.delete(existingOrder)
            onTaskSuccess(true)
            return
        }
        onTaskSuccess(false)
    }
 }

extension Results {
  var toList: List<Element> {
    reduce(.init()) { list, element in
      list.append(element)
      return list
    }
  }
}
