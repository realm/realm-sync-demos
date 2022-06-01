//
//  Realm_Manager.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 26/04/22.
//

import Foundation
import RealmSwift
import UIKit

@objc final class RealmManager: NSObject {
    //Make as shared realmanager
    @objc static let shared = RealmManager()
    
    //Realm app ID
    let app = App(id: RealmConstants.iOS_realmID.realmAppID)
    
    //master relam from atlas
    var masterRealm: Realm?
    
    //SharedVariable
    var nurseList : Results<PractitionerRole>?
    
    //Selected Filter
    var selectedFilter : Int?
    
    override private init() { }
    
    //MARK: - Login
    /// Login to the realm app with email and password
    func appLogin(email: String, pwd: String, onSuccess success: @escaping OnSuccess, onFailure failure: @escaping OnFailure) {
        
        let params: Document = [realmManagerKey.emailTXT: AnyBSON(stringLiteral: email),
                                realmManagerKey.passwordTXT: AnyBSON(stringLiteral: pwd)]
        
        app.login(credentials: Credentials.function(payload: params)) { (result) in
            switch result {
            case .failure(let error):
                failure(error.localizedDescription)
            case .success(let user):
                let userCustomData = user.customData
                success(userCustomData)
            }
        }
    }
    
    
    // MARK: - Signup / Create user
    
    /// registration - create user  with first & last name, role,  email and password
    func userCreation(firstName: String, lastName: String, userRole: enumDeclarations.userTypes, email: String, pwd: String,gender : enumDeclarations.genderSelection,dateOfBirth : String, onSuccess success: @escaping OnSuccess, onFailure failure: @escaping OnFailure) {
        
        let params: Document = [
            realmManagerKey.emailTXT: AnyBSON(stringLiteral: email),
            realmManagerKey.passwordTXT: AnyBSON(stringLiteral: pwd),
            realmManagerKey.userTypeTXT: AnyBSON(stringLiteral: userRole.rawValue),
            realmManagerKey.userDataTXT  : [
                realmManagerKey.firstNameTXT : AnyBSON(stringLiteral: firstName),
                realmManagerKey.lastNameTXT: AnyBSON(stringLiteral: lastName),
                realmManagerKey.genderTXT: AnyBSON(stringLiteral: gender.rawValue), realmManagerKey.birthDateTXT: AnyBSON(stringLiteral: dateOfBirth)
            ]]
        
        app.login(credentials: Credentials.function(payload: params)) { (result) in
            switch result {
            case .failure(let error):
                failure(error.localizedDescription)
            case .success(let user):
                let userCustomData = user.customData
                // Refresh the custom user data
                success(userCustomData)
            }
        }
    }
    
