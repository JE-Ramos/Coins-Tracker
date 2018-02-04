//
//  PriceCheckerViewModel.swift
//  Coins Tracker
//
//  Created by John Ernest Ramos on 2/4/18.
//  Copyright © 2018 John Ernest Ramos. All rights reserved.
//

import Foundation

struct PriceCellModel {
    let buy: Double
    let sell: Double
    let fetchedDate: Date
    var expiry: Int
    
    init(buy: Double, sell: Double, expiry: Int) {
        self.buy = buy
        self.sell = sell
        self.expiry = expiry
        self.fetchedDate = Date()
    }
}

protocol PriceCheckerViewModelDelegate {
    func didUpdatePrice(price: PriceCellModel)
}

class PriceCheckerViewModel {
    private let delegate: PriceCheckerViewModelDelegate
    
    private var latestPrice: PriceCellModel! {
        didSet {
            self.delegate.didUpdatePrice(price: latestPrice)
        }
    }
    private var countdownTimer: CountDownTimer!
    
    var dateFormat: String = "MMM d, h:mm:ss a"
    
    init(delegate: PriceCheckerViewModelDelegate) {
        self.delegate = delegate
        countdownTimer = CountDownTimer(delegate: self)
        fetchMarketPrice()
    }
    
    /// Fetch market price every after expiry
    func fetchMarketPrice() {
        let jsonUrlString = "https://quote.coins.ph/v1/markets/BTC-PHP"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //perhaps check err
            //also perhaps check response status 200 OK
            
            guard let data = data else { return }
            
            do {
                let market = try JSONDecoder().decode(Market.self, from: data)
                print("\(market)")
                if let buy = Double(market.bid), let sell = Double(market.ask) {
                    DispatchQueue.main.async {
                        self.latestPrice = PriceCellModel(buy: buy, sell: sell, expiry: market.expiry)
                        self.countdownTimer.startFor(seconds: market.expiry)
                    }
                }
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
        }.resume()
    }
}

extension PriceCheckerViewModel: CountDownTimerDelegate {
    func onTick(remainingSeconds: Int) {
        if remainingSeconds < 0 {
            fetchMarketPrice()
            print("Price expired fetch new price")
        } else {
            //update UI
            self.latestPrice.expiry -= 1
            self.delegate.didUpdatePrice(price: self.latestPrice)
        }
    }
    
    
}

extension PriceCheckerViewModel: PriceCheckerRepresentable {
    var buy: String {
        return String(format: "%0.2f", latestPrice.buy)
    }
    
    var sell: String {
        
        return String(format: "%0.2f", latestPrice.sell)
    }
    
    var fetchedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.dateFormat
        return dateFormatter.string(from: latestPrice.fetchedDate)
    }
    var expiry: Int {
        return latestPrice.expiry
    }
    
}


