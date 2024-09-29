//
//  UserDefaultsHelper.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 29/09/2024.
//

import Foundation

struct UserDefaultsHelper {
    
    // MARK: - Variables
    let defaults = UserDefaults.standard
    
    // MARK: - Methods
    func setCurrentUser(_ username: String) {
        defaults.set(username, forKey: SharedConstants.UserDefaultsKey.username)
    }
    
    func getCurrentUser() -> String {
        return defaults.string(forKey: SharedConstants.UserDefaultsKey.username) ?? ""
    }
    
    func deleteCurrentUser() {
        defaults.removeObject(forKey: SharedConstants.UserDefaultsKey.username)
    }
}
