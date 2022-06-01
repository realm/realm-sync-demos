//
//  DoctorInfoNameEditTableView.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 25/04/22.
//

import UIKit

class DoctorInfoNameEditTableView: UITableViewCell {
    
    //Outlets
    
    @IBOutlet weak var nameLabel : UILabel!
    
    @IBOutlet weak var nameTextField : UITextField! {
        didSet {
            self.nameTextField.setShadowSetting()
            self.nameTextField.rightView = self.UserTypeView
            self.nameTextField.delegate = self
        }
    }
    
    //Variable declaration
    var didClickSpeciality : ((_ textfield : Int, _ textFromTextfield : String) -> ()) = {textfield,textFromTextfield  in }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    ///Internal function for
    ///Function for declaring the userType
    internal var UserTypeView: UIButton {
        let size: CGFloat = 25.0
        var filled = UIButton.Configuration.plain()
        filled.image = UIImage(named : UIConstants.signUpView.rightArrowTextField)
        filled.imagePlacement = .trailing
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.tintColor = UIColor.clear
        button.frame = CGRect(x: self.nameTextField.frame.size.width - size, y: 0.0, width: size, height: size)
        return button
    }

}

//extension Uitableviewcell
extension DoctorInfoNameEditTableView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didClickSpeciality(textField.tag, textField.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        didClickSpeciality(textField.tag, textField.text ?? "")
        return true
    }
}
