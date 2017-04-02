//
//  message.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 02.04.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Foundation
import Cocoa

public class Message {
    
    private var _text: NSMutableAttributedString
    private var _subject: String
    private var _html:String
    
    // returns the private html version as attributed String
    var text: NSMutableAttributedString {
        get {
            do {
                _text = try NSMutableAttributedString(data: _html.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
            } catch {
                _text = NSMutableAttributedString()
                
                print("Can't initialize default values for message text")
            }
            return _text
        }
        set {
            _text = newValue
        }
    }
    
    var subject: String {
        get {
            return _subject
        }
        set {
            _subject = newValue
        }
    }
    
   
    init() {
        do {
            _text = try NSMutableAttributedString(data: Defaults.mailText1.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
        } catch {
            _text = NSMutableAttributedString()
            
            print("Can't initialize default values for message text")
        }
        
        _subject = Defaults.mailSubject
        _subject = ""
        _html = Defaults.mailText1
    }
    
    // replace all [name1],.. etc with contact information
    func processMessage(contact1:Contact, selectedMail1:String, contact2:Contact, selectedMail2:String) -> NSMutableAttributedString {

        //familyname
        if !contact1.surname.isEmpty {
            _html = _html.replacingOccurrences(of: "[familyname1]", with: contact1.surname)
        }

        
        if !contact2.surname.isEmpty {
            _html = _html.replacingOccurrences(of: "[familyname2]", with: contact2.surname)
        }
        
        //fullname
        if !contact1.fullname.isEmpty {
            _html = _html.replacingOccurrences(of: "[fullname1]", with: contact1.fullname)
        }
        if !contact2.fullname.isEmpty {
            _html = _html.replacingOccurrences(of: "[fullname2]", with: contact2.fullname)
        }
        
        //selected email
        
        _html = _html.replacingOccurrences(of: "[email1]", with: selectedMail1)
        _html = _html.replacingOccurrences(of: "[email2]", with: selectedMail2)
        
        //organization
        if !contact1.organizationName.isEmpty {
            _html = _html.replacingOccurrences(of: "[organizationName1]", with: contact1.organizationName)
        }
        if !contact2.organizationName.isEmpty {
            _html = _html.replacingOccurrences(of: "[organizationName1]", with: contact2.organizationName)
        }
        
        //address
        
        _html = _html.replacingOccurrences(of: "[address1]", with: "\(contact1.street)\n\(contact1.postalCode) \(contact1.city)")
        
        _html = _html.replacingOccurrences(of: "[address2]", with: "\(contact2.street)\n\(contact2.postalCode) \(contact2.city)")
        
        
        //phones
        if let phoneNumber = contact1.phone.first {
            _html = _html.replacingOccurrences(of: "[phone1]", with: phoneNumber)
        }
        if let phoneNumber2 = contact2.phone.first {
            _html = _html.replacingOccurrences(of: "[phone2]", with: phoneNumber2)
        }
        
        
        //urls
        if let url1 = contact1.url.first {
            _html = _html.replacingOccurrences(of: "[url1]", with: url1)
        }
        if let url2 = contact2.url.first {
            _html = _html.replacingOccurrences(of: "[url2]", with: url2)
        }

        do {
            _text = try NSMutableAttributedString(data: _html.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
        } catch {
            _text = NSMutableAttributedString()
            
            print("Can't convert html message text to attributed string")
        }
        
        return _text
    }

    
}
