//
//  Contacts.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 03.03.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Foundation
import Contacts
import AddressBook

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
                        NSLog("get Container data from " + container.name)
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
                                           CNContactOrganizationNameKey,
                                           CNContactNamePrefixKey] as [Any]
                        
                        let foundContacts = try self.store.unifiedContacts(matching: predicate, keysToFetch:keysToFetch as! [CNKeyDescriptor])
                        
                        for contact in foundContacts {

                            //check if contact already exists
                            var notDuplicate = true
                            for existingContact in contacts {
                                if contact.identifier == existingContact.identifier {
                                    notDuplicate = false
                                    break
                                }
                            }
                            if notDuplicate {
                                contacts.append(MyCNContact(with: contact))
                            }
                        }
                    }
                    
                    contacts.sort(by: {$0.surname < $1.surname})
                    contactsToShow.removeAll()
                    
                    //don't show empty names
                    for contact in contacts {
                        if !(contact.fullname.isEmpty)  {
                            contactsToShow.append(contact)
                        }
                    }
                    
                }
                catch {
                    print("Unable to refetch the selected contact.")
                }
                
            }
            else {
                // TODO no access to contacts pop up
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
        contactsToShow = contacts.filter { $0.surname.lowercased().contains(name.lowercased()) || $0.prename.lowercased().contains(name.lowercased()) || $0.organizationName.lowercased().contains(name.lowercased())}
    }
    
    static func resetContactList() {
        contactsToShow.removeAll()
        contactsToShow = contacts
    }
 
}


public protocol Contact {
    var prename:String {get}
    var surname:String {get}
    var prefix: String {get}
    var gender:Gender{get set}
    var firstNameBasis:Bool {get set}
    var fullname:String {get}
    var image:Data? {get}
    var imageAvailable:Bool {get}
    var emails:[String] {get}
    var selectedEmail:String {get set}
    var street:String {get}
    var postalCode:String {get}
    var city:String {get}
    var phone:[String] {get}
    var url:[String]{get}
    var organizationName:String {get}
    func getEmptyContact()->Contact
    var identifier:String {get}
}

@available(OSX 10.11, *)
public class MyCNContact:  Contact {

    private var _firstNameBasis:Bool
    private var _selectedEmail:String
    private var _gender:Gender
    public var _contact: CNContact
    
