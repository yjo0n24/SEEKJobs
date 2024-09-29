//
//  ApiServiceError.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 28/09/2024.
//

import Foundation

struct ApiServiceError: LocalizedError {
    let description: String
    
    init(_ description: String) {
        self.description = description
    }
    
    var errorDescription: String? {
        description
    }
}
