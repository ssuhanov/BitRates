//
//  PriceGettersTests.swift
//  BitRatesTests
//
//  Created by Serge Sukhanov on 10/1/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import XCTest
@testable import BitRates

class CoinMarketPriceGettersTests: XCTestCase {
    var instance: CoinMarketPriceGetter!
    
    var networkingMock: NetworkingProtocolMock!
    
    var dataModel: CoinMarketDataModel!
    var serverResponse: ServerResponse = .wrongRequest
    var priceWithTimestamp: PriceWithTimestamp?
    var priceUpdateResultCompletion: PriceUpdateResultCompletion?
    
    let correctTimestamp: Int = 12345678
    let correctPrice: Double = 123456.654321
    
    override func setUp() {
        super.setUp()
        
        self.dataModel = self.prepareDataModel()
        self.networkingMock = NetworkingProtocolMock()
        when(self.networkingMock).sendRequestUrlStringCompletion().then { (_, completion) in
            completion?(self.serverResponse)
        }
        self.instance = CoinMarketPriceGetter(networking: self.networkingMock)
        self.priceUpdateResultCompletion = { self.priceWithTimestamp = $0 }
    }

    private func prepareDataModel() -> CoinMarketDataModel {
        return CoinMarketDataModel.builder
            .data(CMData.builder
                .the1(CMThe1.builder
                    .lastUpdated(self.correctTimestamp)
                    .quotes(CMQuotes.builder
                        .usd(CMUsd.builder
                            .price(self.correctPrice)
                            .build())
                        .build())
                    .build())
                .build())
            .build()
    }
    
    func testNetworkingCalledForCMPriceUpdating() {
        self.instance.getPrice(completion: nil)
        verify(self.networkingMock).sendRequestUrlStringCompletion().urlString(equalsTo: ApplicationConstants.CoinMarketUrl)
    }

    func testUpdateCMPriceCalledWithCorrectData() {
        let correctPriceWithTimestamp = PriceWithTimestamp(timestamp: self.correctTimestamp, price: self.correctPrice)
        let data = try? JSONEncoder().encode(self.dataModel)
        self.serverResponse = .success(data: data)
        self.instance.getPrice(completion: self.priceUpdateResultCompletion)
        XCTAssertEqual(self.priceWithTimestamp, correctPriceWithTimestamp, "price with timestamp should be \(correctPriceWithTimestamp)")
    }

    func testShowCMErrorWithoutData() {
        self.serverResponse = .success(data: nil)
        self.instance.getPrice(completion: self.priceUpdateResultCompletion)
        XCTAssertNil(self.priceWithTimestamp, "price with timestamp should be nil")
    }

    func testShowCMErrorWithServerError() {
        self.serverResponse = .failure(error: NSError())
        self.instance.getPrice(completion: self.priceUpdateResultCompletion)
        XCTAssertNil(self.priceWithTimestamp, "price with timestamp should be nil")
    }

    func testShowCMErrorWithWrongRequest() {
        self.serverResponse = .wrongRequest
        self.instance.getPrice(completion: self.priceUpdateResultCompletion)
        XCTAssertNil(self.priceWithTimestamp, "price with timestamp should be nil")
    }
}

class CryptoComparePriceGettersTests: XCTestCase {
    var instance: CryptoComparePriceGetter!
    
    var networkingMock: NetworkingProtocolMock!
    
    var dataModel: CryptoCompareDataModel!
    var serverResponse: ServerResponse = .wrongRequest
    var priceWithTimestamp: PriceWithTimestamp?
    var priceUpdateResultCompletion: PriceUpdateResultCompletion?
    
    let correctTimestamp: Int = 12345678
    let correctPrice: Double = 123456.654321
    
    override func setUp() {
        super.setUp()
        
        self.dataModel = self.prepareDataModel()
        self.networkingMock = NetworkingProtocolMock()
        when(self.networkingMock).sendRequestUrlStringCompletion().then { (_, completion) in
            completion?(self.serverResponse)
        }
        self.instance = CryptoComparePriceGetter(networking: self.networkingMock)
        self.priceUpdateResultCompletion = { self.priceWithTimestamp = $0 }
    }
    
    private func prepareDataModel() -> CryptoCompareDataModel {
        return CryptoCompareDataModel.builder
            .raw(CCRaw.builder
                .btc(CCBtc.builder
                    .usd(CCUsd.builder
                        .lastUpdate(self.correctTimestamp)
                        .price(self.correctPrice)
                        .build())
                    .build())
                .build())
            .build()
    }
    
    func testNetworkingCalledForCMPriceUpdating() {
        self.instance.getPrice(completion: nil)
        verify(self.networkingMock).sendRequestUrlStringCompletion().urlString(equalsTo: ApplicationConstants.CryptoCompareUrl)
    }
    
    func testUpdateCMPriceCalledWithCorrectData() {
        let correctPriceWithTimestamp = PriceWithTimestamp(timestamp: self.correctTimestamp, price: self.correctPrice)
        let data = try? JSONEncoder().encode(self.dataModel)
        self.serverResponse = .success(data: data)
        self.instance.getPrice(completion: self.priceUpdateResultCompletion)
        XCTAssertEqual(self.priceWithTimestamp, correctPriceWithTimestamp, "price with timestamp should be \(correctPriceWithTimestamp)")
    }
    
    func testShowCMErrorWithoutData() {
        self.serverResponse = .success(data: nil)
        self.instance.getPrice(completion: self.priceUpdateResultCompletion)
        XCTAssertNil(self.priceWithTimestamp, "price with timestamp should be nil")
    }
    
    func testShowCMErrorWithServerError() {
        self.serverResponse = .failure(error: NSError())
        self.instance.getPrice(completion: self.priceUpdateResultCompletion)
        XCTAssertNil(self.priceWithTimestamp, "price with timestamp should be nil")
    }
    
    func testShowCMErrorWithWrongRequest() {
        self.serverResponse = .wrongRequest
        self.instance.getPrice(completion: self.priceUpdateResultCompletion)
        XCTAssertNil(self.priceWithTimestamp, "price with timestamp should be nil")
    }
}
