//
//  LoginViewIO.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 28/09/2024.
//

import Foundation

// Define the interaction between VC and VM here!

// Input represents VC -> VM event:
// Think of what event from the VC should trigger the VM to perform an action

// Output represents VM -> VC event:
// Think of what event from the VM should trigger the VC to perform an action

enum LoginViewInput {
    case didEditTextFields(username: String, password: String)
    case btnLoginDidTap(username: String, password: String)
    case btnStartDidTap
}

enum LoginViewOutput {
    case loadingIndicatorWillStart
    case loadingIndicatorWillStop
    case shouldChangeLoginButtonState(isEnabled: Bool, alpha: CGFloat)
    case loginDidFail(error: Error)
    case willRouteToHome
    case willPerformSegue(_ identifier: String)
}
