//
//  TimeManager.swift
//  miniTimer
//
//  Created by Antonin Fontanille on 02/07/2020.
//  Copyright © 2020 Antonin Fontanille. All rights reserved.
//

import Cocoa

/// Singleton class to manage the timer
class TimeManager {
    
    static let sharedInstance = TimeManager()

    var timer = 0
    
    var ticking = 0

    var tickingEnabled: Bool = false
    
    func startTimer() {
        currentTime = timer
        scheduledTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            self.updateTime()
        }
        RunLoop.current.add(scheduledTimer!, forMode: .common)
    }
    
    func stopTimer(playSound: Bool = true) {
        scheduledTimer?.invalidate()
        scheduledTimer = nil
        
        if playSound {
            NSSound(named: "Glass")?.play()
        }
    }
    
    // MARK: - Private vars & methods
    
    private var scheduledTimer: Timer?
    
    private var currentTime = 0
    
    private var appDelegate: AppDelegate {
        return NSApp.delegate as! AppDelegate
    }
    
    private init() {}
    
    private func updateTime() {
        let quarter = Int(0.25 * TimeInterval(timer))
        let half = Int(0.5 * TimeInterval(timer))
        let almostFull = Int(0.75 * TimeInterval(timer))
        
        // One second elapsed
        currentTime -= 1
        
        // Update menu item to show how much time is left
        appDelegate.setTimeLeftMenuTitle(with: currentTime)
        
        // Update status bar icon
        switch currentTime
        {
            case let t where t <= almostFull && t > half:
                appDelegate.setStatusBarIcon(status: .almostFull)
            case let t where t <= half && t > quarter:
                appDelegate.setStatusBarIcon(status: .half)
            case let t where t <= quarter && t >= 1:
                appDelegate.setStatusBarIcon(status: .quarter)
            case 0:
                // Time's up
                appDelegate.setStatusBarIcon(status: .empty)
                stopTimer()
            default:
                appDelegate.setStatusBarIcon(status: .full)
        }
        
        if tickingEnabled, currentTime <= ticking {
            // Tic tac, tic tac...
            NSSound(named: "Tink")?.play()
        }
    }
}
