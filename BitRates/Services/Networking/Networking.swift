//
//  Networking.swift
//  BitRates
//
//  Created by Serge Sukhanov on 9/29/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import Foundation

typealias ResponseResultCompletion = (ServerResponse) -> Void

enum ServerResponse: Equatable {
    case wrongRequest
    case success (data: Data?)
    case failure (error: NSError)
}

// sourcery: AutoMockable
protocol NetworkingProtocol {
    func sendRequest(urlString: String, completion: ResponseResultCompletion?)
}

class Networking {
    var urlSession: URLSessionInterlayerProtocol
    
    init(urlSession: URLSessionInterlayerProtocol = URLSessionInterlayer()) {
        self.urlSession = urlSession
    }
}

extension Networking: NetworkingProtocol {
    func sendRequest(urlString: String, completion: ResponseResultCompletion?) {
        guard let request = self.prepareRequest(urlString: urlString) else {
            completion?(.wrongRequest)
            return
        }
        
        print("request started: \(urlString)")
        self.serverRequest(request) { (data, response, error) in
            print("request completed: \(urlString)")
            // TODO: - print data as JSON to the console, something like this: print(data?.toJson())

            let serverResponse: ServerResponse
            if let error = error {
                serverResponse = .failure(error: error as NSError)
            } else {
                serverResponse = .success(data: data)
            }
            completion?(serverResponse)
        }
        
    }
    
    // MARK: - Private methods
    
    private func prepareRequest(urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var resultRequest = URLRequest(url: url)
        resultRequest.httpMethod = "GET"
        return resultRequest
    }
    
    private func serverRequest(_ request: URLRequest, completion: DataTaskCompletion?) {
        let newTask = self.urlSession.dataTask(with: request, completionHandler: completion)
        newTask?.resume()
    }
}
