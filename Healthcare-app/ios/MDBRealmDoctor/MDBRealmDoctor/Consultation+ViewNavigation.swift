//
//  Consultation+ViewNavigation.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import Foundation
import UIKit

extension ConsulatationSelectionViewController : UISearchBarDelegate {
    ///Function to set the nav bar
    func setTheNavBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = self.selectedHospital?.organization?.name
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Poppins-SemiBold", size: 17) ?? ""
        ]
        
        //Search bar initialising
        searchController.searchBar.placeholder = UIConstants.consultation_session.searchPlaceHolder
        searchController.searchBar.searchTextField.backgroundColor = UIColor.textfieldClrSet(alpha: 0.5)
        searchController.searchBar.searchTextField.textColor = UIColor.textClrSearch()
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .black
        searchController.searchBar.searchTextField.font = UIFont(name: UIConstants.HomePage.fontFamily , size: 12)
        self.navigationItem.searchController = searchController
        
        //Left bar button item configuration
        let backUIBarButtonItemLeft = UIBarButtonItem(image: UIImage(named: UIConstants.signUpView.leftArrowImage), style: .plain, target: self, action: #selector(self.clickButton))
        self.navigationItem.leftBarButtonItem  = backUIBarButtonItemLeft
    }
    
    /// Fuction to pop the controller
    @objc func clickButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Function for register cells
    func registerCells(cellIdentifier : String) -> UINib {
        let nibCell = UINib(nibName: cellIdentifier, bundle: nil)
        return nibCell
    }
}

//search delegates
extension ConsulatationSelectionViewController {
    
    internal func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    internal func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.consultationTableView.isHidden = false
        self.consultationTableView.reloadData()
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredconsultationList = self.consultationList.filter({ (list) -> Bool in
            return list.subject?.name?.text?.lowercased().contains(searchText.lowercased()) ?? false
        })
        self.filteredconsultationList =  searchText.isEmpty ? self.consultationList : self.filteredconsultationList

        if(self.filteredconsultationList.count == 0) {
            searchActive = false
            self.consultationTableView.isHidden = true
        } else {
            searchActive = true
            self.consultationTableView.isHidden = false
        }
        print(self.filteredconsultationList.count)
        self.consultationTableView.reloadData()
    }
}
