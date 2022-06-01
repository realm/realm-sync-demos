//
//  ViewControllerExtension.swift
//  MDBRealmPatient
//
//  Created by Mackbook on 5/30/22.
//

import Foundation
extension UIViewController {

    func addBackButtonToNav() {
        if self.navigationController != nil {
            self.navigationController!.setNavigationBarHidden(false, animated:true)
        }
        let backImage = UIImage(named: "back")
        let myCustomBackButton: UIBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(UIViewController.dismiss(button:)))
        myCustomBackButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = myCustomBackButton
    }
    @objc func dismiss(button:UIBarButtonItem)  {
        self.navigationController?.popViewController(animated: true)
    }
    func addRightButtonToNav() {
        if self.navigationController != nil {
            self.navigationController!.setNavigationBarHidden(false, animated:true)
        }
        let backImage = UIImage(named: "menu")
        let myCustomBackButton: UIBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(UIViewController.rightBtn(button:)))
        myCustomBackButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = myCustomBackButton
    }
    @objc func rightBtn(button:UIBarButtonItem)  {
        self.navigationController?.popViewController(animated: true)
    }

}
extension UIButton {
    /**
      To disable a button in this app
      - This will visually and functionally disable the button
      */
     func disableTap() {
         self.isUserInteractionEnabled = false
         self.isEnabled = false
         self.alpha = 0.5
     }
    /**
      To enable a button in this app
      - This will visually and functionally enable the button
      */
     func enableTap() {
         self.isUserInteractionEnabled = true
         self.isEnabled = true
         self.alpha = 1.0
     }
}
