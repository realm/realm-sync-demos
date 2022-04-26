//
//  AddStoreFooterView.swift
//  AppShowcase
//
//  Created by Brian Christo on 03/02/22.
//

import Foundation
import UIKit

class AddStoreFooterView: UITableViewHeaderFooterView  {
    
    @IBOutlet weak var addStoreBtn : UIButton!  {
        didSet  {
            self.addStoreBtn.makeRoundCorner(withRadius: 0, borderColor: UIColor.appGreenColor())
        }
    }
}
