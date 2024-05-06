//
//  CoinData.swift
//  ByteCoin
//
//  Created by David Malpartida on 23/04/24.
//  Copyright © 2024 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable {
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
