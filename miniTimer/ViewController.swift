//
//  ViewController.swift
//  miniTimer
//
//  Created by Antonin Fontanille on 01/07/2020.
//  Copyright © 2020 Antonin Fontanille. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var timerTextField: NSTextField!
    @IBOutlet weak var tickingTextField: NSTextField!
    @IBOutlet weak var startStopButton: NSButton!
    
    private enum TextField: Int {
        case timer = 1
        case ticking = 2
        
        func setValue(_ newValue: Int) {
            switch self {
            case .timer:
                TimeManager.sharedInstance.timer = newValue
            case .ticking:
                TimeManager.sharedInstance.ticking = newValue
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure TimeManager with intial settings
        TimeManager.sharedInstance.timer = timerTextField.integerValue
        TimeManager.sharedInstance.ticking = tickingTextField.integerValue
        
        // Set view controller as text fields' delegates to get user inputs
        timerTextField.delegate = self
        timerTextField.tag = TextField.timer.rawValue
        tickingTextField.delegate = self
        tickingTextField.tag = TextField.ticking.rawValue
    }
    
    func updateStartStopButton(with title: String) {
        startStopButton.title = title
    }

    // MARK: - IB Actions
    
    @IBAction func tickingCheckAction(_ sender: NSButton) {
        let tickingState = sender.state == NSControl.StateValue.on
        tickingTextField.isEnabled = tickingState
        TimeManager.sharedInstance.tickingEnabled = tickingState
    }
    
    @IBAction func startStopAction(_ sender: NSButton) {
        (NSApp.delegate as? AppDelegate)?.startStopTimer()
    }
}

extension ViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField, let target = TextField(rawValue: textField.tag) else {
            return
        }
        // Get integer inputs from text fields and update the time manager
        let newValue = textField.integerValue
        target.setValue(newValue)
        textField.stringValue = String(newValue)
    }
}
