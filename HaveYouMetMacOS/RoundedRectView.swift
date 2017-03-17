//
//  RoundedRectView.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 16.03.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Cocoa

@IBDesignable class RoundedRectView: NSView {


    
    override func draw(_ dirtyRect: NSRect) {
        
        //let path = NSBezierPath(roundedRect: NSInsetRect(bounds, radius, radius), xRadius: radius, yRadius: radius)
        let path = NSBezierPath(roundedRect: NSInsetRect(bounds, 0.0, 0.0), xRadius: Defaults.radius, yRadius: Defaults.radius)
        NSColor.darkGray.set()
        path.lineWidth = 1
        path.setLineDash([5.0,2.0], count: 2, phase: 0.0)
        path.stroke()
    }
    

}
