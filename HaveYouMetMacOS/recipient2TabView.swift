//
//  recipient2TabView.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 16.04.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Cocoa

class recipient2TabView: NSViewController {

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
                
            }
        }
    }
    
}
