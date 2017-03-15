//
//  contactTableCellView.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 03.03.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Cocoa

class contactTableCellView: NSTableCellView {

    
    @IBOutlet weak var contactImageViewOutlet: NSImageView!    
    @IBOutlet weak var contactNameTextFieldOutlet: NSTextField!
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        contactImageViewOutlet.layer?.cornerRadius = (contactImageViewOutlet.layer?.frame.width)! / 2
        
    }
    
    
    
}
