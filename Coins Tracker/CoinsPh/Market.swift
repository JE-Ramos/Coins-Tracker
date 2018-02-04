//
//  Market.swift
//  Coins Tracker
//
//  Created by John Ernest Ramos on 2/4/18.
//  Copyright © 2018 John Ernest Ramos. All rights reserved.
//

import Foundation

//{"market":{"symbol":"BTC-PHP","currency":"PHP","product":"BTC","bid":"444912","ask":"462979","expires_in_seconds":27}}
struct Market: Decodable {
    
    let bid: String
    let ask: String
    let expiry: Int
    
    
    
    enum MarketKeys: String, CodingKey {
        case container = "market"
        case bid
        case ask
        case expiry = "expires_in_seconds"
    }
    
    init(bid: String, ask: String, expiry: Int) {
        self.bid = bid
        self.ask = ask
        self.expiry = expiry
    }
    
    init(from decoder: Decoder) throws {
        let mainContainer = try decoder.container(keyedBy: MarketKeys.self) // defining our (keyed) container
        let marketContainer = try mainContainer.nestedContainer(keyedBy: MarketKeys.self, forKey: .container)
        
        let bid = try marketContainer.decode(String.self, forKey: .bid)
        let ask = try marketContainer.decode(String.self, forKey: .ask)
        let expiry = try marketContainer.decode(Int.self, forKey: .expiry)
        
        self.init(bid: bid, ask: ask, expiry: expiry)
        
    }
    
    
}
