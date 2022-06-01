//
//  TimeSlotCollectionViewCell.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 6/25/22.
//


import UIKit

class TimeSlotCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLbl: UILabel!

    func unselectCell() {
        self.makeRoundCornerWithoutBorder(withRadius: 8)
        self.backgroundColor = .appCalendarLightGrayColor()
        timeLbl.textColor = .black
    }
    
    func selectCell() {
        self.makeRoundCornerWithoutBorder(withRadius: 8)
        self.backgroundColor = .appCalendarSelectBGColor()
        timeLbl.textColor = .white
    }
}
