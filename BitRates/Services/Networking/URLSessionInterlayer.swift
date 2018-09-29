//
//  URLSessionInterlayer.swift
//  BitRates
//
//  Created by Serge Sukhanov on 9/29/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import Foundation

typealias DataTaskCompletion = (Data?, URLResponse?, Error?) -> Void

// sourcery: AutoMockable
protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

// sourcery: AutoMockable
protocol URLSessionInterlayerProtocol {
    func dataTask(with request: URLRequest, completionHandler: DataTaskCompletion?) -> URLSessionDataTaskProtocol?
}

class URLSessionInterlayer: URLSessionInterlayerProtocol {
    func dataTask(with request: URLRequest, completionHandler: DataTaskCompletion?) -> URLSessionDataTaskProtocol? {
        return completionHandler.map { URLSession.shared.dataTask(with: request, completionHandler: $0) }
    }
}
