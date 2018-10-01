//
//  DB_Prices.swift
//  BitRates
//
//  Created by Serge Sukhanov on 10/1/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import Foundation

typealias DB_PricesResultCompletion = (DB_Prices?) -> Void

extension DB_Prices {
    static func create(timestamp: Int,
                       coinMarketPrice: Double,
                       cryptoComparePrice: Double,
                       completion: DB_PricesResultCompletion?) {
        
        DB_Prices.create().map { entity in
            entity.timestamp = Int64(timestamp)
            entity.cmPrice = coinMarketPrice
            entity.ccPrice = cryptoComparePrice
            
            CoreDataManager.shared.saveContext(completion: { (contextDidSave, _) in
                if contextDidSave {
                    completion?(entity)
                } else {
                    completion?(nil)
                }
            })
        }
    }
    
    static func fetchAllByTimestamp() -> [DB_Prices]? {
        return DB_Prices.findAll(sortedBy: "timestamp") as? [DB_Prices]
    }
}
