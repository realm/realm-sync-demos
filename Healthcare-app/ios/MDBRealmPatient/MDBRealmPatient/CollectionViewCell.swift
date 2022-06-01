//
//  CollectionViewCell.swift
//  MDBRealmPatient
//
//  Created by Mackbook on 05/05/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hospitalImage        : UIImageView! {
        didSet {
            self.hospitalImage.contentMode = .scaleAspectFill
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
