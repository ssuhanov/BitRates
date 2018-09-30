//
//  CoinMarketDataModel.swift
//  BitRates
//
//  Created by Serge Sukhanov on 9/30/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import Foundation

struct CMDataModel: Codable, Equatable {
    var data: CMData?
}

struct CMData: Codable, Equatable {
    var the1: CMThe1?
    
    enum CodingKeys: String, CodingKey {
        case the1 = "1"
    }
}

struct CMThe1: Codable, Equatable {
    var lastUpdated: Int?
    var quotes: CMQuotes?
    
    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case quotes
    }
}

struct CMQuotes: Codable, Equatable {
    var usd: CMUsd?
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

struct CMUsd: Codable, Equatable {
    var price: Double?
}
