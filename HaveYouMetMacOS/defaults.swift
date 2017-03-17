//
//  defaults.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 04.03.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Foundation


struct Defaults {
    static let recipientOne = "Drag Recipient here"
    static let recipientTwo = "Drag Recipient here"
    static let radius: CGFloat = 10.0
    
    static let placeholderImage = "placeholder_contact_rounded_45px.png"
}

enum ContactDrag {
    static let type = "mb.HaveYouMetMacOS.ContactAction"
    static let action = "DragContact"
}
