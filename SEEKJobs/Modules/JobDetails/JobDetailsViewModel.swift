//
//  JobDetailsViewModel.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 29/09/2024.
//

import Foundation
import Combine

class JobDetailsViewModel {
    
    // MARK: - Properties
    private var apiService: ApiServiceProtocol
    private let output = PassthroughSubject<JobDetailsViewOutput, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Methods
    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }
    
    func bindView(input: AnyPublisher<JobDetailsViewInput, Never>) -> AnyPublisher<JobDetailsViewOutput, Never> {
        input.sink(receiveValue: { [weak self] inputEvent in
            switch inputEvent {
                case .viewDidLoad(let jobId):
                    self?.requestGetJob(jobId: jobId)
                case .btnApplyDidTap(let jobId):
                    self?.requestJobApplication(jobId: jobId)
            }
        }).store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    // MARK: - Service Methods
    private func requestJobApplication(jobId: String) {
        output.send(.loadingIndicatorWillStart)
        
        apiService.requestJobApplication(jobId: jobId).sink(
            receiveCompletion: { [weak self] completion in
                self?.output.send(.loadingIndicatorWillStop)
                
                switch completion {
                    case .failure(let error):
                        self?.output.send(.didReceiveError(error: error))
                    default:
                        break
                }
            },
            receiveValue: { [weak self] response in
                // Get job details with updated status
                // Could this have been handled better? Probably...
                self?.requestGetJob(jobId: jobId)
            }
        ).store(in: &cancellables)
    }
    
    private func requestGetJob(jobId: String) {
        output.send(.loadingIndicatorWillStart)
        
        apiService.requestGetJob(jobId: jobId).sink(
            receiveCompletion: { [weak self] completion in
                self?.output.send(.loadingIndicatorWillStop)
                
                switch completion {
                    case .failure(let error):
                        self?.output.send(.didReceiveError(error: error))
                    default:
                        break
                }
            },
            receiveValue: { [weak self] response in
                self?.output.send(.loadingIndicatorWillStop)
                self?.output.send(.willUpdateJobDetails(job: response))
            }
        ).store(in: &cancellables)
    }
}
