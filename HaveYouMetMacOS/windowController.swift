//
//  windowController.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 04.03.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Cocoa

class windowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        
        // hide title like contacts app
        self.window?.titlebarAppearsTransparent = true
        self.window?.isMovableByWindowBackground = true
        
        // backgroundcolor
        self.window?.backgroundColor = NSColor.white
    
        
        
    }

}
