//
//  LoginViewModel.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 28/09/2024.
//

import Foundation
import Combine

class LoginViewModel {
    
    // MARK: - Properties
    private var apiService: ApiServiceProtocol
    private let output = PassthroughSubject<LoginViewOutput, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Methods
    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }
    
    func bindView(input: AnyPublisher<LoginViewInput, Never>) -> AnyPublisher<LoginViewOutput, Never> {
        input.sink(receiveValue: { [weak self] inputEvent in
            switch inputEvent {
                case .didEditTextFields(let username, let password):
                    self?.validateFormInput(username: username, password: password)
                case .btnLoginDidTap(let username, let password):
                    self?.requestLogin(username: username, password: password)
                case .btnStartDidTap:
                    break
            }
        }).store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func validateFormInput(username: String, password: String) {
        if !username.isEmpty && !password.isEmpty {
            output.send(.shouldChangeLoginButtonState(isEnabled: true, alpha: 1.0))
        }
        else {
            output.send(.shouldChangeLoginButtonState(isEnabled: false, alpha: 0.5))
        }
    }
    
    // MARK: - Service Methods
    private func requestLogin(username: String, password: String) {
        output.send(.loadingIndicatorWillStart)
        
        let authModel = AuthModel(user: username, password: password)
        
        apiService.requestLogin(authModel: authModel).sink(
            receiveCompletion: { [weak self] completion in
                self?.output.send(.loadingIndicatorWillStop)
                
                switch completion {
                    case .failure(let error):
                        self?.output.send(.loginDidFail(error: error))
                    default:
                        break
                }
            },
            receiveValue: { [weak self] token in
                do {
                    print("requestLogin :: token received - \(String(data: token, encoding: .utf8) ?? "-")")
                    try KeychainHelper().insertOrUpdateToken(token, identifier: username)
                    UserDefaultsHelper().setCurrentUser(username)
                    self?.output.send(.willRouteToHome)
                }
                catch {
                    self?.output.send(.loginDidFail(error: error))
                }
            }
        ).store(in: &cancellables)
    }
}
