//
//  JobDetailsViewIO.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 29/09/2024.
//

import Foundation

enum JobDetailsViewInput {
    case viewDidLoad(jobId: String)
    case btnApplyDidTap(jobId: String)
}

enum JobDetailsViewOutput {
    case loadingIndicatorWillStart
    case loadingIndicatorWillStop
    case willUpdateJobDetails(job: Job)
    case didReceiveError(error: Error)
}
