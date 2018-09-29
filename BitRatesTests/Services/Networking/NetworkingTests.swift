//
//  NetworkingTests.swift
//  BitRatesTests
//
//  Created by Serge Sukhanov on 9/29/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import XCTest
@testable import BitRates

class NetworkingTests: XCTestCase {
    var instance: Networking!
    
    var dataTaskMock: URLSessionDataTaskProtocolMock!
    var urlSessionMock: URLSessionInterlayerProtocolMock!
    
    var data: Data?
    var urlResponse: URLResponse?
    var error: NSError?

    var requestCompletion: ResponseResultCompletion?
    var serverResponse: ServerResponse?
    
    let correctUrl = "http://google.com"
    let incorrectUrl = "incorrect url"

    override func setUp() {
        super.setUp()
        
        self.dataTaskMock = URLSessionDataTaskProtocolMock()
        self.urlSessionMock = URLSessionInterlayerProtocolMock()
        when(self.urlSessionMock).dataTaskWithCompletionHandler().thenReturn(self.dataTaskMock)
        when(self.dataTaskMock).resume().then {
            self.urlSessionMock
                .dataTaskWithCompletionHandlerReceivedArguments?
                .completionHandler?(self.data, self.urlResponse, self.error)
        }
        
        self.requestCompletion = {
            self.serverResponse = $0
        }
        self.instance = Networking(urlSession: self.urlSessionMock)
    }
    
    override func tearDown() {
        super.tearDown()
        
        self.data = nil
        self.urlResponse = nil
        self.error = nil
    }
    
    func testWrongRequestWithIncorrectUrl() {
        self.instance.sendRequest(urlString: self.incorrectUrl, completion: self.requestCompletion)
        XCTAssertEqual(self.serverResponse, .wrongRequest, "server response should be wrong request")
    }
    
    func testFailureWithError() {
        let error = NSError(domain: "domain", code: 0, userInfo: nil)
        self.error = error
        self.instance.sendRequest(urlString: self.correctUrl, completion: self.requestCompletion)
        XCTAssertEqual(self.serverResponse, .failure(error: error), "server response should be failure")
    }
    
    func testSuccessWithoutData() {
        self.instance.sendRequest(urlString: self.correctUrl, completion: self.requestCompletion)
        XCTAssertEqual(self.serverResponse, .success(data: nil), "server response should be success without data")
    }
    
    func testSuccessWithData() {
        let data = Data(count: 25)
        self.data = data
        self.instance.sendRequest(urlString: self.correctUrl, completion: self.requestCompletion)
        XCTAssertEqual(self.serverResponse, .success(data: data), "server response should be success with data")
    }
}
