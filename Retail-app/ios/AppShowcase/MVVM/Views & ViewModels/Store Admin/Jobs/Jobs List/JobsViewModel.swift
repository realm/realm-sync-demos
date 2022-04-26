//
//  JobsViewModel.swift
//  AppShowcase
//
//  Created by Gagandeep on 01/09/21.
//

import Foundation
import RealmSwift

class JobsViewModel: NSObject{
    var currentJobs: Results<Jobs>?
    var currentJobsNotificationToken: NotificationToken?
    var currentJobsCount: Int {
        return currentJobs?.count ?? 0
    }

    func getJobs() {
        currentJobs = RealmManager.shared.getStoreAdminJobs()
    }
    
    func getFilteredJobs(jobtype: JobType?, jobStatus: JobStatus?) {
        currentJobs = RealmManager.shared.getStoreAdminJobsWithFilters(jobType: jobtype, jobStatus: jobStatus)
    }
}
