//
//  RoundedRectView.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 16.03.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Cocoa

@IBDesignable class RoundedRectView: NSView {

    let radius: CGFloat = 10.0
    
    override func draw(_ dirtyRect: NSRect) {
        
        let path = NSBezierPath(roundedRect: NSInsetRect(bounds, radius, radius), xRadius: radius, yRadius: radius)
        NSColor.green.set()
        path.fill()
        
    }
}