    init(with contact:CNContact) {
        _contact = contact
        _firstNameBasis = false
        _selectedEmail = ""
        _gender = Gender.male
    }
    public func getEmptyContact()->Contact {
        return self
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
    
    public var prefix:String {
        get {
            return _contact.namePrefix
        }
    }
    
    public var gender: Gender {
        get {
            return _gender;
        }
        set {
            _gender = newValue
        }
    }
    
    public var firstNameBasis: Bool {
        get {
            return _firstNameBasis;
        }
        set {
            _firstNameBasis = newValue
        }
    }

    public var fullname: String {
        get {
            
            if _contact.organizationName.contains("Test") {
                NSLog("Testfirma")
            }
            
            // if given name is empty but familyname ist present
            if (_contact.givenName.isEmpty && !_contact.familyName.isEmpty) {
                return _contact.familyName
            }
            else if (!_contact.givenName.isEmpty && _contact.familyName.isEmpty) {
                return _contact.givenName
            }
            else if (!_contact.givenName.isEmpty && !_contact.familyName.isEmpty) { // if both names are available set space between them
                return _contact.givenName + " " + _contact.familyName
            }
            else if (_contact.givenName.isEmpty && _contact.familyName.isEmpty && !_contact.organizationName.isEmpty){ // if names are empty but organizationname is available
                return _contact.organizationName
            }
            return ""
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
    
    public var selectedEmail: String {
        get {
            return _selectedEmail;
        }
        set {
            _selectedEmail = newValue
        }
    }
    
    public var street: String {
        get {
            if let postaladdress = _contact.postalAddresses.first {
                return postaladdress.value.street
            }
            else {
                return String()
            }
        }
    }
    public var city: String {
        get {
            if let postaladdress = _contact.postalAddresses.first {
                return postaladdress.value.city
            }
            else {
                return String()
            }
        }
    }
    public var postalCode: String {
        get {
            if let postaladdress = _contact.postalAddresses.first {
                return postaladdress.value.postalCode
            }
            else {
                return String()
            }
        }
    }
    public var phone: [String] {
        get {
            var data = [String]()
            for phone in _contact.phoneNumbers {
                data.append(phone.value.stringValue)
            }
            return data
        }
    }
    public var url: [String] {
        get {
            var data = [String]()
            for url in _contact.urlAddresses {
                data.append(url.value as String)
            }
            return data
        }
    }
    public var organizationName: String {
        get {
            return _contact.organizationName
        }
    }
    public var identifier: String {
        get {
            return _contact.identifier
        }
    }
}


public class MyContact: Contact {
    
    public var _contact: ABPerson
    private var _firstNameBasis:Bool
    private var _selectedEmail:String
    private var _gender:Gender
    
    init(with contact:ABPerson) {
        _contact = contact
        _firstNameBasis = false
        _selectedEmail = ""
        _gender = Gender.male
    }
    public func getEmptyContact()->Contact {
        return self
    }
    
    public var fullname:String {
        get {
            let surname = _contact.value(forKey: kABLastNameProperty) as! String
            let prename = _contact.value(forKey: kABFirstNameProperty) as! String
            let organizationName = _contact.value(forKey: kABOrganizationProperty) as! String
            
            // if given name is empty but familyname ist present
            if (prename.isEmpty && !surname.isEmpty) {
                return surname
            }
            else if (!prename.isEmpty && !surname.isEmpty) { // if both names are available set space between them
                return prename + " " + surname
            }
            else if (prename.isEmpty && surname.isEmpty && !organizationName.isEmpty){ // if names are empty but organizationname is available
                return organizationName
            }
            return ""
        }
    }

    public var surname: String {
        get {
            if let surname = _contact.value(forKey: kABLastNameProperty) {
                return surname as! String
            }
            else {
                return String()
            }
        }
    }

    public var prename: String {
        get {
            if let prename = _contact.value(forKey: kABFirstNameProperty) {
                    return  prename as! String
            }
            else {
                return String()
            }
        }
    }
    
    public var prefix: String {
        get {
            if let prefix = _contact.value(forKey: kABTitleProperty) {
                return  prefix as! String
            }
            else {
                return String()
            }
        }
    }
    public var gender: Gender {
        get {
            return _gender;
        }
        set {
            _gender = newValue
        }
    }
    
    public var firstNameBasis: Bool {
        get {
            return _firstNameBasis;
        }
        set {
            _firstNameBasis = newValue
        }
    }
    
    public var image:Data? {
        get {
            return _contact.imageData()
        }
    }
    
    public var imageAvailable: Bool {
        if _contact.imageData() != nil {
            return true
        }
        else {
            return false
        }
    }
    
    public var emails: [String] {
        get {
            var emailAdresses = [String]()
            if let multiValue = _contact.value(forKey: kABEmailProperty) as? ABMultiValue {
                for i in 0 ..< multiValue.count() {
                    emailAdresses.append(multiValue.value(at: i) as! String)
                }
            }
            return emailAdresses
        }
    }

    public var selectedEmail: String {
        get {
            return _selectedEmail;
        }
        set {
            _selectedEmail = newValue
        }
    }
    
    public var street: String {
        get {
            if let postaladdress = _contact.value(forKey: kABAddressProperty) as? ABMultiValue {
                
                let address = postaladdress.value(at: 0) as! NSDictionary
                let street = address.value(forKey: "Street") as! String
                return street
            }
            else {
                return String()
            }
        }
    }
    public var city: String {
        get {
            if let postaladdress = _contact.value(forKey: kABAddressProperty) as? ABMultiValue {
                
                let address = postaladdress.value(at: 0) as! NSDictionary
                let street = address.value(forKey: "City") as! String
                return street
            }
            else {
                return String()
            }
        }
    }
    public var postalCode: String {
        get {
            if let postaladdress = _contact.value(forKey: kABAddressProperty) as? ABMultiValue {
                
                let address = postaladdress.value(at: 0) as! NSDictionary
                let street = address.value(forKey: "ZIP") as! String
                return street
            }
            else {
                return String()
            }
        }
    }
    public var phone: [String] {
        get {
            var phones = [String]()
            if let multiValue = _contact.value(forKey: kABPhoneProperty) as? ABMultiValue {
                for i in 0 ..< multiValue.count() {
                    phones.append(multiValue.value(at: i) as! String)
                }
            }
            return phones
        }
    }
    public var url: [String] {
        get {
            var urls = [String]()
            if let multiValue = _contact.value(forKey: kABURLsProperty) as? ABMultiValue {
                for i in 0 ..< multiValue.count() {
                    urls.append(multiValue.value(at: i) as! String)
                }
            }
            return urls
        }
    }
    public var organizationName: String {
        get {
            if let orga = _contact.value(forKey: kABOrganizationProperty) {
                return  orga as! String
            }
            else {
                return String()
            }
        }
    }
    public var identifier: String {
        get {
            // TODO return unique identifier
            return ""
        }
    }
}



protocol CStore {
    var StoreContacts:[Contact] {get}
    var StoreContactsToShow:[Contact] {get}
    static func checkAccess() -> Bool
    func getContacts()
    func filterContacts(by name:String)
    func resetContactList()
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
    
    public func resetContactList() {
        newContactStore.resetContactList()
    }
}

public class oldCStore: CStore {

    var _StoreContacts = [Contact]()
    var _StoreContactsToShow = [Contact]()
    public static func checkAccess() -> Bool {
        
        let AddressBook = ABAddressBook.shared()
        
        if AddressBook != nil {
            return true
        }
        else {
            print("Access to Addressbook denied")
            return false
        }
    }
    
    public var StoreContacts: [Contact] {
        get {
            return _StoreContacts
        }
    }
    
    public var StoreContactsToShow: [Contact] {
        get {
            return _StoreContactsToShow
        }
    }
    
    public func getContacts() {
        
        if let AddressBook = ABAddressBook.shared(),  let people = AddressBook.people() {
            for person in people {
                _StoreContacts.append(MyContact(with: person as! ABPerson))
            }
            
            _StoreContacts.sort(by: {$0.surname < $1.surname})
            
            _StoreContactsToShow.removeAll()
            
            //remove empty names
            for contact in _StoreContacts {
                if !contact.fullname.isEmpty {
                    _StoreContactsToShow.append(contact)
                }
            }
            
        }
        
    }
    
    public func filterContacts(by name: String) {
        _StoreContactsToShow = _StoreContacts.filter { $0.surname.lowercased().contains(name.lowercased()) || $0.prename.lowercased().contains(name.lowercased())}
    }
   
    
    public func resetContactList() {
        _StoreContactsToShow.removeAll()
        _StoreContactsToShow = _StoreContacts
    }
}



