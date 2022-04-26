//
//  SplashViewController.swift
//  AppShowcase
//
//  Created by Brian Christo on 07/09/21.
//

import UIKit

class SplashViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.syncRealmDataAndGotoHome()
    }
}
