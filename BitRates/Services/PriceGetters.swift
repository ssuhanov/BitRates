//
//  PriceGetters.swift
//  BitRates
//
//  Created by Serge Sukhanov on 10/1/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import Foundation

struct PriceWithTimestamp: Equatable {
    var timestamp: Int
    var price: Double
}

typealias PriceUpdateResultCompletion = (PriceWithTimestamp?) -> Void

// sourcery: AutoMockable
protocol PriceGetterProtocol {
    func getPrice(completion: PriceUpdateResultCompletion?)
}

class PriceGetter {
    var networking: NetworkingProtocol
    
    init(networking: NetworkingProtocol = Networking()) {
        self.networking = networking
    }
}

class CoinMarketPriceGetter: PriceGetter, PriceGetterProtocol {
    func getPrice(completion: PriceUpdateResultCompletion?) {
        self.networking.sendRequest(urlString: ApplicationConstants.CoinMarketUrl) { (response) in
            let dataModel: CoinMarketDataModel? = DataDeserializer().deserialize(serverResponse: response)
            let the1 = dataModel?.data?.the1
            let priceWithTimestamp: PriceWithTimestamp?
            if let timestamp = the1?.lastUpdated, let price = the1?.quotes?.usd?.price {
                priceWithTimestamp = PriceWithTimestamp(timestamp: timestamp, price: price)
            } else {
                priceWithTimestamp = nil
            }
            completion?(priceWithTimestamp)
        }
    }
}

class CryptoComparePriceGetter: PriceGetter, PriceGetterProtocol {
    func getPrice(completion: PriceUpdateResultCompletion?) {
        self.networking.sendRequest(urlString: ApplicationConstants.CryptoCompareUrl) { (response) in
            let dataModel: CryptoCompareDataModel? = DataDeserializer().deserialize(serverResponse: response)
            let btcusd = dataModel?.raw?.btc?.usd
            let priceWithTimestamp: PriceWithTimestamp?
            if let timestamp = btcusd?.lastUpdate, let price = btcusd?.price {
                priceWithTimestamp = PriceWithTimestamp(timestamp: timestamp, price: price)
            } else {
                priceWithTimestamp = nil
            }
            completion?(priceWithTimestamp)
        }
    }
}
