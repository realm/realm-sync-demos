//
//  DoctorInformation3TableViewCell.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 25/04/22.
//

import UIKit

class DoctorInfoTextViewCell: UITableViewCell {
    
    //Outlet
    @IBOutlet weak var nameTitle : UILabel!
    
    @IBOutlet weak var descTextView : UITextView! {
        didSet {
            self.descTextView.layer.cornerRadius = 10
            self.descTextView.layer.borderWidth = 0.0
            self.descTextView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
            self.descTextView.layer.shadowOpacity = 1.0
            self.descTextView.layer.shadowRadius = 1.0
            self.descTextView.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.descTextView.backgroundColor = UIColor.init(hexString: UIColor.Colors.doctorInfotextFieldBacClr, alpha: 0.6)
            self.descTextView.delegate = self
        }
    }
    
    //Variable
    var didClickTextView : ((_ textfieldInt : Int, _ textReceived : String) -> ()) = {textfieldInt,textReceived in }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension DoctorInfoTextViewCell : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        didClickTextView(textView.tag, textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        didClickTextView(textView.tag, textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        didClickTextView(textView.tag, textView.text)
        return true
    }
}
