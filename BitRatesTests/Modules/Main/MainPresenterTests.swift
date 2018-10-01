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
    var coinMarketPriceGetterMock: PriceGetterProtocolMock!
    var cryptoComparePriceGetterMock: PriceGetterProtocolMock!
    
    var coinMarketPriceWithTimestamp: PriceWithTimestamp?
    var cryptoComparePriceWithTimestamp: PriceWithTimestamp?

    let correctCoinMarketTimestamp: Int = 12345678
    let correctCoinMarketPrice: Double = 123456.654321
    let correctCryptoCompareTimestamp: Int = 865432
    let correctCryptoComparePrice: Double = 76543.234567

    override func setUp() {
        super.setUp()

        self.viewMock = MainViewProtocolMock()
        self.coinMarketPriceGetterMock = PriceGetterProtocolMock()
        when(self.coinMarketPriceGetterMock).getPriceCompletion().then { (completion) in
            completion?(self.coinMarketPriceWithTimestamp)
        }
        self.cryptoComparePriceGetterMock = PriceGetterProtocolMock()
        when(self.cryptoComparePriceGetterMock).getPriceCompletion().then { (completion) in
            completion?(self.cryptoComparePriceWithTimestamp)
        }
        self.instance = MainPresenter(view: self.viewMock,
                                      coinMarketPriceGetter: self.coinMarketPriceGetterMock,
                                      cryptoComparePriceGetter: self.cryptoComparePriceGetterMock)
    }
    
    func testCoinMarketPriceGetterCalled() {
        self.instance.updatePrices()
        verify(self.coinMarketPriceGetterMock).getPriceCompletion()
    }
    
    func testCryptoComparePriceGetterCalled() {
        self.instance.updatePrices()
        verify(self.cryptoComparePriceGetterMock).getPriceCompletion()
    }
    
    // TODO: - implement logic tests

//    func testUpdatePricesCalledWithCorrectData() {
//        self.coinMarketPriceWithTimestamp = PriceWithTimestamp(timestamp: self.correctCoinMarketTimestamp,
//                                                               price: self.correctCoinMarketPrice)
//        self.cryptoComparePriceWithTimestamp = PriceWithTimestamp(timestamp: self.correctCryptoCompareTimestamp,
//                                                                  price: self.correctCryptoComparePrice)
//        self.instance.updatePrices()
//        verify(self.viewMock).updateCoinMarketPriceTimestampPrice()
//            .timestamp(equalsTo: self.correctCoinMarketTimestamp)
//            .price(equalsTo: self.correctCoinMarketPrice)
//        verify(self.viewMock).updateCryptoComparePriceTimestampPrice()
//            .timestamp(equalsTo: self.correctCryptoCompareTimestamp)
//            .price(equalsTo: self.correctCryptoComparePrice)
//    }
//
//    func testShowErrorCalledWithoutCoinMarketData() {
//        self.coinMarketPriceWithTimestamp = nil
//        self.cryptoComparePriceWithTimestamp = PriceWithTimestamp(timestamp: self.correctCryptoCompareTimestamp,
//                                                                  price: self.correctCryptoComparePrice)
//        self.instance.updatePrices()
//        verify(self.viewMock).showError()
//    }
//
//    func testShowErrorCalledWithoutCryptoCompareData() {
//        self.coinMarketPriceWithTimestamp = PriceWithTimestamp(timestamp: self.correctCoinMarketTimestamp,
//                                                               price: self.correctCoinMarketPrice)
//        self.cryptoComparePriceWithTimestamp = nil
//        self.instance.updatePrices()
//        verify(self.viewMock).showError()
//    }
//
//    func testShowErrorCalledWithoutData() {
//        self.coinMarketPriceWithTimestamp = nil
//        self.cryptoComparePriceWithTimestamp = nil
//        self.instance.updatePrices()
//        verify(self.viewMock).showError()
//    }
}
