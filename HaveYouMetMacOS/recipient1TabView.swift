//
//  recipient1TabView.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 16.04.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Cocoa

class recipient1TabView: NSViewController {

    @IBOutlet weak var buttonOutlet: NSButton!
    @IBOutlet weak var testLabel: NSTextField!
    
    var selectedRecipient: Contact? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
    }
    
    private func updateUI() {
        
        if isViewLoaded {
            if let contact = selectedRecipient {
                testLabel.stringValue = contact.fullname
            }
        }
    }
    
}
