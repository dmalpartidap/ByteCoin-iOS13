//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(rate: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "A32A645A-1BB9-4751-AE89-73E21AD3F61E"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if (error != nil) {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
//                    let rate = parseJSON(safeData)
                    if let coin = parseJSON(safeData) {
                        let rateString = String(format: "%.2f", coin.rate)
                        print(rateString, currency)
                        self.delegate?.didUpdateCoin(rate: rateString, currency: currency)
                    }
                    
                    // convert respond to String
//                    let str = String(decoding: safeData, as: UTF8.self)
//                    print(str)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(CoinData.self, from: coinData)
            let coinCrypto = decodeData.asset_id_base
            let coinCurrency = decodeData.asset_id_quote
            let coinRate = decodeData.rate
            
            let coin = CoinModel(cryptocurrency: coinCrypto, currency: coinCurrency, rate: coinRate)
            
            return coin
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
