//
//  SharedConstant.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 28/09/2024.
//

import Foundation

struct SharedConstants {
    struct Storyboard {
        static let login = "Login"
        static let main = "Main"
    }
    
    struct ViewTag {
        static let LOADING_VIEW_TAG = -7787
    }
    
    struct Segue {
        static let jobDetails = "segueJobDetails"
    }
    
    struct Key {
        static let storyboardName = "storyboardName"
    }
    
    struct UserDefaultsKey {
        static let username = "username"
    }
}
