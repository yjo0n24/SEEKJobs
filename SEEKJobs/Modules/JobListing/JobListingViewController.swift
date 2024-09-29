//
//  JobListingViewController.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 29/09/2024.
//

import Combine
import Foundation
import UIKit
import UIScrollView_InfiniteScroll

class JobListingViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblJobs: UITableView!
    
    // MARK: - Properties
    private let viewModel = JobListingViewModel(apiService: ApiService())
    private let input = PassthroughSubject<JobListInput, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let cellIdentifier = String(describing: JobListTableViewCell.self)
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        initUI()
        input.send(.viewDidLoad)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? JobDetailsViewController {
            if let jobDetails = sender as? Job {
                vc.jobId = jobDetails.id
            }
        }
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
                    case .refreshControlWillStop:
                        self?.refreshControl.endRefreshing()
                    case .willReloadTableView:
                        self?.tblJobs.reloadData()
                    case .willRouteToLogin:
                        self?.routeToLogin()
                    case .didReceiveError(let error):
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }).store(in: &cancellables)
    }
    
    private func initUI() {
        self.navigationItem.title = "Available Jobs"
        let btnLogout = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(btnLogoutDidTap)
        )
        btnLogout.tintColor = UIColor(named: "buttonPrimary")
        self.navigationItem.rightBarButtonItem = btnLogout
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tblJobs.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        tblJobs.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(startRefreshTableView), for: .valueChanged)
        
        tblJobs.addInfiniteScroll(handler: { [weak self] (tableView) -> () in
            self?.input.send(.tableViewWillLoadMore)
            tableView.finishInfiniteScroll()
        })
    }
    
    private func routeToLogin() {
        let userInfo = [SharedConstants.Key.storyboardName: SharedConstants.Storyboard.login]
        NotificationCenter.default.post(name: .setRootVC, object: nil, userInfo: userInfo)
    }
    
    @objc private func startRefreshTableView() {
        input.send(.tableViewWillRefresh)
    }
    
    @objc private func btnLogoutDidTap() {
        input.send(.btnLogoutDidTap)
    }
}

// MARK: - UITableViewDelegate
extension JobListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath
        ) as! JobListTableViewCell
        
        cell.initData(job: viewModel.getJob(for: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedJob = viewModel.getJob(for: indexPath.row)
        self.performSegue(withIdentifier: SharedConstants.Segue.jobDetails, sender: selectedJob)
    }
}
