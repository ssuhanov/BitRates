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
    func updateCryptoComparePrice(timestamp: Int, price: Double)
    func showError()
    func enableRefreshButton()
    func disableRefreshButton()
}

class MainView: UIViewController {
    var presenter: MainPresenterProtocol!
    
    @IBOutlet weak var coinMarketLabel: UILabel!
    @IBOutlet weak var cryptoCompareLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
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
        self.coinMarketLabel.text = "Coin Market: updating..."
        self.cryptoCompareLabel.text = "Crypto Compare: updating..."
        self.presenter.updatePrices()
    }
}

extension MainView: MainViewProtocol {
    func updateCoinMarketPrice(timestamp: Int, price: Double) {
        DispatchQueue.main.async {
            self.coinMarketLabel.text = "Coin Market:\ntimestamp: \(timestamp)\nprice: \(price)"
        }
    }
    
    func updateCryptoComparePrice(timestamp: Int, price: Double) {
        DispatchQueue.main.async {
            self.cryptoCompareLabel.text = "Crypto Compare:\ntimestamp: \(timestamp)\nprice: \(price)"
        }
    }
    
    func showError() {
        DispatchQueue.main.async {
            self.coinMarketLabel.text = "Coin Market: error"
            self.cryptoCompareLabel.text = "Crypto Compare: error"
        }
    }
    
    func enableRefreshButton() {
        DispatchQueue.main.async {
            self.refreshButton.isEnabled = true
        }
    }
    
    func disableRefreshButton() {
        DispatchQueue.main.async {
            self.refreshButton.isEnabled = false
        }
    }
}
