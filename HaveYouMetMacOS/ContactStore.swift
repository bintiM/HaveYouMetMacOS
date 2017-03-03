//
//  Contacts.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 03.03.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Foundation
import Contacts

public class ContactStore {
    static var store = CNContactStore()
    static var contacts: [CNContact] = []
    static var contactsToShow:[CNContact] = []
    
    static func getContacts() {
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
                            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactThumbnailImageDataKey] as [Any]
                            
                            self.contacts.append(contentsOf: try self.store.unifiedContacts(matching: predicate, keysToFetch:keysToFetch as! [CNKeyDescriptor]))
                            
                            
                        }
                    contacts.sort(by: {$0.familyName < $1.familyName})
                    contactsToShow = contacts

                    }
                    catch {
                        print("Unable to refetch the selected contact.")
                    }
                
            }
        })

    }
    
    static func filterContacts(by name:String) {
        
        // contactsToShow = contacts.filter { ($0.familyName.contains(name) ||  $0.givenName.contains(name)) }
        contactsToShow = contacts.filter { $0.familyName.lowercased().contains(name.lowercased()) || $0.givenName.lowercased().contains(name.lowercased())}
       
    }
 
}

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
        }
    }
}


