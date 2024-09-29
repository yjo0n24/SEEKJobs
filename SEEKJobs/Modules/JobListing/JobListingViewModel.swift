//
//  JobListingViewModel.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 29/09/2024.
//

import Foundation
import Combine

class JobListingViewModel {
    
    // MARK: - Properties
    private var apiService: ApiServiceProtocol
    private let output = PassthroughSubject<JobListOutput, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let currentPage = 1
    private let ITEMS_PER_PAGE = 10
    private var currentJobListModel: JobListModel?
    
    // MARK: - Methods
    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }
    
    func bindView(input: AnyPublisher<JobListInput, Never>) -> AnyPublisher<JobListOutput, Never> {
        input.sink(receiveValue: { [weak self] inputEvent in
            switch inputEvent {
                case .viewDidLoad:
                    fallthrough
                case .tableViewWillRefresh:
                    self?.reloadPage()
                case .tableViewWillLoadMore:
                    self?.loadNextPage()
                case .btnLogoutDidTap:
                    self?.performLogout()
            }
        }).store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    func getNumberOfRows() -> Int {
        return currentJobListModel?.jobs.count ?? 0
    }
    
    func getJob(for row: Int) -> Job? {
        if let _currentJobListModel = currentJobListModel, row < _currentJobListModel.total {
            return _currentJobListModel.jobs[row]
        }
        return nil
    }
    
    private func reloadPage() {
        currentJobListModel = nil
        requestGetPublishedJobList(page: 1)
    }
    
    private func loadNextPage() {
        guard let _currentJobListModel = currentJobListModel,
            _currentJobListModel.hasNext else {
            
            return
        }
        requestGetPublishedJobList(page: _currentJobListModel.page + 1)
    }
    
    private func updateCurrentJobListModel(response: JobListModel) {
        if let _ = currentJobListModel {
            currentJobListModel?.page = response.page
            currentJobListModel?.hasNext = response.hasNext
            currentJobListModel?.jobs.append(contentsOf: response.jobs)
        }
        else {
            currentJobListModel = response
        }
    }
    
    private func performLogout() {
        do {
            try KeychainHelper().deleteToken(identifier: UserDefaultsHelper().getCurrentUser())
            UserDefaultsHelper().deleteCurrentUser()
            output.send(.willRouteToLogin)
        }
        catch {
            output.send(.didReceiveError(error: error))
        }
    }
    
    // MARK: - Service Methods
    private func requestGetPublishedJobList(page: Int) {
        output.send(.loadingIndicatorWillStart)
        
        apiService.requestGetPublishedJobList(page: page, itemsPerPage: ITEMS_PER_PAGE).sink(
            receiveCompletion: { [weak self] completion in
                self?.output.send(.loadingIndicatorWillStop)
                self?.output.send(.refreshControlWillStop)
                
                switch completion {
                    case .failure(let error):
                        self?.output.send(.didReceiveError(error: error))
                    default:
                        break
                }
            },
            receiveValue: { [weak self] response in
                self?.output.send(.loadingIndicatorWillStop)
                self?.output.send(.refreshControlWillStop)
                self?.updateCurrentJobListModel(response: response)
                self?.output.send(.willReloadTableView)
            }
        ).store(in: &cancellables)
    }
}
