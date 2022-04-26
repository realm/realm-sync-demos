//
//  JobsTableViewCell.swift
//  AppShowcase
//
//  Created by Gagandeep on 01/09/21.
//

import UIKit

class JobsTableViewCell: UITableViewCell {
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var destinationStoreLbl: UILabel!
    @IBOutlet weak var jobTypeLbl: UILabel!
    @IBOutlet weak var pickupStoreLbl: UILabel!
    @IBOutlet weak var pickupDateLbl: UILabel!
    @IBOutlet weak var pickupTimeLbl: UILabel!
    @IBOutlet weak var pickupAssigneeLbl: UILabel!
    @IBOutlet weak var pickupStatusLbl: UILabel!
    var model: Jobs?{
        didSet{
            if let source = self.model?.sourceStore {
                self.pickupStoreLbl.text = source.name.capitalizingFirstLetter()
            } else {
                self.pickupStoreLbl.text = "n/a"
            }
            if let destination = self.model?.destinationStore {
                self.destinationStoreLbl.text = destination.name.capitalizingFirstLetter()
            } else {
                self.destinationStoreLbl.text = ""
                if let orderId =  self.model?.order {
                    let order = RealmManager.shared.getOrder(witId: orderId )
                    if order != nil {
                        self.destinationStoreLbl.text = order?.type?.address
                    } 
                }
            }
            if let assignedTo = self.model?.assignedTo {
                let fName = assignedTo.firstName ?? ""
                let lName = assignedTo.lastName ?? ""
                self.pickupAssigneeLbl.text =  fName.capitalizingFirstLetter() + " " + lName.capitalizingFirstLetter()
            } else {
                self.pickupAssigneeLbl.text = "n/a"
            }
            self.pickupDateLbl.text = self.model?.datetime?.getDateStringFromDate()
            self.pickupTimeLbl.text = self.model?.datetime?.getTimeStringFromDate()
            self.pickupStatusLbl.text = self.model?.status.capitalizingFirstLetter()
            self.jobTypeLbl.text = self.model?.type ?? ""
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.outerView.makeRoundCorner(withRadius: 4, borderColor: .appBorderColor())
        self.outerView.setShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class DeliveryUserTableViewCell: UITableViewCell {
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var destinationStoreLbl: UILabel!
    @IBOutlet weak var pickupStoreLbl: UILabel!
    @IBOutlet weak var pickupDateLbl: UILabel!
    @IBOutlet weak var pickupTimeLbl: UILabel!
    @IBOutlet weak var pickupStatusLbl: UILabel!
    var model:Jobs?{
        didSet{
            if let source = self.model?.destinationStore {
                let sourceStore = RealmManager.shared.getStore(withId: source._id)
                self.destinationStoreLbl.text = "Pickup: \(sourceStore?.name.capitalizingFirstLetter() ?? "n/a")"
            } else {
                self.destinationStoreLbl.text = "Pickup: n/a"
            }
            if let destination = self.model?.destinationStore {
                let destinationStore = RealmManager.shared.getStore(withId: destination._id)
                self.destinationStoreLbl.text = "Destination: \(destinationStore?.name.capitalizingFirstLetter() ?? "n/a")"
            } else {
                self.destinationStoreLbl.text = "Destination: n/a"
            }
            self.pickupDateLbl.text = self.model?.datetime?.getDateStringFromDate()
            self.pickupTimeLbl.text = self.model?.datetime?.getTimeStringFromDate()
            self.pickupStatusLbl.text = self.model?.status
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.outerView.makeRoundCorner(withRadius: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
