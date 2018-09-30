//
//  MainPresenter.swift
//  BitRates
//
//  Created by Serge Sukhanov on 9/30/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import Foundation

// sourcery: AutoMockable
protocol MainPresenterProtocol {
    func updateCoinMarketPrice()
    func updateCryptoComparePrice()
}

class MainPresenter {
    unowned var view: MainViewProtocol
    var networking: NetworkingProtocol
    
    init(view: MainViewProtocol, networking: NetworkingProtocol = Networking()) {
        self.view = view
        self.networking = networking
    }
}

extension MainPresenter: MainPresenterProtocol {
    func updateCoinMarketPrice() {
        self.networking.sendRequest(urlString: ApplicationConstants.CoinMarketUrl) { [weak self] (response) in
            let dataModel: CoinMarketDataModel? = DataDeserializer().deserialize(serverResponse: response)
            let the1 = dataModel?.data?.the1
            self?.handle(timestamp: the1?.lastUpdated,
                         price: the1?.quotes?.usd?.price,
                         updatePriceCompletion: self?.view.updateCoinMarketPrice,
                         showErrorCompletion: self?.view.showCoinMarketError)
        }
    }
    
    func updateCryptoComparePrice() {
        self.networking.sendRequest(urlString: ApplicationConstants.CryptoCompareUrl) { [weak self] (response) in
            let dataModel: CryptoCompareDataModel? = DataDeserializer().deserialize(serverResponse: response)
            let btcusd = dataModel?.raw?.btc?.usd
            self?.handle(timestamp: btcusd?.lastUpdate,
                         price: btcusd?.price,
                         updatePriceCompletion: self?.view.updateCryptoComparePrice,
                         showErrorCompletion: self?.view.showCryptoCompareError)
        }
    }
    
    private func handle(timestamp: Int?,
                        price: Double?,
                        updatePriceCompletion: ((Int, Double) -> Void)?,
                        showErrorCompletion: (() -> Void)?) {
        if let timestamp = timestamp, let price = price {
            updatePriceCompletion?(timestamp, price)
        } else {
            showErrorCompletion?()
        }
    }
}
