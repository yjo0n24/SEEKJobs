//
//  UIExtensions.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 28/09/2024.
//

import Foundation
import UIKit

extension UIViewController {
    func startLoadingIndicator() {
        let loadingView = UIActivityIndicatorView(
            frame: CGRect(x: 0, y: 0, width: 50, height: 50)
        )
        loadingView.tag = SharedConstants.ViewTag.LOADING_VIEW_TAG
        loadingView.center = self.view.center
        loadingView.style = .large
        loadingView.color = .systemGray
        loadingView.startAnimating()
        
        self.view.addSubview(loadingView)
    }
    
    func stopLoadingIndicator() {
        self.view.viewWithTag(SharedConstants.ViewTag.LOADING_VIEW_TAG)?.removeFromSuperview()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
