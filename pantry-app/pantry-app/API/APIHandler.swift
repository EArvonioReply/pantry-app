//
//  APIHandler.swift
//  pantry-app
//
//  Created by Marco Agizza on 10/10/23.
//

import Foundation
import Alamofire

class APIHandler<Item: Decodable>: NSObject {
    
    override init() {
        super.init()
    }
    
    // MARK: Network operations
    
    /// This function allows you to retrieve a list of `Item` throw a network call
    ///
    /// - Parameters:
    ///   - url: the complete url path to access the API
    ///   - parametersDictionary: a dictionary containing all the parameters for the API call
    ///   - handleData: the closure used to process the data returning from the API call
    ///   - handleError: the closure used to process the error thrown by the API call
    static func list(url: String, parameters: Parameters, handler: @escaping(_ recipesList: [Item]?, _ apiError: Error?) -> (Void)) async throws {
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { responce in
            switch responce.result {
            case .success(let data):
                print("api call success")
                do {
                    let searchResult = try JSONDecoder().decode([Item].self, from: data!)
                    handler(searchResult, nil)
                } catch {
                    print(error)
                    handler(nil, error)
                }
            case .failure(let error):
                print("api call failure")
                guard let errorCode = error.responseCode else {
                    handler(nil, error)
                    return
                }
                switch errorCode {
                case 200..<300:
                    return
                case 400:
                    handler(nil, APIError.badRequest)
                case 401:
                    handler(nil, APIError.unauthorized)
                case 402:
                    handler(nil, APIError.paymentRequired)
                case 403:
                    handler(nil, APIError.forbidden)
                case 404:
                    handler(nil, APIError.notFound)
                case 413:
                    handler(nil, APIError.requestEntityTooLarge)
                case 422:
                    handler(nil, APIError.unprocessableEntity)
                default:
                    handler(nil, APIError.http(httpResponse: responce.response!))
                }
            }
            
        }
    }
}

extension APIHandler {
    static func getRecipe(by parametersDictionary: [String:String], handler: @escaping(_ recipesList: [Item]?, _ apiError: Error?) -> (Void)) async throws {
        var parameters = Parameters()
        parametersDictionary.forEach { (key: String, value: String) in
            parameters[key] = value
        }
        try await APIHandler.list(url: Constants.spoonacularFullURL+Constants.spoonacularSearchPath, parameters: parameters, handler: handler)
    }
}
