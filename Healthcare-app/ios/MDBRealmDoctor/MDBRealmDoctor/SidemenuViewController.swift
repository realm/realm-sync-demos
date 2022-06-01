//
//  SidemenuViewController.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 25/04/22.
//

import UIKit

//Protocol declaration for sidemenu
protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SidemenuViewController: UIViewController {
    
    //Outlet
    @IBOutlet weak var sideMenuTableView : UITableView! {
        didSet {
            self.sideMenuTableView.delegate = self
            self.sideMenuTableView.dataSource = self
        }
    }
    
    //Variable declaration
    var delegate: SideMenuViewControllerDelegate?
    var defaultHighlightedCell: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = UIConstants.sideMenu.menuTitle
        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }
        
        sideMenuTableView.register(registerCells(cellIdentifier: UIConstants.sideMenu.cellIdentifierId), forCellReuseIdentifier: UIConstants.sideMenu.cellIdentifierId)
        
        // Update TableView with the data
        self.sideMenuTableView.reloadData()
    }
    
    /// Function for register cells
    func registerCells(cellIdentifier : String) -> UINib {
        let nibCell = UINib(nibName: cellIdentifier, bundle: nil)
        return nibCell
    }

}

//MARK:- Tableview extension
extension SidemenuViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UIConstants.sideMenu.menu.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.sideMenu.cellIdentifierId, for: indexPath) as? SidemenuTableViewCell else { fatalError("xib doesn't exist") }
        
        cell.menuImageView.image = UIConstants.sideMenu.menu[indexPath.row].icon
        cell.menuName.text = UIConstants.sideMenu.menu[indexPath.row].title

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedCell(indexPath.row)
        
        // Remove highlighted color when you press the 'Profile' and 'Like us on facebook' cell
        if indexPath.row == 4 || indexPath.row == 6 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
}
