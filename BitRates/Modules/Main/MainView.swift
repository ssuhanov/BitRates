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
    
    @IBOutlet weak var CoinMarketLabel: UILabel!
    @IBOutlet weak var CryptoCompareLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.presenter = MainPresenter(view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updatePrices()
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        self.updatePrices()
    }
    
    private func updatePrices() {
        self.CoinMarketLabel.text = "Coin Market: updating..."
        self.CryptoCompareLabel.text = "Crypto Compare: updating..."
        self.presenter.updateCoinMarketPrice()
        self.presenter.updateCryptoComparePrice()
    }
}

extension MainView: MainViewProtocol {
    func updateCoinMarketPrice(timestamp: Int, price: Double) {
        DispatchQueue.main.async {
            self.CoinMarketLabel.text = "Coin Market:\ntimestamp: \(timestamp)\nprice: \(price)"
        }
    }
    
    func showCoinMarketError() {
        DispatchQueue.main.async {
            self.CoinMarketLabel.text = "Coin Market: error"
        }
    }
    
    func updateCryptoComparePrice(timestamp: Int, price: Double) {
        DispatchQueue.main.async {
            self.CryptoCompareLabel.text = "Crypto Compare:\ntimestamp: \(timestamp)\nprice: \(price)"
        }
    }
    
    func showCryptoCompareError() {
        DispatchQueue.main.async {
            self.CryptoCompareLabel.text = "Crypto Compare: error"
        }
    }
}
