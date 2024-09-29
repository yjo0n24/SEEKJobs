//
//  JobListIO.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 29/09/2024.
//

import Foundation

// Define the interaction between VC and VM here!

// Input represents VC -> VM event:
// Think of what event from the VC should trigger the VM to perform an action

// Output represents VM -> VC event:
// Think of what event from the VM should trigger the VC to perform an action

enum JobListInput {
    case viewDidLoad
    case tableViewWillRefresh
    case tableViewWillLoadMore
    case btnLogoutDidTap
}

enum JobListOutput {
    case loadingIndicatorWillStart
    case loadingIndicatorWillStop
    case refreshControlWillStop
    case willReloadTableView
    case willRouteToLogin
    case didReceiveError(error: Error)
}
