//
//  UserModel.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 28/09/2024.
//

import Foundation

struct AuthModel: Codable {
    var user: String
    var password: String
}

struct JobApplicationModel: Codable {
    var userId: String
    var jobId: String
}
