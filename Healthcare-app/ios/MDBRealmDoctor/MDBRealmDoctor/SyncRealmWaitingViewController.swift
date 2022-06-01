//
//  SyncRealmWaitingViewController.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 06/05/22.
//

import UIKit
import RealmSwift

class SyncRealmWaitingViewController: BaseType2ViewController {
    
    @IBOutlet weak var syncWaitingTextLabel : UILabel! {
        didSet {
            self.syncWaitingTextLabel.text = "Sync is in progress,\nPlease wait..."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.syncMasterRealm()
    }
    
    ///Function to sync the realm
    func syncMasterRealm() {
       // self.showLoader()
        if let user = RealmManager.shared.app.currentUser {
            var config = user.flexibleSyncConfiguration()
        
            
            //List all the Parent and embedded model
            config.objectTypes = RealmConstants.objects.objectListArray
            print(Date.now)
            Realm.asyncOpen(configuration: config, callbackQueue: .main) { result in
                switch result {
                case .failure(let error):
                    print("Failed to open realm: \(error.localizedDescription)")
                    
                case .success(let realm):
                    print(Date.now)
                    print("Successfully opened realm: \(realm)")
                    // Use realm
                    RealmManager.shared.masterRealm = realm
                    RealmManager.shared.setSubscription { [weak self] in
                        guard let self = self else {return}
                        //Finished
                        //Check the organisation availale for the user logic
                        DispatchQueue.main.async {
                            //Check organisation available for the user logged in
                            
                            let dataSet : String = (UserDefaults.standard.value(forKey: userDefaultsConstants.userD.userType) as? String ?? "").lowercased()
                            
                            //check the user is doctor
                            if dataSet == UIConstants.signUpView.doctorLowerCase {
                                
                                if let userRefId = UserDefaults.standard.value(forKey: userDefaultsConstants.userD.referenceId) {
                                    
                                    let tempData =  RealmManager.shared.getTheHospitalListInHomePage(practReferenceID: userRefId as? String ?? "")
                                    
                                    if tempData?.count ?? 0 > 0 {
                                        // move to home page
                                        pushNavControllerStyle(storyBoardName: Storyboard.storyBoardName.homeBoard, vcId: Storyboard.storyBoardControllerID.homeControllerID, viewControllerName: self)
                                    }else {
                                        //move to speciality and hospital selection screen
                                        pushNavControllerStyle(storyBoardName: Storyboard.storyBoardName.mainBoard, vcId: Storyboard.storyBoardControllerID.specialityAdditionPage1, viewControllerName: self)
                                    }
                                }else {
                                    //Reference ID not found
                                    self.hideLoader()
                                    LoginViewModel.sharedInstance.clearUserDetails()
                                    self.showMessageWithOkActionType2(message: failedSec.syncFailed,title: failedSec.titleLogin, viewToShow: self, storyBoardName: Storyboard.storyBoardName.mainBoard, vcIdentifier: Storyboard.storyBoardControllerID.loginControllerID)
                                }
                            }
                        }
                    } errorF: { [weak self] in
                        guard let self = self else {return}
                        DispatchQueue.main.async {
                            self.hideLoader()
                            //sync failed -- show error message
                            
                            LoginViewModel.sharedInstance.clearUserDetails()
                            //Move to login page
                            self.showMessageWithOkActionType2(message: failedSec.syncFailed,title: failedSec.titleLogin, viewToShow: self, storyBoardName: Storyboard.storyBoardName.mainBoard, vcIdentifier: Storyboard.storyBoardControllerID.loginControllerID)
                        }
                    }
                }
            }
        }
    }
}
