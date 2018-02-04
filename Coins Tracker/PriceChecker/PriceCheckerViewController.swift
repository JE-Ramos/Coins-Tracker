//
//  ViewController.swift
//  Coins Tracker
//
//  Created by John Ernest Ramos on 2/4/18.
//  Copyright © 2018 John Ernest Ramos. All rights reserved.
//

import UIKit

class PriceCheckerViewController: UIViewController {

    var viewModel: PriceCheckerViewModel!
    
    var customView: PriceCheckerView {
        return self.view as! PriceCheckerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewModel = PriceCheckerViewModel(delegate: self)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension PriceCheckerViewController: PriceCheckerViewModelDelegate {
    func didUpdatePrice(price: PriceCellModel) {
        customView.representable = viewModel
    }
    
    
}

