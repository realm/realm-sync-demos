//
//  DeliveryUserViewModel.swift
//  AppShowcase
//
//  Created by Gagandeep on 03/09/21.
//

import Foundation
import RealmSwift

class DeliveryUserViewModel: NSObject{
    var currentJobs: Results<Jobs>?
    var currentJobsNotificationToken: NotificationToken?
    var currentJobsCount: Int {
        return currentJobs?.count ?? 0
    }

    func getJobs() {
        currentJobs = RealmManager.shared.getDeliveryJobs()
    }
}
