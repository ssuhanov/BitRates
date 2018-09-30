//
//  MainView.swift
//  BitRates
//
//  Created by Serge Sukhanov on 9/29/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import UIKit

// sourcery: AutoMockable
protocol MainViewProtocol: class {
    func updateCoinMarketPrice(timestamp: Int, price: Double)
    func showCoinMarketError()
    func updateCryptoComparePrice(timestamp: Int, price: Double)
    func showCryptoCompareError()
}

class MainView: UIViewController {
    var presenter: MainPresenterProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.presenter = MainPresenter(view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.updateCoinMarketPrice()
        self.presenter.updateCryptoComparePrice()
    }
}

extension MainView: MainViewProtocol {
    func updateCoinMarketPrice(timestamp: Int, price: Double) {
        // TODO: - update coin market price on UI here
    }
    
    func showCoinMarketError() {
        // TODO: - show coin market error here
    }
    
    func updateCryptoComparePrice(timestamp: Int, price: Double) {
        // TODO: - update crypto compare price on UI here
    }
    
    func showCryptoCompareError() {
        // TODO: - show crypto compare error here
    }
}
