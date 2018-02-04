//
//  CountdownTimer.swift
//  Coins Tracker
//
//  Created by John Ernest Ramos on 2/4/18.
//  Copyright © 2018 John Ernest Ramos. All rights reserved.
//

import Foundation

@objc protocol CountDownTimerDelegate {
    @objc func onTick(remainingSeconds: Int)
}

class CountDownTimer {
    private var maxSeconds: Int = 0
    private var seconds: Int = 0
    
    private var timer: Timer?
    
    private let delegate: CountDownTimerDelegate
    
    init(delegate: CountDownTimerDelegate) {
        self.delegate = delegate
    }
    
    
    /// Starts the countdown timer
    func startFor(seconds: Int) {
        
        self.maxSeconds = seconds
        self.seconds = maxSeconds
        guard timer == nil else {
            
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerUpdate), userInfo: nil, repeats: true)
        
        
        
    }
    
    @objc private func onTimerUpdate() {
        seconds -= 1
        if seconds < 0 {
            stop()
        }
        
        DispatchQueue.main.async {
            self.delegate.onTick(remainingSeconds: self.seconds)
        }
    }
    
    func stop() {
        guard timer != nil else {
            return
        }
        timer?.invalidate()
        timer = nil
    }
    
    func reset() {
        self.seconds = maxSeconds
        stop()
    }
}
