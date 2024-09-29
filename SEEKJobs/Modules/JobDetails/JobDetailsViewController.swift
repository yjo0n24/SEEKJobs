//
//  JobDetailsViewController.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 29/09/2024.
//

import Combine
import Foundation
import UIKit

class JobDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var txtCompanyName: UILabel!
    @IBOutlet weak var txtJobTitle: UILabel!
    @IBOutlet weak var txtSalaryRange: UILabel!
    @IBOutlet weak var txtApplicationStatus: UILabel!
    @IBOutlet weak var txtJobDescription: UILabel!
    @IBOutlet weak var btnApply: UIButton!
    
    // MARK: - Properties
    private let viewModel = JobDetailsViewModel(apiService: ApiService())
    private let input = PassthroughSubject<JobDetailsViewInput, Never>()
    private var cancellables = Set<AnyCancellable>()
    var jobId = ""
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        input.send(.viewDidLoad(jobId: jobId))
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
                    case.willUpdateJobDetails(let job):
                        self?.updateJobDetails(job: job)
                    case .didReceiveError(let error):
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }).store(in: &cancellables)
    }
    
    private func updateJobDetails(job: Job) {
        txtCompanyName.text = job.company.name
        txtJobTitle.text = job.positionTitle
        txtJobDescription.text = job.description
        
        let salaryRange = job.salaryRange
        txtSalaryRange.text = "MYR \(salaryRange.min) - \(salaryRange.max)"
        
        if job.haveIApplied {
            txtApplicationStatus.text = "Applied"
            btnApply.setTitle("CANCEL APPLICATION", for: .normal)
        }
        else {
            txtApplicationStatus.text = "Not yet applied"
            btnApply.setTitle("APPLY NOW", for: .normal)
        }
    }
    
    // MARK: - IBActions
    @IBAction func btnApplyDidTap(_ sender: UIButton) {
        input.send(.btnApplyDidTap(jobId: jobId))
    }
}
