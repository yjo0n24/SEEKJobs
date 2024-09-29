//
//  LoginViewController.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 28/09/2024.
//

import Combine
import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    // MARK: - Properties
    private let viewModel = LoginViewModel(apiService: ApiService())
    private let input = PassthroughSubject<LoginViewInput, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        bindViewModel()
    }
    
    private func initObservers() {
        txtUsername.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        txtPassword.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    }
    
    private func bindViewModel() {
        let output = viewModel.bindView(input: input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] outputEvent in
                switch outputEvent {
                    case .loadingIndicatorWillStart:
                        self?.startLoadingIndicator()
                    case .loadingIndicatorWillStop:
                        self?.stopLoadingIndicator()
                    case .shouldChangeLoginButtonState(let isEnabled, let alpha):
                        self?.btnLogin.isEnabled = isEnabled
                        self?.btnLogin.alpha = alpha
                    case .loginDidFail(let error):
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    case .willRouteToHome:
                        let userInfo = [SharedConstants.Key.storyboardName: SharedConstants.Storyboard.main]
                        NotificationCenter.default.post(name: .setRootVC, object: nil, userInfo: userInfo)
                    case .willPerformSegue(let identifier):
                        self?.performSegue(withIdentifier: identifier, sender: nil)
                }
            }).store(in: &cancellables)
    }
    
    @objc private func textFieldValueChanged() {
        input.send(.didEditTextFields(
            username: txtUsername.text ?? "",
            password: txtPassword.text ?? "")
        )
    }
    
    // MARK: - IBActions
    @IBAction func btnLoginDidTap(_ sender: UIButton) {
        input.send(.btnLoginDidTap(
            username: txtUsername.text ?? "",
            password: txtPassword.text ?? "")
        )
    }
    
    @IBAction func btnStartDidTap(_ sender: UIButton) {
        
    }
}
