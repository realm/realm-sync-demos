//
//  ViewControllerExtension.swift
//  AppShowcase
//
//  Created by Brian Christo on 15/02/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// To puus view controller using storyboard id
    /// - Parameters:
    ///   - storyboardId: storyboard  id  of te viewcontroller to be pushed
    ///   - storyboardName: name of the storyboard  that cointains the pushed view controller 
    func pushVCAsPopup(withId storyboardId: String, onStoryboard storyboardName: String? = nil,  withStyle presentationStyle: UIModalPresentationStyle) {
        let  board = (storyboardName != nil) ? UIStoryboard(name: storyboardName!, bundle: nil) : self.storyboard
        guard let viewC = board?.instantiateViewController(withIdentifier: storyboardId) else { return }
        viewC.modalPresentationStyle = presentationStyle
        self.navigationController?.pushViewController(viewC, animated: true)
    }
}
