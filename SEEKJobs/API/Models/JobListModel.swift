//
//  JobListModel.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 29/09/2024.
//

import Foundation

// MARK: - JobListModel
struct JobListModel: Codable {
    var page, size, total: Int
    var hasNext: Bool
    var jobs: [Job]
}

// MARK: - Job
struct Job: Codable {
    let salaryRange: SalaryRange
    let id, positionTitle, description: String
    let company: Company
    let location, industry, status: Int
    let createdAt, updatedAt: String
    let v: Int
    let haveIApplied: Bool

    enum CodingKeys: String, CodingKey {
        case salaryRange
        case id = "_id"
        case positionTitle, description, company, location, industry, status, createdAt, updatedAt
        case v = "__v"
        case haveIApplied
    }
}

// MARK: - Company
struct Company: Codable {
    let id, name, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, createdAt, updatedAt
    }
}

// MARK: - SalaryRange
struct SalaryRange: Codable {
    let min, max: Int
}
