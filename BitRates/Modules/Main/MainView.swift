//
//  MainView.swift
//  BitRates
//
//  Created by Serge Sukhanov on 9/29/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import UIKit
import SwiftCharts

// sourcery: AutoMockable
protocol MainViewProtocol: class {
    func updateChart(prices: [DB_Prices])
    func showError()
    func enableRefreshButton()
    func disableRefreshButton()
}

class MainView: UIViewController {
    var presenter: MainPresenterProtocol!
    
    var chartView: ChartView?
    @IBOutlet weak var refreshButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.presenter = MainPresenter(view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.updatePrices(disableRefresh: false)
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        self.presenter.updatePrices(disableRefresh: true)
    }
}

extension MainView: MainViewProtocol {
    func updateChart(prices: [DB_Prices]) {
        if prices.isEmpty {
            return
        }
        let firstPrice = prices[0]
        var minPrice: Double = min(firstPrice.cmPrice, firstPrice.ccPrice)
        var maxPrice: Double = max(firstPrice.cmPrice, firstPrice.ccPrice)
        var cmChartPoints: [(Double, Double)] = []
        var ccChartPoints: [(Double, Double)] = []
        prices.enumerated().forEach {
            minPrice = min(min($1.cmPrice, $1.ccPrice), minPrice)
            maxPrice = max(max($1.cmPrice, $1.ccPrice), maxPrice)
            cmChartPoints.append((Double($0), $1.cmPrice))
            ccChartPoints.append((Double($0), $1.ccPrice))
        }
        
        let chartConfig = ChartConfigXY(
            xAxisConfig: ChartAxisConfig(from: 0, to: Double(prices.count), by: 1),
            yAxisConfig: ChartAxisConfig(from: minPrice-2.0, to: maxPrice+2.0, by: 1)
        )
        
        let frame = CGRect(x: 0, y: 70, width: 300, height: 500)
        
        let chart = LineChart(
            frame: frame,
            chartConfig: chartConfig,
            xTitle: "X axis",
            yTitle: "Y axis",
            lines: [
                (chartPoints: cmChartPoints, color: UIColor.red),
                (chartPoints: ccChartPoints, color: UIColor.blue)
            ]
        )
        DispatchQueue.main.async {
            self.chartView?.removeFromSuperview()
            self.chartView = chart.view
            self.view.addSubview(chart.view)
            self.view.bringSubview(toFront: self.refreshButton)
        }
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
