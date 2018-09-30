//
//  MainPresenterTests.swift
//  BitRatesTests
//
//  Created by Serge Sukhanov on 9/30/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import XCTest
@testable import BitRates

class MainPresenterTests: XCTestCase {
    var instance: MainPresenter!
    var viewMock: MainViewProtocolMock!
    var networkingMock: NetworkingProtocolMock!
    
    var coinMarketDataModel: CoinMarketDataModel!
    var cryptoCompareDataModel: CryptoCompareDataModel!
    
    var serverResponse: ServerResponse = .wrongRequest
    
    let correctTimestamp: Int = 12345678
    let correctPrice: Double = 123456.654321
    
    override func setUp() {
        super.setUp()
        
        self.coinMarketDataModel = self.prepareCoinMarketDataModel()
        self.cryptoCompareDataModel = self.prepareCryptoCompareDataModel()
        
        self.viewMock = MainViewProtocolMock()
        self.networkingMock = NetworkingProtocolMock()
        when(self.networkingMock).sendRequestUrlStringCompletion().then { (_, completion) in
            completion?(self.serverResponse)
        }
        self.instance = MainPresenter(view: self.viewMock, networking: self.networkingMock)
    }
    
    private func prepareCoinMarketDataModel() -> CoinMarketDataModel {
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
    
    private func prepareCryptoCompareDataModel() -> CryptoCompareDataModel {
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
    
    // MARK: - Coin market
    
    func testNetworkingCalledForCMPriceUpdating() {
        self.instance.updateCoinMarketPrice()
        verify(self.networkingMock).sendRequestUrlStringCompletion().urlString(equalsTo: ApplicationConstants.CoinMarketUrl)
    }
    
    func testUpdateCMPriceCalledWithCorrectData() {
        let data = try? JSONEncoder().encode(self.coinMarketDataModel)
        self.serverResponse = .success(data: data)
        self.instance.updateCoinMarketPrice()
        verify(self.viewMock).updateCoinMarketPriceTimestampPrice()
            .timestamp(equalsTo: self.correctTimestamp)
            .price(equalsTo: self.correctPrice)
    }
    
    func testShowCMErrorWithoutData() {
        self.serverResponse = .success(data: nil)
        self.instance.updateCoinMarketPrice()
        verify(self.viewMock).showCoinMarketError()
    }
    
    func testShowCMErrorWithServerError() {
        self.serverResponse = .failure(error: NSError())
        self.instance.updateCoinMarketPrice()
        verify(self.viewMock).showCoinMarketError()
    }
    
    func testShowCMErrorWithWrongRequest() {
        self.serverResponse = .wrongRequest
        self.instance.updateCoinMarketPrice()
        verify(self.viewMock).showCoinMarketError()
    }
    
    // MARK: - Crypto compare
    
    func testNetworkingCalledForCCPriceUpdating() {
        self.instance.updateCryptoComparePrice()
        verify(self.networkingMock).sendRequestUrlStringCompletion().urlString(equalsTo: ApplicationConstants.CryptoCompareUrl)
    }
    
    func testUpdateCCPriceCalledWithCorrectData() {
        let data = try? JSONEncoder().encode(self.cryptoCompareDataModel)
        self.serverResponse = .success(data: data)
        self.instance.updateCryptoComparePrice()
        verify(self.viewMock).updateCryptoComparePriceTimestampPrice()
            .timestamp(equalsTo: self.correctTimestamp)
            .price(equalsTo: self.correctPrice)
    }
    
    func testShowCCErrorWithoutData() {
        self.serverResponse = .success(data: nil)
        self.instance.updateCryptoComparePrice()
        verify(self.viewMock).showCryptoCompareError()
    }
    
    func testShowCCErrorWithServerError() {
        self.serverResponse = .failure(error: NSError())
        self.instance.updateCryptoComparePrice()
        verify(self.viewMock).showCryptoCompareError()
    }
    
    func testShowCCErrorWithWrongRequest() {
        self.serverResponse = .wrongRequest
        self.instance.updateCryptoComparePrice()
        verify(self.viewMock).showCryptoCompareError()
    }

}
