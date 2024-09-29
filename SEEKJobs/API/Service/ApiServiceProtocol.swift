//
//  ApiServiceProtocol.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 28/09/2024.
//

import Foundation
import Combine

protocol ApiServiceProtocol {
    func requestLogin(authModel: AuthModel) -> AnyPublisher<Data, Error>
    func requestGetPublishedJobList(page: Int, itemsPerPage: Int) -> AnyPublisher<JobListModel, Error>
    func requestGetJob(jobId: String) -> AnyPublisher<Job, Error>
    func requestJobApplication(jobId: String) -> AnyPublisher<Void, Error>
}
