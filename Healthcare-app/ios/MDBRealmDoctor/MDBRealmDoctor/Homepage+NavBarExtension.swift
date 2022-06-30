//
//  Homepage+NavBarExtension.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 21/04/22.
//

import Foundation
import UIKit

extension HomePageViewController : UISearchBarDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    ///Function to set the nav bar
    func setTheNavBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = UIConstants.HomePage.homePageTitle
        self.setUserRoleAndNameOnNavBar()
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Poppins-SemiBold", size: 17) ?? ""
        ]
        
        //right bar button item configuration
        let backUIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: UIConstants.HomePage.menuLines ), style: .plain, target: self, action: #selector(self.openMenu))
        self.navigationItem.rightBarButtonItem  = backUIBarButtonItem
        
        //Search bar initialising
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = UIConstants.HomePage.searchPlaceholder
        searchController.searchBar.searchTextField.backgroundColor = UIColor.textfieldClrSet(alpha: 0.5)
        searchController.searchBar.searchTextField.textColor = UIColor.textClrSearch()
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .black
        searchController.searchBar.searchTextField.font = UIFont(name: UIConstants.HomePage.fontFamily , size: 12)
        self.navigationItem.searchController = searchController
    }
    
    /// Fuction to pop the controller
    @objc func openMenu(){
        //present the menu viewcontroller
        self.navigationItem.searchController?.searchBar.isHidden = true
        self.title = "Menu"
        self.sideMenuState(expanded: self.isExpanded ? false : true, typeOfView: "HOME")
    }
    
    /// Function for register cells
    func registerCells(cellIdentifier : String) -> UINib {
        let nibCell = UINib(nibName: cellIdentifier, bundle: nil)
        return nibCell
    }
}

//MARK: - extension - search bar delegates
extension HomePageViewController {
    
    internal func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    internal func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.hospitalListTableView.isHidden = false
        self.hospitalListTableView.reloadData()
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //speciality page
            self.filteredListDataHome = self.listDataHome?.filter("organization.name CONTAINS[c] %@ OR organization.type.text CONTAINS[c] %@", searchText.lowercased(),searchText.lowercased()).sorted(byKeyPath: "organization.name", ascending: true)
        
            self.filteredListDataHome =  searchText.isEmpty ? self.listDataHome : self.filteredListDataHome
            
            if(self.filteredListDataHome?.count == 0) {
                searchActive = false
                self.hospitalListTableView.isHidden = true
            } else {
                searchActive = true
                self.hospitalListTableView.isHidden = false
            }
        
        self.hospitalListTableView.reloadData()
    }
    
}