    //MARK: - Write the subscription data
    func setSubscription(finished : @escaping () -> Void,errorF: @escaping () -> Void) {
        guard let subscriptions = self.masterRealm?.subscriptions else {
            return errorF()
        }
        
        //get the UUID
        let uuid = UserDefaults.standard.value(forKey: userDefaultsConstants.userD.uuid) as? String ?? ""
        
        subscriptions.write({ [weak self] in
            guard let self = self else {return}
            
            //Organisation
            if let currentSubscription = subscriptions .first(named: realmManagerKey.organizationTXt) {
                currentSubscription.update(toType: Organization.self) { listData in
                    listData.active == true
                }
            } else {
                subscriptions .append(QuerySubscription<Organization>(name: realmManagerKey.organizationTXt) { listData in
                    listData.active == true
                })
            }
            
            //Patient
            if let currentSubscription = subscriptions .first(named: realmManagerKey.patientModelTXt) {
                currentSubscription.update(toType: Patient.self) { listData in
                    listData.active == true
                }
            } else {
                subscriptions.append(QuerySubscription<Patient>(name: realmManagerKey.patientModelTXt) { listData in
                    listData.active == true
                })
            }
            
            //Practioner
            if let currentSubscription = subscriptions.first(named: realmManagerKey.practionerTXt) {
                currentSubscription.update(toType: Practitioner.self) { listData in
                    listData.active == true
                }
            } else {
                subscriptions.append(QuerySubscription<Practitioner>(name: realmManagerKey.practionerTXt) { listData in
                    listData.active == true
                })
            }
            
            //Practioner role
            if let currentSubscription = subscriptions.first(named: realmManagerKey.practionerRoleTxt) {
                currentSubscription.update(toType: PractitionerRole.self) { listData in
                    listData.active == true
                }
            } else {
                subscriptions.append(QuerySubscription<PractitionerRole>(name: realmManagerKey.practionerRoleTxt) { listData in
                    listData.active == true
                })
            }
            
            //code
            if let currentSubscription = subscriptions.first(named: realmManagerKey.codeTXT) {
                currentSubscription.update(toType: Code.self) { listData in
                    listData.active == true
                }
            } else {
                subscriptions.append(QuerySubscription<Code>(name: realmManagerKey.codeTXT) { listData in
                    listData.active == true
                })
            }
            
            //Encounter
            if let currentSubscription = subscriptions.first(named: realmManagerKey.encounrTXT) {
                currentSubscription.update(toType: Encounter.self) { listData in
                    self.findUserType() == enumDeclarations.userTypes.doctor.rawValue ? listData.practitionerIdentifier == uuid : listData.nurseIdentifier == uuid
                }
            } else {
                subscriptions.append(QuerySubscription<Encounter>(name: realmManagerKey.encounrTXT) { listData in
                    self.findUserType() == enumDeclarations.userTypes.doctor.rawValue ? listData.practitionerIdentifier == uuid : listData.nurseIdentifier == uuid
                })
            }
            
            //Procedure
            if let currentSubscription = subscriptions.first(named: realmManagerKey.procedureTXT) {
                currentSubscription.update(toType: Procedure.self) { listData in
                    self.findUserType() == enumDeclarations.userTypes.doctor.rawValue ? listData.practitionerIdentifier == uuid : listData.nurseIdentifier == uuid
                }
            } else {
                subscriptions.append(QuerySubscription<Procedure>(name: realmManagerKey.procedureTXT) { listData in
                    self.findUserType() == enumDeclarations.userTypes.doctor.rawValue ? listData.practitionerIdentifier == uuid : listData.nurseIdentifier == uuid
                })
            }
            
            //Appoinment
            if let currentSubscription = subscriptions.first(named: realmManagerKey.appoinmentModel) {
                currentSubscription.update(toType: Appointment.self) { listData in
                    self.findUserType() == enumDeclarations.userTypes.doctor.rawValue ? listData.practitionerIdentifier == uuid : listData.nurseIdentifier == uuid
                }
            } else {
                subscriptions.append(QuerySubscription<Appointment>(name: realmManagerKey.appoinmentModel) { listData in
                    self.findUserType() == enumDeclarations.userTypes.doctor.rawValue ? listData.practitionerIdentifier == uuid : listData.nurseIdentifier == uuid
                })
            }
            
            //Users
            if let currentSubscription = subscriptions.first(named: realmManagerKey.userTXT) {
                currentSubscription.update(toType: Users.self) { listData in
                    listData._id != ObjectId("000000000000000000000000")
                }
            } else {
                subscriptions.append(QuerySubscription<Users>(name: realmManagerKey.userTXT) { listData in
                    listData._id != ObjectId("000000000000000000000000")
                })
            }
            
            //condition
            if let currentSubscription = subscriptions.first(named: realmManagerKey.conditionTXT) {
                currentSubscription.update(toType: Condition.self) { listData in
                    listData.active == true
                }
            } else {
                subscriptions.append(QuerySubscription<Condition>(name: realmManagerKey.conditionTXT) { listData in
                    listData.active == true
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
    
    ///Function to get the speciality list
    func getSpecialityList(searchType : String) -> Results<Code>? {
        
        let masterCodes = masterRealm?.objects(Code.self)
        let filterCategoryCodes = masterCodes?.where {
            $0.category == searchType
        }
        return filterCategoryCodes
    }
    
    ///Function to get all the list of medication prescribed
    func getListOfMedicationPrescribed() -> String {
        
        let collectedArray = self.getSpecialityList(searchType: realmManagerKey.medicineCodeType)
        var tempString : String = ""
        for i in 0..<(collectedArray?.count ?? 0) {
            if collectedArray?[i].name?.isEmpty != true {
                tempString += i > 0 ? ", \(collectedArray?[i].name ?? "")" : "\(collectedArray?[i].name ?? "")"
            }
        }
        return tempString
    }
    
    //Return selected medical codes
    ///Function for get the hospital list
    func getTheOrganisationList() -> Results<Organization>? {
        
        let masterCodes = masterRealm?.objects(Organization.self)
        let filteredList = masterCodes?.where({ listData in
            listData._id != ObjectId("000000000000000000000000")
        })
        return filteredList
    }
    
    //Hospital list in home screen
    func getTheHospitalListInHomePage(practReferenceID : String) -> Results<PractitionerRole>? {
        
        do {
            let objIDRet = try ObjectId(string: "\(practReferenceID)")
            let tempData =   self.masterRealm?.objects(PractitionerRole.self).filter("practitioner._id == %@",objIDRet)
            return tempData
        } catch {
            print(error)
        }
        return nil
    }
    
    ///get the organisation and then get the practioner details
    func getOrganisationPractionerDetails(practReferenceID : String, hospitalID : String) -> Results<PractitionerRole>? {
        
        do {
            let hospitalID = try ObjectId(string: "\(hospitalID)")
            let objIDRet = try ObjectId(string: "\(practReferenceID)")
            let getTheListofHospital =   self.masterRealm?.objects(PractitionerRole.self).filter("organization._id == %@",hospitalID)
            let tempData = getTheListofHospital?.filter("practitioner._id == %@",objIDRet)
            return tempData
        } catch {
            print(error)
        }
        return nil
    }
    
    
    //get the consultation list
    func getTheConsultationList(selectedOrgID : ObjectId) -> [Encounter] {
        
        let masterCodes = masterRealm?.objects(Encounter.self)
        var filterByOrganization = [Encounter]()
        let listData = masterCodes?.filter("serviceProvider.identifier == %@", selectedOrgID).sorted(byKeyPath: "subject.name.text", ascending: false)
        do {
            let userDetails = try ObjectId(string: "\( UserDefaults.standard.value(forKey: userDefaultsConstants.userD.referenceId) as? String ?? "")")
            for i in 0..<(listData?.count ?? 0) {
                for j in 0..<(listData?[i].participant.count ?? 0) {
                    if listData?[i].participant[j].individual?.identifier == userDetails {
                        filterByOrganization.append((listData?[i])!)
                    }
                }
            }
            return filterByOrganization
        }catch {
            print(error)
        }
        return [Encounter]()
    }
    
    func getTheConsultationWithFilter(selectedOrgID : ObjectId, filterObj : Int) -> [Encounter] {
        
        var tempData = [Encounter]()
        let masterCodes = masterRealm?.objects(Encounter.self)
        
        let listData = self.getTheConsultationList(selectedOrgID: selectedOrgID)
        
        //Filtered 0 - yesterday 1- today 2- tomorrow
        var dateToPass : String? = ""
        if filterObj == 1 {
            //today
            dateToPass = Date().getTodaysDate(format: "YYYY-MM-dd")
        }else if filterObj == 2 {
            //tomorrow date
            dateToPass = Date().tomorrowString()
        }else if filterObj == 0 {
            //yesterday
            dateToPass = Date().yesterdayDate()
        }
        
        //convert string to date
        let dateString = dateToPass
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        
        //  if dateToPass != nil {
        
        //  let setData = listData?.filter("appoinment.start BETWEEN {%@, %@}",start,end)
        //   let tempData = listData.filter("appoinment.start == %@",)
        
        
        //  return tempData
        
        return [Encounter]()
        //  }
    }
    
    //MARK: - Get Procedure details
    
    func getProcedureDetails(encounterID : String) -> Procedure? {
        
        let masterCodes = masterRealm?.objects(Procedure.self)
        do {
            let userDetails = try ObjectId(string: "\(encounterID)")
            
            let listData = masterCodes?.where {
                $0.encounter._id == userDetails
            }
            return listData?.first
        }catch {
        }
        return nil
    }
    
    //Mark: - get the user list
    func getTheUserList(userIDReceived : String) -> Results<Users>? {
        let masterCodes = masterRealm?.objects(Users.self)
        
        do {
            let userDetails = try ObjectId(string: "\(userIDReceived)")
            let listData = masterCodes?.where {
                $0._id == userDetails
            }
            return listData
        }catch {}
        return nil
    }
    
    //MARK: - Check which controller to move initially
    ///Function to get which view to move
    func whichViewToMove(referenceID : String) -> UIViewController {
        if let _ = self.getTheHospitalListInHomePage(practReferenceID: referenceID) {
            
            //Move to home page
            return Storyboard.homeStoryBoard.instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.homeControllerID) as? HomePageViewController ?? UIViewController()
        }else {
            //move to hospital selection screen
            return Storyboard.mainStoryBoard.instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.specialityAdditionPage1) as? SpecialityAdditionViewController ?? UIViewController()
        }
    }
    
    //MARK: - consultation illness checking
    func getConsultationIllness(referenceID : String, illness : Bool) -> String {
        
        let masterCodes = masterRealm?.objects(Condition.self)
        do {
            let userDetails = try ObjectId(string: "\(referenceID)")
            let tempData = masterCodes?.where { listData in
                listData._id == userDetails
            }
            return illness == true ? tempData?.first?.code?.coding.first?.display ?? "" : tempData?.first?.notes ?? ""
        }catch {}
        return ""
    }
    
    //MARK: - Function to find the user  type
    func findUserType() -> String {
        
        let userType : String = (UserDefaults.standard.value(forKey: userDefaultsConstants.userD.userType) as? String ?? "")
        return userType.lowercased()
    }
    
    //MARK: - Function for getting doctor notes
    func getDoctorNotes(referenceID : String, isDoctorNurseID : String, typeOfUser : String) -> String {
        
        let masterCodes = masterRealm?.objects(Procedure.self)
        var docNotes    : String = UIConstants.doctorPrescription.notAvailableTxt
        var nurseNotes  : String = UIConstants.doctorPrescription.notAvailableTxt
        do {
            let userDetails = try ObjectId(string: "\(referenceID)")
            let second_doctorID = try ObjectId(string: "\(isDoctorNurseID)")
            let tempData = masterCodes?.filter("encounter._id == %@", userDetails)
            if tempData?.count ?? 0 > 0 {
                for i in 0..<(tempData?.first?.note.count ?? 0) {
                    if tempData?.first?.note[i].author?.identifier == second_doctorID {
                        //doctor
                        docNotes = tempData?.first?.note[i].text ?? ""
                    }else {
                        //Nurse
                        nurseNotes = tempData?.first?.note[i].text ?? ""
                    }
                }
            }
        }catch {}
        return typeOfUser == "doc" ? docNotes : nurseNotes
    }
    
    //MARK: - function to find the number of nurse list
    func nurseListSelection(orgID : String) -> Results<PractitionerRole>? {
        
        do {
            let organisationID = try ObjectId(string: "\(orgID)")
            let getTheListofHospital =   self.masterRealm?.objects(PractitionerRole.self).filter("organization._id == %@",organisationID)
            let nurseList = getTheListofHospital?.where { listData in
                listData.code.text == realmManagerKey.nurseTXT
            }
            return nurseList
        } catch {}
        return nil
    }
    
    
    //MARK: - Function to cheange the code to codeable_concept
    func changeCodeToCoding(listofCode : [Code]) -> Codable_Concept {
        
        let temp2 = Codable_Concept()
        for i in 0..<listofCode.count {
            let codingObj = Coding()
            let listData = listofCode[i]
            codingObj.code = listData.code
            codingObj.display = listData.name
            codingObj.system  = listData.system
            temp2.coding.append(codingObj)
        }
        return temp2
    }
    
    //MARK: - Function to insert medication
    func updateMedicationToProcedure(medicationList: [Medication], encounterID : String, success onTaskSuccess:@escaping OnTaskSuccess) {
        
        let procedureList = self.getProcedureDetails(encounterID: encounterID)
        if medicationList.count > 0 {
            let procedureList1 = List<Medication>()
            procedureList1.append(objectsIn: medicationList)
            try! self.masterRealm?.write {
                if procedureList?.usedReference.isEmpty == true {
                    procedureList?.usedReference.append(objectsIn: procedureList1)
                }else {
                    procedureList?.usedReference = procedureList1
                }
                onTaskSuccess(true)
                return
            }
        }
    }
    
    //MARK: - Insert profile picture
    //Initiate the updation of profileinfo only the image file
    func initiateProfilePicInsert(base64 : String, success onTaskSuccess:@escaping OnTaskSuccess) {
        
        guard let listData = self.getTheHospitalListInHomePage(practReferenceID: UserDefaults.standard.value(forKey: userDefaultsConstants.userD.referenceId) as? String ?? "") else {return}
        try! self.masterRealm?.write {
            if listData.first?.practitioner?.photo.isEmpty == true {
                //realm write
                //no photo found
                let attachment = Attachment()
                attachment.data = base64
                listData.first?.practitioner?.photo.append(attachment)
            }else {
                //photo found
                listData.first?.practitioner?.photo.first?.data = base64
            }
            onTaskSuccess(true)
            return
        }
        onTaskSuccess(false)
    }
    
    //MARK: - Insert profile details
    /// insert remaing profile update details
    func updateProfileDetails(code: String, display : String, system: String,name: String,about: String, success onTaskSuccess:@escaping OnTaskSuccess) {
        
        guard let practionerDetails = self.getTheHospitalListInHomePage(practReferenceID: UserDefaults.standard.value(forKey: userDefaultsConstants.userD.referenceId) as? String ?? "") else {return}
        
        try! self.masterRealm?.write {
            practionerDetails.forEach { (list) in
                list.specialty?.coding.first?.code = code
                list.specialty?.coding.first?.display = display
                list.specialty?.coding.first?.system = system
                list.practitioner?.name?.text = name
                list.practitioner?.about = about
            }
            onTaskSuccess(true)
            return
        }
        onTaskSuccess(false)
    }
    
    //MARK: - Insert data methodology
    func getTheMedicationPrescribed(encounterID: String) -> String {
        
        let procedureList = self.getProcedureDetails(encounterID: encounterID)
        let dataReceived = procedureList?.usedReference
        var tempString : String = ""
        if dataReceived?.count ?? 0 > 0 {
            for i in 0..<(dataReceived?.first?.code?.coding.count ?? 0) {
                if i == 0 {
                    tempString += dataReceived?.first?.code?.coding.first?.display ?? ""
                }else {
                    tempString += "\n\(dataReceived?.first?.code?.coding[i].display ?? "")"
                }
            }
        }else {
            return ""
        }
        return tempString
    }
    
    //MARK: - Function to add user to selected organisation
    func insertOrUpdatePractRole(practionerRole : PractitionerRole, id : String) {
        
        if let _ = self.app.currentUser {
            try! self.masterRealm?.write {
                masterRealm?.add(practionerRole)
            }
        }
    }
    
    //MARK: - Create practioner or nurse
    func getPractitionerById(practitinerId: String) -> Practitioner? {
        
        let objIDRet = try! ObjectId(string: "\(practitinerId)")
        let results = masterRealm?.objects(Practitioner.self).filter("_id == %@", objIDRet)
        if results?.count ?? 0 > 0 {
            return results?.first
        }
        return nil
    }
    
    //MARK: - Logout and clear realm
    func logoutAndClearRealmData(controllerInstance : UIViewController) {
        
        self.app.currentUser?.logOut(completion: { error in
            if error == nil {
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                    LoginViewModel.sharedInstance.clearUserDetails()
                    SignupViewModel.sharedInstance.clearUserDetails()
                    DispatchQueue.main.async {
                        //move to login page
                        let view : UIViewController = Storyboard.mainStoryBoard.instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.loginControllerID)
                        controllerInstance.navigationController?.pushViewController(view, animated: true)
                    }
                }
            }
        })
    }
    
    //MARK:- Doctor/nurse notes update
    func getTheProcedureList(listProcedure : Procedure, noteReceived : String, receivedObj : String, success onTaskSuccess:@escaping OnTaskSuccess) {
        
        let objIDRet = try! ObjectId(string: "\(receivedObj)")
        try! self.masterRealm?.write {
            if listProcedure.note.count == 1 || listProcedure.note.count == 0 {
                //new insert
                let procedureNoteInstance   = Procedure_Notes()
                let modelInstance           = Reference()
                modelInstance.identifier    = objIDRet
                modelInstance.reference     = self.findUserType() == realmManagerKey.typeOfUser ? realmManagerKey.practionerCode : realmManagerKey.nurseCode
                
                modelInstance.text          = noteReceived
                modelInstance.type          = realmManagerKey.relativeCode
                
                procedureNoteInstance.author = modelInstance
                procedureNoteInstance.text   = noteReceived
                listProcedure.note.append(procedureNoteInstance)
            }else {
                //has note
                let reference = self.findUserType() == realmManagerKey.typeOfUser ? realmManagerKey.practionerCode : realmManagerKey.nurseCode
                
                for i in 0..<listProcedure.note.count {
                    if listProcedure.note[i].author?.reference?.lowercased() == reference.lowercased() {
                        listProcedure.note[i].author?.text = noteReceived
                        listProcedure.note[i].text = noteReceived
                    }
                }
            }
            onTaskSuccess(true)
        }
    }
    
    //MARK:- Update selected nurse
    func showSelectedNurse(encounter_ID : String) -> String {
        
        let encounterMaster = self.masterRealm?.objects(Encounter.self)
        let encounterID = try! ObjectId(string: "\(encounter_ID)")
        //get the encounter list
        let encounterList = encounterMaster?.where({ (listData) in
            listData._id == encounterID
        })
        //encounter obtained
        let selectedNurse = encounterList?.first?.participant.where({ list in
            list.individual.reference == realmManagerKey.nurseCode
        })
        if selectedNurse?.count ?? 0 > 0 {
            //has nurse
            let results = masterRealm?.objects(Practitioner.self).filter("_id == %@", selectedNurse?.first?.individual?.identifier ?? ObjectId(""))
            return ("\(results?.first?.name?.text ?? "")")
        }else {
            //only has doctor
            return ""
        }
    }
    
    //updaet the selexted nurse
    func updateSelectedNurseByDoctor(nurseID : ObjectId,nurseIdentifier : String, encounterID : String, success onTaskSuccess:@escaping OnTaskSuccess) {
        
        try! self.masterRealm?.write {
            let encounterMaster = self.masterRealm?.objects(Encounter.self)
            let encounterIDConverted = try! ObjectId(string: "\(encounterID)")
            let encounterList = encounterMaster?.where({ (listData) in
                listData._id == encounterIDConverted
            })
            
            guard let acquiredProcedure = getProcedureDetails(encounterID: encounterID) else {return}
            acquiredProcedure.nurseIdentifier = nurseIdentifier
            
            if encounterList?.first?.participant.count ?? 0 > 1 {
                //exisiting nurse is there
                let dataSet = encounterList?.first?.participant.where({ list in
                    list.individual.reference == realmManagerKey.nurseCode
                })
                //Reference model data assign
                dataSet?.first?.individual?.identifier = nurseID
                encounterList?.first?.nurseIdentifier = nurseIdentifier
                encounterList?.first?.appointment?.nurseIdentifier = nurseIdentifier
            }else {
                // Add new nurse
                let reference = Reference()
                let encounterPartcipant = Encounter_Participant()
                let temp2 = Codable_Concept()
                
                //create a coding obj
                let codingObj       = Coding()
                codingObj.code      = realmManagerKey.nurseSmall
                codingObj.display   = realmManagerKey.nurseTXT
                codingObj.system    = realmManagerKey.addNewNurseCode
                temp2.coding.append(codingObj)
                
                //encounter codeable concept
                encounterPartcipant.type = temp2
                
                //Reference model data assign
                reference.identifier = nurseID
                reference.reference  = realmManagerKey.nurseCode
                reference.type       = realmManagerKey.relativeCode
                
                encounterPartcipant.individual = reference
                encounterList?.first?.participant.append(encounterPartcipant)
                encounterList?.first?.nurseIdentifier = nurseIdentifier
                encounterList?.first?.appointment?.nurseIdentifier = nurseIdentifier
            }
            onTaskSuccess(true)
        }
    }
    
    //MARK: - RouteHanding
    func routeHandling() -> UIViewController {
        //Logged In user
        //2.Check whether the user mappped with any organisation
        
        //Check the realm has current users
        if let _ = RealmManager.shared.app.currentUser {
            
            //verify the configuration
            var config = RealmManager.shared.app.currentUser?.flexibleSyncConfiguration()
            
            //List all the Parent and embedded model
            config?.objectTypes = RealmConstants.objects.objectListArray
            
            //Try realm, if realm has data move to home page
            RealmManager.shared.masterRealm = try! Realm(configuration: config!)
            
            if RealmManager.shared.masterRealm?.isEmpty == true {
                //Move to sync waiting screen
                return Storyboard.mainStoryBoard.instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.waitingScreenController)
            }else {
                //organisation is mapped move to home
                //Check organisation available for the user logged in
                
                let dataSet : String = (UserDefaults.standard.value(forKey: userDefaultsConstants.userD.userType) as? String ?? "").lowercased()
                
                //check the user is doctor
                if dataSet == UIConstants.signUpView.doctorLowerCase {
                    
                    if let userRefId = UserDefaults.standard.value(forKey: userDefaultsConstants.userD.referenceId) {
                        
                        let tempData =  RealmManager.shared.getTheHospitalListInHomePage(practReferenceID: userRefId as? String ?? "")
                        
                        if tempData?.count ?? 0 > 0 {
                            // move to home page
                            return Storyboard.homeStoryBoard.instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.homeControllerID)
                        }else {
                            //move to speciality and hospital selection screen
                            return Storyboard.mainStoryBoard.instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.specialityAdditionPage1)
                        }
                    }else {
                        //Reference ID not found
                        //Move to login
                        LoginViewModel.sharedInstance.clearUserDetails()
                        return Storyboard.mainStoryBoard.instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.loginControllerID)
                    }
                }else {
                    //nurse
                    if let userRefId = UserDefaults.standard.value(forKey: userDefaultsConstants.userD.referenceId) {
                        
                        let tempData =  RealmManager.shared.getTheHospitalListInHomePage(practReferenceID: userRefId as? String ?? "")
                        
                        if tempData?.count ?? 0 > 0 {
                            // move to home page
                            return Storyboard.homeStoryBoard.instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.homeControllerID)
                        }else {
                            //move to speciality and hospital selection screen
                            return Storyboard.mainStoryBoard.instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.specialityAdditionPage1)
                        }
                    }else {
                        //Reference ID not found
                        //Move to login
                        LoginViewModel.sharedInstance.clearUserDetails()
                        return Storyboard.mainStoryBoard.instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.loginControllerID)
                        
                    }
                }
            }
        }else {
            //Move to login page by clearing
            LoginViewModel.sharedInstance.clearUserDetails()
            
            //go to login page
            return Storyboard.mainStoryBoard.instantiateViewController(withIdentifier: Storyboard.storyBoardControllerID.loginControllerID)
        }
    }
    
    //MARK: - Sync Realm and initiate subscription
    /// Sync data from master realm
    /// - Parameter onTaskSuccess: on success block, save master realm to singleton
    func syncMasterRealm(onSuccess success: @escaping OnSuccess, onFailure failure: @escaping OnFailure) {
        //Check user is available
        if let user = RealmManager.shared.app.currentUser {
            //Configure for flexible sync
            var config = user.flexibleSyncConfiguration()
            
            //List all the Parent and embedded model
            config.objectTypes = RealmConstants.objects.objectListArray
            
            Realm.asyncOpen(configuration: config, callbackQueue: .main) { result in
                switch result {
                case .failure(let error):
                    print("Failed to open realm: \(error.localizedDescription)")
                    
                case .success(let realm):
                    print("Successfully opened realm: \(realm)")
                    // Use realm and load into master realm
                    self.masterRealm = realm
                    self.setSubscription {
                        //Finished
                        //Check the organisation availale for the user logic
                        success(true)
                    } errorF: {
                        failure("false")
                    }
                }
            }
        }
    }
}
