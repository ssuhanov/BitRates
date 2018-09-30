//
//  CoinMarketDataModel.swift
//  BitRates
//
//  Created by Serge Sukhanov on 9/30/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import Foundation

// sourcery: AutoBuildable
struct CoinMarketDataModel: Codable, Equatable {
    var data: CMData?
}

// sourcery: AutoBuildable
struct CMData: Codable, Equatable {
    var the1: CMThe1?
    
    enum CodingKeys: String, CodingKey {
        case the1 = "1"
    }
}

// sourcery: AutoBuildable
struct CMThe1: Codable, Equatable {
    var lastUpdated: Int?
    var quotes: CMQuotes?
    
    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case quotes
    }
}

// sourcery: AutoBuildable
struct CMQuotes: Codable, Equatable {
    var usd: CMUsd?
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

// sourcery: AutoBuildable
struct CMUsd: Codable, Equatable {
    var price: Double?
}
