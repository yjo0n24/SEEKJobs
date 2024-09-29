//
//  ApiService.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 28/09/2024.
//

import Foundation
import Combine

class ApiService: ApiServiceProtocol {
    
    // MARK: - Enums
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
    
    // MARK: - Properties
    private let baseEndpoint = "http://localhost:3001"
    
    func requestLogin(authModel: AuthModel) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: "\(baseEndpoint)/auth") else {
            return Fail(error: ApiServiceError("oops, service error")).eraseToAnyPublisher()
        }
        
        var request = buildRequest(for: url, method: .post)
        
        do {
            let data = try JSONEncoder().encode(authModel)
            request.httpBody = data
            print("ApiService :: requestLogin - \(String(data: data, encoding: .utf8) ?? "-")")
        }
        catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .catch({ error in
                return Fail(error: error).eraseToAnyPublisher()
            })
            .tryMap({ (data, response) in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    if !(200..<300).contains(statusCode) {
                        let errorMsg = String(data: data, encoding: .utf8)
                        throw ApiServiceError(errorMsg ?? "Invalid HTTP status code")
                    }
                }
                else {
                    throw ApiServiceError("Invalid HTTP response")
                }
                return data
            })
            .mapError({ $0 })
            //.map({ $0.data })
            .eraseToAnyPublisher()
    }
    
    func requestGetPublishedJobList(page: Int, itemsPerPage: Int) -> AnyPublisher<JobListModel, Error> {
        let endpoint = "\(baseEndpoint)/jobs/published?per_page=\(itemsPerPage)&page=\(page)"
        guard let url = URL(string: endpoint) else {
            return Fail(error: ApiServiceError("oops, service error")).eraseToAnyPublisher()
        }
        
        let request = buildRequest(for: url, method: .get)
        return URLSession.shared.dataTaskPublisher(for: request)
            .catch({ error in
                return Fail(error: error).eraseToAnyPublisher()
            })
            .map({ $0.data })
            .decode(type: JobListModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func requestGetJob(jobId: String) -> AnyPublisher<Job, Error> {
        let endpoint = "\(baseEndpoint)/jobs/\(jobId)"
        guard let url = URL(string: endpoint) else {
            return Fail(error: ApiServiceError("oops, service error")).eraseToAnyPublisher()
        }
        
        let request = buildRequest(for: url, method: .get)
        return URLSession.shared.dataTaskPublisher(for: request)
            .catch({ error in
                return Fail(error: error).eraseToAnyPublisher()
            })
            .map({ $0.data })
            .decode(type: Job.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func requestJobApplication(jobId: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "\(baseEndpoint)/application") else {
            return Fail(error: ApiServiceError("oops, service error")).eraseToAnyPublisher()
        }
        
        var request = buildRequest(for: url, method: .put)
        
        do {
            let jobApplicationModel = JobApplicationModel(
                userId: UserDefaultsHelper().getCurrentUser(),
                jobId: jobId
            )
            let data = try JSONEncoder().encode(jobApplicationModel)
            request.httpBody = data
            print("ApiService :: requestLogin - \(String(data: data, encoding: .utf8) ?? "-")")
        }
        catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .catch({ error in
                return Fail(error: error).eraseToAnyPublisher()
            })
            .tryMap({ (_, response) in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    if !(200..<300).contains(statusCode) {
                        throw ApiServiceError("Invalid HTTP status code")
                    }
                }
                else {
                    throw ApiServiceError("Invalid HTTP response")
                }
                return Void()
            })
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    
    private func buildRequest(for url: URL, method: HttpMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if let token = try? KeychainHelper().getToken(identifier: UserDefaultsHelper().getCurrentUser()) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
