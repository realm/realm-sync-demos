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
    var defaultObjectId = ObjectId("000000000000000000000000")
    
    override private init() { }
    
    // MARK: - Signup / Create user
    
    /// registration - create user  with first & last name, role,  email and password
    func userCreation(firstName: String, lastName: String, userRole: UserRole?, email: String, pwd: String, gender: String, birthDate: String, onSuccess success: @escaping OnSuccess, onFailure failure: @escaping OnFailure) {
        
        let userData: Document = ["firstName": AnyBSON(stringLiteral: firstName),
                                  "lastName": AnyBSON(stringLiteral: lastName),
                                  "gender": AnyBSON(stringLiteral: gender),
                                  "birthDate": AnyBSON(stringLiteral: birthDate)]
        let params: Document = ["email": AnyBSON(stringLiteral: email),
                                "password": AnyBSON(stringLiteral: pwd),
                                "userType": AnyBSON(stringLiteral: "patient"),
                                "userData": AnyBSON(userData)]
        
        app.login(credentials: Credentials.function(payload: params)) { (result) in
            switch result {
            case .failure(let error):
                print("register failed: \(error.localizedDescription)")
                failure(self.errorMessage(responseJsonData: error.localizedDescription))
            case .success(let user):
                print("Successfully registereed  as user \(user)")
                // If the user data has been refreshed recently, you can access the
                // custom user data directly on the user object
                let userCustomData = user.customData
                // Refresh the custom user data
                // save few data in userdefaults for easy access.
                self.saveUserDataToUserDefaults(userDict: userCustomData as [String : Any])
                success(userCustomData)
            }
        }
    }
    
    // MARK: - Login
    
    /// Login to the realm app with email and password
    func appLogin(email: String, pwd: String, onSuccess success: @escaping OnSuccess, onFailure failure: @escaping OnFailure) {
        
        let userData: Document = [:]
        let params: Document = ["email": AnyBSON(stringLiteral: email),
                                "password": AnyBSON(stringLiteral: pwd),
                                "userType": AnyBSON(stringLiteral: UserRole.userType.rawValue),
                                "userData": AnyBSON(userData)]
        app.login(credentials: Credentials.function(payload: params)) { (result) in
            switch result {
            case .failure(let error):
                print("Login failed: \(error.localizedDescription)")
                failure(self.errorMessage(responseJsonData: error.localizedDescription))
            case .success(let user):
                print("Successfully logged in as user \(user)")
                // If the user data has been refreshed recently, you can access the
                // custom user data directly on the user object
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
    // MARK: - Error Message
    func errorMessage(responseJsonData: String) -> String {
        if let data = responseJsonData.data(using: .utf8) {
            do {
                _ = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
            } catch {
                print("Something went wrong")
            }
        }
        return ""
    }
    // MARK: - Sync
    
    /// Sync data from master realm
    /// - Parameter onTaskSuccess: on success block, save master realm to singleton
    func syncMasterRealm(success onTaskSuccess:@escaping OnTaskSuccess) {
        let user = app.currentUser
        var configuration = user!.flexibleSyncConfiguration()
        // Open a Realm asynchronously with this configuration. This
        // downloads any changes to the synced Realm from the server
        // before opening it. If this is the first time opening this
        // synced Realm, it downloads the entire Realm to disk before
        // opening it.
        configuration.objectTypes = [Organization.self, Attachment.self, Address.self, Codable_Concept.self, Coding.self, Patient.self, Human_Name.self, PractitionerRole.self, Availability.self, Practitioner.self, Code.self, Condition.self, Reference.self,Appointment_Participant.self ,Appointment.self, Encounter.self, Diagnosis.self, Encounter_Participant.self, Procedure.self, Procedure_Notes.self, Medication.self]
        
        Realm.asyncOpen(configuration: configuration, callbackQueue: .main) { result in
            switch result {
            case .failure(let error):
                print("Failed to open realm: \(error.localizedDescription)")
                onTaskSuccess(false)
            case .success(let realm):
                print("Successfully opened realm")
                RealmManager.shared.masterRealm = realm
                self.setSubscription(finished: {
                    onTaskSuccess(true)
                }, errorF: {
                    onTaskSuccess(false)
                })
                
            }
        }
    }
    private func setSubscription(finished : @escaping () -> Void,errorF: @escaping () -> Void) {
        let subscriptions = RealmManager.shared.masterRealm?.subscriptions
        subscriptions?.write({
            //Organisation
            if let currentSubscription = subscriptions?.first(named: "Organization") {
                currentSubscription.update(toType: Organization.self) { listData in
                    listData.active == true
                }
            } else {
                subscriptions?.append(QuerySubscription<Organization>(name: "Organization") { listData in
                    listData.active == true
                })
            }
            //Patient
            if let currentSubscription = subscriptions?.first(named: "Patient") {
                currentSubscription.update(toType: Patient.self) { listData in
                    listData.identifier == self.getPatientIdentifier()
                }
            } else {
                subscriptions?.append(QuerySubscription<Patient>(name: "Patient") { listData in
                    listData.identifier == self.getPatientIdentifier()
                })
            }
            //Practioner
            if let currentSubscription = subscriptions?.first(named: "Practitioner") {
                currentSubscription.update(toType: Practitioner.self) { listData in
                    listData.active == true
                }
            } else {
                subscriptions?.append(QuerySubscription<Practitioner>(name: "Practitioner") { listData in
                    listData.active == true
                })
            }
            //Practioner role
            if let currentSubscription = subscriptions?.first(named: "PractitionerRole") {
                currentSubscription.update(toType: PractitionerRole.self) { listData in
                    listData.active == true
                }
            } else {
                subscriptions?.append(QuerySubscription<PractitionerRole>(name: "PractitionerRole") { listData in
                    listData.active == true
                })
            }
            //code
            if let currentSubscription = subscriptions?.first(named: "Code") {
                currentSubscription.update(toType: Code.self) { listData in
                    listData.active == true
                }
            } else {
                subscriptions?.append(QuerySubscription<Code>(name: "Code") { listData in
                    listData.active == true
                })
            }
            //Condition
            if let currentSubscription = subscriptions?.first(named: "Condition") {
                currentSubscription.update(toType: Condition.self) { listData in
                    listData.subjectIdentifier == self.getPatientIdentifier()
                }
            } else {
                subscriptions?.append(QuerySubscription<Condition>(name: "Condition") { listData in
                    listData.subjectIdentifier == self.getPatientIdentifier()
                })
            }
            //Appointment
            if let currentSubscription = subscriptions?.first(named: "Appointment") {
                currentSubscription.update(toType: Appointment.self) { listData in
                    listData.patientIdentifier == self.getPatientIdentifier()
                }
            } else {
                subscriptions?.append(QuerySubscription<Appointment>(name: "Appointment") { listData in
                    listData.patientIdentifier == self.getPatientIdentifier()
                })
            }
            //Encounter
            if let currentSubscription = subscriptions?.first(named: "Encounter") {
                currentSubscription.update(toType: Encounter.self) { listData in
                    listData.subjectIdentifier == self.getPatientIdentifier()
                }
            } else {
                subscriptions?.append(QuerySubscription<Encounter>(name: "Encounter") { listData in
                    listData.subjectIdentifier == self.getPatientIdentifier()
                })
            }
            //Procedure
            if let currentSubscription = subscriptions?.first(named: "Procedure") {
                currentSubscription.update(toType: Procedure.self) { listData in
                    listData.patientIdentifier ==  self.getPatientIdentifier()
                }
            } else {
                subscriptions?.append(QuerySubscription<Procedure>(name: "Procedure") { listData in
                    listData.patientIdentifier ==  self.getPatientIdentifier()
                })
            }
        }, onComplete: { error in // error is optional
            if error == nil {
                // Flexible Sync has updated data to match the subscription
                finished()
            } else {
                // Handle the error
                //show alert
                errorF()
            }
        })
    }
    /// Get Patient for given user id
    /// - Returns: Patient object
    func getPatientObject() -> Patient {
        let user = RealmManager.shared.app.currentUser?.customData as? Dictionary<String, AnyObject>
        if let referenceId = user?["referenceId"] as? RealmSwift.AnyBSON {
            guard let getPatient = RealmManager.shared.masterRealm?.object(ofType: Patient.self, forPrimaryKey: referenceId.objectIdValue) else { return Patient() }
            
            return getPatient
        }
        return Patient()
    }
    /// Get Patient for given user id
    /// - Returns: Patient Id
    func getPatientId() -> ObjectId {
        let user = RealmManager.shared.app.currentUser?.customData as? Dictionary<String, AnyObject>
        if let referenceId = user?["referenceId"] as? RealmSwift.AnyBSON {
            return referenceId.objectIdValue!
        }
        return defaultObjectId
    }
    /// Get Patient for given user id
    /// - Returns: Patient Identifier
    func getPatientIdentifier() -> String {
        let user = RealmManager.shared.app.currentUser?.customData as? Dictionary<String, AnyObject>
        if let referenceIdentifier = user?["uuid"] as? RealmSwift.AnyBSON {
            return referenceIdentifier.stringValue ?? ""
        }
        return ""
    }
    // MARK: - Organization
    
    /// Get all Organization
    /// - Returns: Organization array
    func getAllOrganization() -> Results<Organization>? {
        let results = masterRealm?.objects(Organization.self)
        if results?.count ?? 0 > 0 {
            return results
        }
        return nil
    }
    /// Get all Organization
    /// - Returns: Organization array
    func getOrganizationById(organizationId: ObjectId) -> Organization? {
        let results = masterRealm?.objects(Organization.self).filter("_id == %@", organizationId)
        if results?.count ?? 0 > 0 {
            return results?.first
        }
        return nil
    }
    // MARK: - Practitioner Role
    
    /// Get all Organization
    /// - Returns: Practitioner Role array // Not used
    func getAllPractitionerRole() -> Results<PractitionerRole>? {
        let results = masterRealm?.objects(PractitionerRole.self)
        if results?.count ?? 0 > 0 {
            return results
        }
        return nil
    }
    // MARK: - Practitioner
    
    /// Get all Organization
    /// - Returns: Practitioner array
    func getAllPractitioner(hospitalId: ObjectId) -> [PractitionerRole] {
        
        let masterCodes = masterRealm?.objects(PractitionerRole.self)
        var filterByOrganization = [PractitionerRole]()
        masterCodes?.where {
            $0.organization._id == hospitalId
        }.filter{$0.code?.coding.first?.code == "doctor"}.forEach({ practitionerRole in
            filterByOrganization.append(practitionerRole)
        })
        return filterByOrganization
        
    }
    /// Get all Organization
    /// - Returns: Practitioner array // Not used
    func getObservePractitioner(hospitalId: ObjectId) -> Results<PractitionerRole>? {
        let masterCodes = masterRealm?.objects(PractitionerRole.self)
        let filterByOrganization = masterCodes?.where {
            $0.organization._id == hospitalId
        }
        return filterByOrganization
    }
    // MARK: - Practitioner
    /// Get all Organization
    /// - Returns: Practitioner array
    func getPractitionerById(practitinerId: ObjectId) -> Practitioner? {
        let results = masterRealm?.objects(Practitioner.self).filter("_id == %@", practitinerId)
        if results?.count ?? 0 > 0 {
            return results?.first
        }
        return nil
    }
    // MARK: - Practitioner
    /// Get all Organization
    /// - Returns: Practitioner array
    func getAllPractitioner() -> Results<Practitioner>? {
        let results = masterRealm?.objects(Practitioner.self)
        if results?.count ?? 0 > 0 {
            return results
        }
        return nil
        
    }
    // MARK: - Code
    
    /// Get all Code
    /// - Returns: Code array
    func getAllMasterCode(category: String) -> Results<Code>? {
        
        let masterCodes = masterRealm?.objects(Code.self)
        let filterCategoryCodes = masterCodes?.where {
            $0.category == category
        }
        return filterCategoryCodes
    }
    /// Get all Appointment
    func getAllAppointment(practitionerId: ObjectId, bookingDate: Date) -> Results<Appointment>? {
        
        var appointmentObjects = [Appointment]()
        masterRealm?.objects(Appointment.self).filter{$0.participant.last?.actor?.identifier == practitionerId}.forEach({ appointment in
            appointmentObjects.append(appointment)
        })
        _ = masterRealm?.objects(Appointment.self)
        let results = masterRealm?.objects(Appointment.self)
        if results?.count ?? 0 > 0 {
            return results
        }
        return nil
    }
    /// Get all Encounter // Not used
    func getAllEncounter() -> Results<Encounter>? {
        let results = masterRealm?.objects(Encounter.self)
        if results?.count ?? 0 > 0 {
            return results
        }
        return nil
    }
    /// Get all Procedure
    func getAllProcedure(filterByDate: String) -> Results<Procedure>? {
        if filterByDate == "Past" {
            let results = masterRealm?.objects(Procedure.self).filter("subject._id == %@ AND encounter.appointment.start < %@", self.getPatientId(), Date()).sorted(byKeyPath: "encounter.appointment.start", ascending: false)
            if results?.count ?? 0 > 0 {
                return results
            }
        } else if filterByDate == "Upcoming" {
            let results = masterRealm?.objects(Procedure.self).filter("subject._id == %@ AND encounter.appointment.start > %@", self.getPatientId(), Date()).sorted(byKeyPath: "encounter.appointment.start", ascending: true)
            if results?.count ?? 0 > 0 {
                return results
            }
        }
        return nil
    }
    /// Get all Procedure
    func getProcedureById(procedureId: ObjectId) -> Procedure? {
        let results = masterRealm?.objects(Procedure.self).filter("_id == %@", procedureId)
        if results?.count ?? 0 > 0 {
            return results?.first
        }
        return nil
    }
    // MARK: - Condition
    
    /// Get all Condition
    /// - Returns: Condition array
    func getUserCondition() -> Results<Condition>? {
        let userId = UserDefaults.standard.value(forKey: Defaults.userId) as? String ?? ""
        let userObj = try! RealmSwift.ObjectId(string: userId )
        let getConditions = masterRealm?.objects(Condition.self).filter("subject.identifier == %@",userObj)
        return getConditions
    }
    func deleteCondition(condition: Condition, success onTaskSuccess:@escaping OnTaskSuccess) {
        guard let existingOrder = masterRealm?.objects(Condition.self).filter({$0._id == condition._id}).first! else { return }
        try! masterRealm?.write {
            masterRealm?.delete(existingOrder)
            onTaskSuccess(true)
            return
        }
        onTaskSuccess(false)
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
    func logoutAndClearRealmData(finished: @escaping () -> Void) {
        app.currentUser?.logOut(completion: { error in
            if error == nil {
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                    self.clearUserDefaultsData()
                    finished()
                }
            }
        })
    }
    func createCondition(condition: Condition, success onTaskSuccess:@escaping OnTaskSuccess) {
        try! masterRealm?.write {
            masterRealm?.add(condition)
            onTaskSuccess(true)
            return
        }
        onTaskSuccess(false)
    }
    func createBooking(appointment: Appointment, encounter: Encounter, procedure: Procedure, success onTaskSuccess:@escaping OnTaskSuccess) {
        try! masterRealm?.write {
            masterRealm?.add(appointment)
            masterRealm?.add(encounter)
            masterRealm?.add(procedure)
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
extension String {
    func toHexEncodedString(uppercase: Bool = true, prefix: String = "", separator: String = "") -> String {
        return unicodeScalars.map { prefix + .init($0.value, radix: 16, uppercase: uppercase) } .joined(separator: separator)
    }
}
