//
//  DataDeserializer.swift
//  BitRates
//
//  Created by Serge Sukhanov on 9/30/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import Foundation

class DataDeserializer {
    func deserialize<T: Decodable>(serverResponse: ServerResponse) -> T? {
        switch serverResponse {
        case .success(let data):
            return data.flatMap { try? JSONDecoder().decode(T.self, from: $0) }
        default:
            return nil
        }
    }
}
