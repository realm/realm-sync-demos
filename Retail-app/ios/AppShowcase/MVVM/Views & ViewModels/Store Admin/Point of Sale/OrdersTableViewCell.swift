//
//  OrdersTableViewCell.swift
//  AppShowcase
//
//  Created by Brian Christo on 21/02/22.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var orderIdTitleLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var addressTitleLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var custNameTitleLbl: UILabel!
    @IBOutlet weak var custNameLbl: UILabel!
    @IBOutlet weak var datetimeTitleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var payStatusTitleLbl: UILabel!
    @IBOutlet weak var payStatusLbl: UILabel!
    @IBOutlet weak var menuButton: UIButton!

    var model: Orders?{
        didSet{
            if let orderId = self.model?.orderId {
                self.orderIdLbl.text = "#\(orderId)"
            } else {
                self.orderIdLbl.text = "n/a"
            }
            if let cusName = self.model?.customerName {
                self.custNameLbl.text = cusName
            } else {
                self.custNameLbl.text = "n/a"
            }
            self.addressTitleLbl.text = self.model?.type?.name
            if let cusAddress = self.model?.type?.address {
                self.addressLbl.text = cusAddress
            } else {
                self.addressLbl.text = ""
            }
            if let datetime = self.model?.createdDate {
                self.dateLbl.text = datetime.getDateStringFromDate()
                self.timeLbl.text = datetime.getTimeStringFromDate()
            } else {
                self.dateLbl.text = "n/a"
                self.timeLbl.text = ""
            }
            if let payStatus = self.model?.paymentStatus {
                self.payStatusLbl.text = payStatus.capitalizingFirstLetter()
            } else {
                self.payStatusLbl.text = "n/a"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.outerView.makeRoundCorner(withRadius: 4, borderColor: .appBorderColor())
        outerView.setShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
