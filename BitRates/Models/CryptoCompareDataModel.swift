//
//  CryptoCompareDataModel.swift
//  BitRates
//
//  Created by Serge Sukhanov on 9/30/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import Foundation

// sourcery: AutoBuildable
struct CryptoCompareDataModel: Codable, Equatable {
    var raw: CCRaw?
    
    enum CodingKeys: String, CodingKey {
        case raw = "RAW"
    }
}

// sourcery: AutoBuildable
struct CCRaw: Codable, Equatable {
    var btc: CCBtc?
    
    enum CodingKeys: String, CodingKey {
        case btc = "BTC"
    }
}

// sourcery: AutoBuildable
struct CCBtc: Codable, Equatable {
    var usd: CCUsd?
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

// sourcery: AutoBuildable
struct CCUsd: Codable, Equatable {
    var price: Double?
    var lastUpdate: Int?
    
    enum CodingKeys: String, CodingKey {
        case price = "PRICE"
        case lastUpdate = "LASTUPDATE"
    }
}
