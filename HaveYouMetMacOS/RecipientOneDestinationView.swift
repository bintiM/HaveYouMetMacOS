//
//  RecipientOneDestinationView.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 16.03.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Cocoa
import Contacts

protocol RecipientOneDestinationViewDelegate {
    func processContact(_ indexSet: NSIndexSet)
}

class RecipientOneDestinationView: NSView {
    
    enum Appearance {
        static let lineWidth: CGFloat = 10.0
    }
    var isReceivingDrag = false {
        didSet {
            needsDisplay = true
        }
    }
    var delegate: RecipientOneDestinationViewDelegate?
    
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
        let allow = shouldAllowDrag(sender)
        return allow
    }
    
    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        
        isReceivingDrag = false
        let pasteBoard = draggingInfo.draggingPasteboard()

        if let types = pasteBoard.types, types.contains(ContactDrag.type) {
            
            let data:NSData = draggingInfo.draggingPasteboard().data(forType: ContactDrag.type)! as NSData
            let rowIndexes:NSIndexSet = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! NSIndexSet

            delegate?.processContact(rowIndexes)
            return true
        }
            
        return false
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if isReceivingDrag {
            NSColor.selectedControlColor.set()
            
            let path = NSBezierPath(rect:bounds)
            path.lineWidth = Appearance.lineWidth
            path.stroke()
        }
    }
    
    //this view should appear transparent to mouse clicks
    override func hitTest(_ aPoint: NSPoint) -> NSView? {
        return nil
    }
}
