//
//  DataDeserializerTests.swift
//  BitRatesTests
//
//  Created by Serge Sukhanov on 9/30/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import XCTest
@testable import BitRates

class DataDeserializerTests: XCTestCase {
    var instance: DataDeserializer!
    
    var correctDataModel: CoinMarketDataModel!
    
    override func setUp() {
        super.setUp()
        
        self.correctDataModel = CoinMarketDataModel.builder
            .data(CMData.builder
                .the1(CMThe1.builder
                    .lastUpdated(12345678)
                    .quotes(CMQuotes.builder
                        .usd(CMUsd.builder
                            .price(12345.6789)
                            .build())
                        .build())
                    .build())
                .build())
            .build()
        self.instance = DataDeserializer()
    }
    
    func testDeserializeWithData() {
        let data = try? JSONEncoder().encode(self.correctDataModel)
        let serverResponse = ServerResponse.success(data: data)
        let result: CoinMarketDataModel? = self.instance.deserialize(serverResponse: serverResponse)
        XCTAssertEqual(result, self.correctDataModel, "correct data model should be \(self.correctDataModel)")
    }
    
    func testDeserializeWithoutData() {
        let serverResponse = ServerResponse.success(data: nil)
        let result: CoinMarketDataModel? = self.instance.deserialize(serverResponse: serverResponse)
        XCTAssertNil(result, "result should be nil")
    }
    
    func testDeserializeWithFailure() {
        let serverResponse = ServerResponse.failure(error: NSError())
        let result: CoinMarketDataModel? = self.instance.deserialize(serverResponse: serverResponse)
        XCTAssertNil(result, "result should be nil")
    }
    
    func testDeserializeWithWrongRequest() {
        let serverResponse = ServerResponse.wrongRequest
        let result: CoinMarketDataModel? = self.instance.deserialize(serverResponse: serverResponse)
        XCTAssertNil(result, "result should be nil")
    }
}
