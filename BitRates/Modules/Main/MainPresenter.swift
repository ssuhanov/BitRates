//
//  MainPresenter.swift
//  BitRates
//
//  Created by Serge Sukhanov on 9/30/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import Foundation

private let Timeout: TimeInterval = 60.0

// sourcery: AutoMockable
protocol MainPresenterProtocol {
    func updatePrices()
}

class MainPresenter {
    unowned var view: MainViewProtocol
    
    var coinMarketPriceWithTimestamp: PriceWithTimestamp?
    var cryptoComparePriceWithTimestamp: PriceWithTimestamp?
    
    var coinMarketPriceGetter: PriceGetterProtocol
    var cryptoComparePriceGetter: PriceGetterProtocol
    
    init(view: MainViewProtocol,
         coinMarketPriceGetter: PriceGetterProtocol = CoinMarketPriceGetter(),
         cryptoComparePriceGetter: PriceGetterProtocol = CryptoComparePriceGetter()) {
        self.view = view
        self.coinMarketPriceGetter = coinMarketPriceGetter
        self.cryptoComparePriceGetter = cryptoComparePriceGetter
    }
}

extension MainPresenter: MainPresenterProtocol {
    func updatePrices() {
        
        let group = DispatchGroup()
        
        group.enter()
        self.coinMarketPriceGetter.getPrice { [weak self] (priceWithTimestamp) in
            priceWithTimestamp.map { self?.coinMarketPriceWithTimestamp = $0 }
            group.leave()
        }
        
        group.enter()
        self.cryptoComparePriceGetter.getPrice { [weak self] (priceWithTimestamp) in
            priceWithTimestamp.map { self?.cryptoComparePriceWithTimestamp = $0 }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            if let coinMarketPriceWithTimestamp = self?.coinMarketPriceWithTimestamp, let cryptoComparePriceWithTimestamp = self?.cryptoComparePriceWithTimestamp {
                DB_Prices.create(timestamp: max(coinMarketPriceWithTimestamp.timestamp, cryptoComparePriceWithTimestamp.timestamp),
                                 coinMarketPrice: coinMarketPriceWithTimestamp.price,
                                 cryptoComparePrice: cryptoComparePriceWithTimestamp.price) { _ in
                                    // TODO: - show graph on UI with DB_Prices.fetchAllByTimestamp()
                                    
                }
                self?.view.updateCoinMarketPrice(timestamp: coinMarketPriceWithTimestamp.timestamp,
                                                 price: coinMarketPriceWithTimestamp.price)
                self?.view.updateCryptoComparePrice(timestamp: cryptoComparePriceWithTimestamp.timestamp,
                                                    price: cryptoComparePriceWithTimestamp.price)
                self?.view.disableRefreshButton()
                DispatchQueue.main.asyncAfter(deadline: .now() + Timeout, execute: {
                    self?.view.enableRefreshButton()
                })
            } else {
                self?.view.showError()
            }
        }
    }
}
