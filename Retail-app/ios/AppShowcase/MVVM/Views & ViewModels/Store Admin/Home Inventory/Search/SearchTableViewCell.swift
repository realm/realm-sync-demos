//
//  SearchTableViewCell.swift
//  AppShowcase
//
//  Created by Gagandeep on 01/09/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var model:String?{
        didSet{
            self.productNameLbl.text = model?.capitalizingFirstLetter()
        }
    }

}
