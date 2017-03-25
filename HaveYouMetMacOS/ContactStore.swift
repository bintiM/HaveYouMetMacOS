//
//  Contacts.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 03.03.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Foundation
import Contacts

@available(OSX 10.11, *)
public class newContactStore {

    static var store = CNContactStore()
    static var contacts: [MyCNContact] = []
    static var contactsToShow:[MyCNContact] = []
    
    static func getContactsCN() {
        AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
            if accessGranted {
                
                   do {
                        self.contacts.removeAll(keepingCapacity: false)
                        
                        // Get all the containers
                        var allContainers: [CNContainer] = []
                        do {
                            allContainers = try self.store.containers(matching: nil)
                            
                        } catch {
                            print("Error fetching containers")
                        }
                        for container in allContainers {
                            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                            let keysToFetch = [CNContactGivenNameKey,
                                               CNContactFamilyNameKey,
                                               CNContactBirthdayKey,
                                               CNContactImageDataKey,
                                               CNContactThumbnailImageDataKey,
                                               CNContactEmailAddressesKey,
                                               CNContactPostalAddressesKey,
                                               CNContactPhoneNumbersKey,
                                               CNContactUrlAddressesKey,
                                               CNContactOrganizationNameKey] as [Any]
                            
                            let foundContacts = try self.store.unifiedContacts(matching: predicate, keysToFetch:keysToFetch as! [CNKeyDescriptor])
                            
                            for contact in foundContacts {
                               contacts.append(MyCNContact(with: contact))
                            }
                            // self.contacts.append(contentsOf: foundContacts as! [MyCNContact])
                            // self.contacts.append(foundContacts as! [MyCNContact])
                            
                        }
                    
                        contacts.sort(by: {$0.surname < $1.surname})
                        contactsToShow.removeAll()
                        
                        //remove empty names
                        for contact in contacts {
                            if !contact.fullname.isEmpty {
                               contactsToShow.append(contact)
                            }
                        }

                    }
                    catch {
                        print("Unable to refetch the selected contact.")
                    }
                
            }
        })
        

            
    }
    static func checkAccessCN() -> Bool {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            return true
        case .denied, .notDetermined:
            return false
        default:
            return false
        }
    }
    
    static func filterContactsCN(by name:String) {
        
        // contactsToShow = contacts.filter { ($0.familyName.contains(name) ||  $0.givenName.contains(name)) }
        contactsToShow = contacts.filter { $0.surname.lowercased().contains(name.lowercased()) || $0.prename.lowercased().contains(name.lowercased())}
     
    }
 
}

/*
@available(OSX 10.11, *)
extension CNContact {
    public var fullname: String {
        get {
            // just return space if there is a givenname
            if (givenName.isEmpty) {
                return familyName
            }
            else {
                return givenName + " " + familyName
            }
            
           // return CNContactFormatter.string(from: this, style: .fullName)
        }
    }
}
*/

public protocol Contact {
    var prename:String {get}
    var surname:String {get}
    var fullname:String {get}
    var image:Data? {get}
    var imageAvailable:Bool {get}
    var emails:[String] {get}
}

@available(OSX 10.11, *)
public class MyCNContact:  Contact {

    public var _contact: CNContact
    
    init(with contact:CNContact) {
        _contact = contact
    }
    
    public var surname: String {
        get {
            return _contact.familyName
        }
    }

    public var prename: String {
        get {
            return _contact.givenName
        }
    }

    public var fullname: String {
        get {
            // just return space if there is a givenname
            if (_contact.givenName.isEmpty) {
                return _contact.familyName
            }
            else {
                return _contact.givenName + " " + _contact.familyName
            }
        }
    }
    
    public var image:Data? {
        if (_contact.imageData != nil) {
            return _contact.imageData!
        }
        else {
            return Data()
        }
    }
    
    public var imageAvailable: Bool {
        if _contact.imageData != nil {
            return true
        }
        else {
            return false
        }
    }
    
    public var emails: [String] {
        get {
            var data = [String]()
            for email in _contact.emailAddresses {
                data.append(email.value as String)
            }
            return data
        }
    }
    
}

@available(OSX 10.10, *)
public class MyContact: Contact {
    
    public var fullname:String {
        get {
            return "old fullname"
        }
    }

    public var surname: String {
        get {
            return "old surname"
        }
    }

    public var prename: String {
        get {
            return "old prename"
        }
    }
    
    public var image:Data? {
        get {
            return Data()
        }
    }
    
    public var imageAvailable: Bool {
        return false
    }
    
    public var emails: [String] {
        get {
            let data = [String]()
            return data
        }
    }
    
}



protocol CStore {
    var StoreContacts:[Contact] {get}
    var StoreContactsToShow:[Contact] {get}
    static func checkAccess() -> Bool
    func getContacts()
    func filterContacts(by name:String)
}

@available(OSX 10.11, *)
public class newCStore : newContactStore, CStore {
    
    public var StoreContacts: [Contact] {
        get {
            return newContactStore.contacts
        }
    }

    public var StoreContactsToShow: [Contact] {
        get {
            return newContactStore.contactsToShow
        }
    }

    public static func checkAccess() -> Bool {
        return newContactStore.checkAccessCN()
    }
    
    public func getContacts() {
        newContactStore.getContactsCN()
    }
    
    public func filterContacts(by name: String) {
        newContactStore.filterContactsCN(by: name)
    }
    
}

@available(OSX 10.10, *)
public class oldCStore: CStore {

    public static func checkAccess() -> Bool {
        return true
    }
    
    public var StoreContacts: [Contact] {
        get {
            return [Contact]()
        }
    }
    
    public var StoreContactsToShow: [Contact] {
        get {
            return [Contact]()
        }
    }
    
    public func getContacts() {
    }
    
    public func filterContacts(by name: String) {
        //
    }
   
}



