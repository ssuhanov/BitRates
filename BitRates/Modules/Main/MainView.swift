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
    func updateChart(prices: [DB_Prices])
    func showError()
    func enableRefreshButton()
    func disableRefreshButton()
}

class MainView: UIViewController {
    var presenter: MainPresenterProtocol!
    
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
        self.presenter.updatePrices()
    }
}

extension MainView: MainViewProtocol {
    func updateChart(prices: [DB_Prices]) {
        // TODO: - update chart here
    }
    
    func showError() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: "Something went wrong while price updating :(", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
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
