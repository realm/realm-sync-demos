//
//  HomePage+TableExtension.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 09/05/22.
//

import Foundation
import UIKit
import RealmSwift


extension HomePageViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive == true ? self.filteredListDataHome?.count ?? 0 > 0 ? self.filteredListDataHome?.count ?? 0 : 0 : self.listDataHome?.count ?? 0 > 0 ? self.listDataHome?.count ?? 0 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.HomePage.listOfHospitalCells) as? ListOfHospitalTableViewCell else {return UITableViewCell()}
        
        //Instance creation
        let listDetails = searchActive == true ? self.filteredListDataHome?[indexPath.row] : self.listDataHome?[indexPath.row]
        
        cell.setUpCellDetails(listDetails: listDetails)
        cell.sampleButtonTap.tag = indexPath.row
        
        cell.buttonActionClosure = { [weak self] indexReceived in
            guard let self = self else {return}
            let listDetails = self.searchActive == true ? self.filteredListDataHome?[indexReceived] : self.listDataHome?[indexReceived]
            
            //move to consultation controller
            pushNavControllerToConsultation(StroryBoardName: Storyboard.storyBoardName.homeBoard, VcID: Storyboard.storyBoardControllerID.consultanrSessionID, ViewControllerName: self, valueToPass: listDetails ?? PractitionerRole())
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
}
