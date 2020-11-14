//
//  AppDelegate.swift
//  miniTimer
//
//  Created by Antonin Fontanille on 01/07/2020.
//  Copyright © 2020 Antonin Fontanille. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    enum StatusBarIcon: String {
        case empty
        case quarter
        case half
        case almostFull
        case full
        
        func image() -> NSImage {
            let icon = NSImage(named: rawValue)!
            icon.size = NSSize(width: 15, height: 15)
            return icon
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Initialize the status item bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.menu = statusBarMenu
        statusItem.button?.image = StatusBarIcon.empty.image()
    }

    func setStatusBarIcon(status: StatusBarIcon) {
        statusItem.button?.image = status.image()
        
        if status == .empty {
            // Clean up menu items
            resetMenuItems()
            
            // Update button in the settings
            if let viewController = NSApp.windows.first?.contentViewController as? ViewController {
                viewController.updateStartStopButton(with: "Start")
            }
        }
    }
    
    func setTimeLeftMenuTitle(with time: Int) {
        statusItem.menu?.items.first?.title = timeLeft(with: time)
    }
    
    func startStopTimer() {
        guard let startMenuItem = statusItem.menu?.items.filter({ $0.title == "Start" || $0.title == "Stop" }).first else { return }
        startStopTimer(startMenuItem)
    }
    
    // MARK: - IB Actions
    
    @IBAction func startStopTimer(_ sender: NSMenuItem) {
        let startTitle = "Start"
        let stopTitle = "Stop"
        
        startMenuItem = sender
        
        switch sender.title {
        
        case startTitle:
            let timer = TimeManager.sharedInstance.timer
            
            guard timer > 0 else {
                return
            }
            
            TimeManager.sharedInstance.startTimer()
            
            setStatusBarIcon(status: .full)
            
            // Insert menu item to show how much time is left
            let timeLeftMenu = NSMenuItem()
            timeLeftMenu.title = timeLeft(with: timer)
            statusItem.menu?.insertItem(timeLeftMenu, at: 0)
            
            // Update start/stop menu item
            sender.title = stopTitle
            
            // Update button in the settings
            if let viewController = NSApp.windows.first?.contentViewController as? ViewController {
                viewController.updateStartStopButton(with: stopTitle)
            }
            
        case stopTitle:
            TimeManager.sharedInstance.stopTimer(playSound: false)
            setStatusBarIcon(status: .empty)
            
        default:
            break
        }
    }
    
    @IBAction func showSettings(_ sender: Any) {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.windows.first?.makeKeyAndOrderFront(nil)
    }
    
    @IBAction func quitAction(_ sender: Any) {
        NSApp.terminate(nil)
    }
    
    // MARK: - Private vars & methods

    private var statusItem: NSStatusItem!
    
    @IBOutlet weak private var statusBarMenu: NSMenu!
    
    weak private var startMenuItem: NSMenuItem?
    
    private func resetMenuItems() {
        // Remove menu item to show how much time is left
         statusItem.menu?.removeItem(at: 0)
         
         // Update start/stop menu item
         startMenuItem?.title = "Start"
    }
    
    private func timeLeft(with time: Int) -> String {
        return "\(time) s left"
    }
}

