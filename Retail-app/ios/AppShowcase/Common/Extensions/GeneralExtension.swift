//
//  ButtonExtension.swift
//  AppShowcase
//
//  Created by Karthick TM on 27/01/22.
//

import Foundation
import UIKit

func storyBoardMove (storyBoardName : String, storyBoardID : String, vcSender: UIViewController) {
    
    let vc = UIStoryboard.init(name: storyBoardName, bundle: Bundle.main).instantiateViewController(withIdentifier: storyBoardID)
    vcSender.navigationController?.pushViewController(vc, animated: true)
}

