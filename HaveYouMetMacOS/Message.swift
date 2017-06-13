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
    
    private var _outputText: NSMutableAttributedString
    private var _subject: String
    private var _html:String
    private let _originalHtml:String
    
    // returns the private html version as attributed String
    var text: NSMutableAttributedString {
        get {
            do {
                _outputText = try NSMutableAttributedString(data: _html.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
            } catch {
                _outputText = NSMutableAttributedString()
                
                print("Can't initialize default values for message text")
            }
            return _outputText
        }
        set {
            _outputText = newValue
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
            _outputText = try NSMutableAttributedString(data: Defaults.mailText1.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
        } catch {
            _outputText = NSMutableAttributedString()
            
            print("Can't initialize default values for message text")
        }
        
        _subject = Defaults.mailSubject
        
        _originalHtml = Defaults.mailText1
        _html = _originalHtml
    }
    
    // replace all [name1],.. etc with contact information
    func generateMessage(contact1:Contact, contact2:Contact) -> NSMutableAttributedString {

        //reset to original HTML Text Version
        _html = _originalHtml
        
        //first delete initiative sentence from contact not initiative
        if contact1.initiative {
            _html = _html.replacingOccurrences(of: "<p style=\"font-family:Helvetica\">@ [Titel2] [familyname2]: darf ich [SieDu2_2] bitten, dass [SieDu2] in der nächsten Zeit mit [fullname1] Kontakt aufnehmen, um ein persönliches Treffen zu vereinbaren / das weitere Vorgehen zu definieren?</p>", with: "")
        }
        if contact2.initiative {
            _html = _html.replacingOccurrences(of: "<p style=\"font-family:Helvetica\">@ [Titel1] [familyname1]: darf ich [SieDu1_2] bitten, dass [SieDu1] in nächster Zeit mit [fullname2] Kontakt aufnehmen, um ein persönliches Treffen zu vereinbaren / das weitere Vorgehen zu definieren?</p>", with: "")
        }
        
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
            _subject = _subject.replacingOccurrences(of: "[fullname1]", with: contact1.fullname)
        }
        if !contact2.fullname.isEmpty {
            _html = _html.replacingOccurrences(of: "[fullname2]", with: contact2.fullname)
            _subject = _subject.replacingOccurrences(of: "[fullname2]", with: contact2.fullname)
        }
        
        //selected email
        
        _html = _html.replacingOccurrences(of: "[email1]", with: contact1.selectedEmail)
        _html = _html.replacingOccurrences(of: "[email2]", with: contact2.selectedEmail)
        
        //organization
        if !contact1.organizationName.isEmpty {
            _html = _html.replacingOccurrences(of: "Firma [organizationName1]", with: contact1.organizationName)
            _html = _html.replacingOccurrences(of: "[organizationName1]", with: contact1.organizationName)
            _subject = _subject.replacingOccurrences(of: "[organizationName1]", with: contact1.organizationName)
        }
        if !contact2.organizationName.isEmpty {
            _html = _html.replacingOccurrences(of: "Firma [organizationName2]", with: contact2.organizationName)
            _html = _html.replacingOccurrences(of: "[organizationName2]", with: contact2.organizationName)
            _subject = _subject.replacingOccurrences(of: "[organizationName2]", with: contact2.organizationName)
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

        //FristNameBasis
        
        if contact1.firstNameBasis {
            _html = _html.replacingOccurrences(of: "[SieDu1]", with: Defaults.PronounfirstNameBasis)
            _html = _html.replacingOccurrences(of: "[SieDu1_2]", with: Defaults.Pronoun2firstNameBasis)
        }
        else {
            _html = _html.replacingOccurrences(of: "[SieDu1]", with: Defaults.Pronoun)
            _html = _html.replacingOccurrences(of: "[SieDu1_2]", with: Defaults.Pronoun2)
        }
        
        if contact2.firstNameBasis {
            _html = _html.replacingOccurrences(of: "[SieDu2]", with: Defaults.PronounfirstNameBasis)
            _html = _html.replacingOccurrences(of: "[SieDu2_2]", with: Defaults.Pronoun2firstNameBasis)
        }
        else {
            _html = _html.replacingOccurrences(of: "[SieDu2]", with: Defaults.Pronoun)
            _html = _html.replacingOccurrences(of: "[SieDu2_2]", with: Defaults.Pronoun2)
        }
        

        //Gender Recipient1
        
        //replace Salutations
        if contact1.gender == Gender.male {
            if contact1.firstNameBasis {
                _html = _html.replacingOccurrences(of: "[Anrede1]", with: Defaults.salutationMaleFirstNameBasis)
            }
            else {
                _html = _html.replacingOccurrences(of: "[Anrede1]", with: Defaults.salutationMale)
            }
        }
        else if contact1.gender == Gender.female {
            if contact1.firstNameBasis {
                _html = _html.replacingOccurrences(of: "[Anrede1]", with: Defaults.salutationFemaleFirstNameBasis)
            }
            else {
                _html = _html.replacingOccurrences(of: "[Anrede1]", with: Defaults.salutationFemale)
            }
        }
        if contact2.gender == Gender.male {
            if contact2.firstNameBasis {
                _html = _html.replacingOccurrences(of: "[Anrede2]", with: Defaults.salutationMaleFirstNameBasis2)
            }
            else {
                _html = _html.replacingOccurrences(of: "[Anrede2]", with: Defaults.salutationMale2)
            }
        }
        else if contact2.gender == Gender.female {
            if contact2.firstNameBasis {
                _html = _html.replacingOccurrences(of: "[Anrede2]", with: Defaults.salutationFemaleFirstNameBasis2)
            }
            else {
                _html = _html.replacingOccurrences(of: "[Anrede2]", with: Defaults.salutationFemale2)
            }
        }
        
        // Titles
        
        // if no title available
        if contact1.prefix.isEmpty {
            if contact1.gender == Gender.male {
                _html = _html.replacingOccurrences(of: "[Titel1]", with: Defaults.titleMale)
            }
            else if contact1.gender == Gender.female {
                _html = _html.replacingOccurrences(of: "[Titel1]", with: Defaults.titleFemale)
            }
        }
        if contact2.prefix.isEmpty {
            if contact2.gender == Gender.male {
                _html = _html.replacingOccurrences(of: "[Titel2]", with: Defaults.titleMale)
            }
            else if contact2.gender == Gender.female {
                _html = _html.replacingOccurrences(of: "[Titel2]", with: Defaults.titleFemale)
            }
        }
        
        //generate AttributedString Version
        do {
            _outputText = try NSMutableAttributedString(data: _html.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
        } catch {
            _outputText = NSMutableAttributedString()
            
            print("Can't convert html message text to attributed string")
        }
        
        return _outputText
    }

    
    func resetMessage() -> NSMutableAttributedString {
        
        _subject = Defaults.mailSubject
        
        do {
            _outputText = try NSMutableAttributedString(data: Defaults.mailText1.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
        } catch {
            _outputText = NSMutableAttributedString()
            print("Can't convert html message text to attributed string")
        }
        return _outputText
    }
    
}
