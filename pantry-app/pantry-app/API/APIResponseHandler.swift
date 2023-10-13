//
//  APIResponseHandler.swift
//  pantry-app
//
//  Created by Marco Agizza on 10/10/23.
//

import Foundation

/// Handles response  when dealing with the API.
final class APIResponseHandler {
    
    /// Maps `Error` objects to `ErrorManager`.
    ///
    /// Adds special treatment for `URLError`s.
    static func mapError(_ error: Error) -> APIError {
        // if it's already an ErrorManager, just return
        if let ErrorManager = error as? APIError {
            return ErrorManager
        }
        
        if let urlError = error as? URLError {
            return .network(urlError)
        }
        
        return .unknown(error)
    }
}
