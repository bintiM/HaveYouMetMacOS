//
//  RecipientOneDestinationView.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 16.03.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Cocoa
import Contacts

protocol RecipientTwoDestinationViewDelegate {
    func processContactTwo(_ indexSet: NSIndexSet)
}

class RecipientTwoDestinationView: NSView {
    
    enum Appearance {
        static let lineWidth: CGFloat = 10.0
    }
    var isReceivingDrag = false {
        didSet {
            needsDisplay = true
        }
    }
    var delegate: RecipientTwoDestinationViewDelegate?
    
    var acceptableTypes: [String] = [ContactDrag.type]
    
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        register(forDraggedTypes: acceptableTypes)
    }
    
    
    // MARK: dragging funcs
    
    func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
        
        var canAccept = false
        let pasteBoard = draggingInfo.draggingPasteboard()
        
        if pasteBoard.canReadItem(withDataConformingToTypes: acceptableTypes) {
            canAccept = true
        }
        
        return canAccept
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let allow = shouldAllowDrag(sender)
        isReceivingDrag = allow
        return allow ? .copy : NSDragOperation()
    }
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        NSLog("Should allow Drag")
        let allow = shouldAllowDrag(sender)
        return allow
    }
    
    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        
        isReceivingDrag = false
        let pasteBoard = draggingInfo.draggingPasteboard()
        
        if let types = pasteBoard.types, types.contains(ContactDrag.type) {
            
            let data:NSData = draggingInfo.draggingPasteboard().data(forType: ContactDrag.type)! as NSData
            let rowIndexes:NSIndexSet = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! NSIndexSet
            
            delegate?.processContactTwo(rowIndexes)
            return true
        }
        
        return false
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if isReceivingDrag {
            NSColor.selectedControlColor.set()
            
            let path = NSBezierPath(roundedRect: NSInsetRect(bounds, 0.0, 0.0), xRadius: Defaults.radius, yRadius: Defaults.radius)
            NSColor.darkGray.set()
            path.lineWidth = 2
            //path.setLineDash([5.0,2.0], count: 2, phase: 0.0)
            path.stroke()
        }
    }
    
    //this view should appear transparent to mouse clicks
    override func hitTest(_ aPoint: NSPoint) -> NSView? {
        return nil
    }
}
