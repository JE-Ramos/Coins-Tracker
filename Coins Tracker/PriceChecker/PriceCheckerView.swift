//
//  PriceCheckerView.swift
//  Coins Tracker
//
//  Created by John Ernest Ramos on 2/4/18.
//  Copyright © 2018 John Ernest Ramos. All rights reserved.
//

import Foundation
import UIKit

protocol PriceCheckerRepresentable {
    var buy: String { get }
    var sell: String { get }
    var fetchedDate: String { get }
    var expiry: Int { get }
}

class PriceCheckerView: UIView {
    
    private static let updatedDate =  "Updated:"
    
    var representable: PriceCheckerRepresentable? {
        didSet {
            buyLabel.text = representable?.buy
            sellLabel.text = representable?.sell
            lastUpdatedLabel.text = "\(PriceCheckerView.updatedDate) \(representable!.fetchedDate) Expires In: \(representable!.expiry)"
        }
    }
    
    ///shows the current bid / buy price
    @IBOutlet weak var buyLabel: UILabel!
    
    ///shows the current ask / sell price
    @IBOutlet weak var sellLabel: UILabel!
    
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("Init")
        setupView()
    }
    
    private func setupView() {
        
    }
}
