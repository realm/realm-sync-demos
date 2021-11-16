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
    var doneJobs: Results<Jobs>?
    var currentJobsNotificationToken: NotificationToken?
    var doneJobsNotificationToken: NotificationToken?
    var currentJobsCount: Int {
        return currentJobs?.count ?? 0
    }
    var doneJobsCount: Int {
        return doneJobs?.count ?? 0
    }
    func getJobs() {
        let allJobs = RealmManager.shared.getDeliveryJobs()
        currentJobs = allJobs.0
        doneJobs = allJobs.1
    }
}
