//
//  ViewController.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 26.02.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Cocoa
import Contacts

class ViewController: NSViewController {

    

    @IBOutlet weak var searchNameOutlet: NSSearchField!
    
    @IBOutlet weak var contactTableView: NSTableView!
    
    var recipientOne: CNContact = CNContact()
    var recipientTwo: CNContact = CNContact()


    @IBOutlet weak var recipientOneLabelOutlet: NSTextField!
    @IBOutlet weak var recipientTwoLabelOutlet: NSTextField!
    @IBOutlet weak var recipientOneImageOutlet: NSImageView!
    @IBOutlet weak var recipientTwoImageOutlet: NSImageView!
    @IBOutlet weak var recipientOneMultiEmailadressesOutlet: NSPopUpButton!
    @IBOutlet weak var recipientTwoMultiEmailadressesOutlet: NSPopUpButton!
    

    @IBOutlet var businessMessageTextView: NSTextView!
    @IBOutlet var privateMessageTextView: NSTextView!
    @IBOutlet weak var businessMessageSubject: NSTextField!
    @IBOutlet weak var privateMessageSubject: NSTextField!
    var message1:String = ""
    
    @IBOutlet weak var deleteRecipientOneOutlet: NSButton!
    @IBOutlet weak var deleteRecipientTwoOutlet: NSButton!
    
    @IBOutlet weak var messageTabViewOutlet: NSTabView!
    @IBOutlet weak var composeMailButtonOutlet: NSButton!
    
    
    @IBAction func deleteRecipientOneAction(_ sender: Any) {
        
        //delete data from recipientOne
        recipientOne = CNContact()
        
        //reset Label of recipients name
        recipientOneLabelOutlet.stringValue = Defaults.recipientOne
        recipientOneLabelOutlet.textColor = NSColor.black
        
        //reset Emaildress dropdown list
        recipientOneMultiEmailadressesOutlet.removeAllItems()
        recipientOneMultiEmailadressesOutlet.isHidden = true
        
        //hide delete recipient button
        deleteRecipientOneOutlet.isHidden = true
        
        //reset recipient to default empty recipent Image
        recipientOneImageOutlet.image = NSImage(named: "placeholder_contact.png")
        recipientOneImageOutlet.layer?.cornerRadius = (recipientOneImageOutlet.layer?.frame.width)! / 2
        
        //reset mail message -> remove recipients name of email-message
        businessMessageTextView.string = message1
        
        // deactivate sendButton
        composeMailButtonOutlet.isEnabled = false
    }
    
    @IBAction func deleteRecipientTwoAction(_ sender: Any) {
        
        //delete data from recipientTwo
        recipientTwo = CNContact()
        
        //reset Label of recipients name
        recipientTwoLabelOutlet.stringValue = Defaults.recipientTwo
        recipientTwoLabelOutlet.textColor = NSColor.black
        
        //reset Emaildress dropdown list
        recipientTwoMultiEmailadressesOutlet.removeAllItems()
        recipientTwoMultiEmailadressesOutlet.isHidden = true
        
        //hide delete recipient button
        deleteRecipientTwoOutlet.isHidden = true
        
        //reset recipient to default empty recipent Image
        recipientTwoImageOutlet.image = NSImage(named: "placeholder_contact.png")
        recipientTwoImageOutlet.layer?.cornerRadius = (recipientTwoImageOutlet.layer?.frame.width)! / 2
        
        //reset Message
        businessMessageTextView.string = message1

        // deactivate sendButton
        composeMailButtonOutlet.isEnabled = false

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

       
        AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
            print(accessGranted)
        })

        ContactStore.getContacts()
        
        contactTableView.delegate = self
        contactTableView.dataSource = self
        contactTableView.rowHeight = 50
        
        self.contactTableView.reloadData()
        
        //setup empty recipients
        deleteRecipientOneOutlet.isHidden = true
        deleteRecipientTwoOutlet.isHidden = true
        recipientOneLabelOutlet.stringValue = Defaults.recipientOne
        recipientTwoLabelOutlet.stringValue = Defaults.recipientTwo
        recipientOneMultiEmailadressesOutlet.isHidden = true
        recipientTwoMultiEmailadressesOutlet.isHidden = true
        
        
        let defaultsFile = Bundle.main.url(forResource: "defaults", withExtension: "plist")
        
        let defaultDictionary = NSDictionary(contentsOf: defaultsFile!)
        let standardwerte = defaultDictionary as! [String : AnyObject]
        
        UserDefaults.standard.register(defaults: standardwerte)
        
        let defaults = UserDefaults.standard
        message1 = defaults.object(forKey: "message1") as! String
        let message1title = defaults.object(forKey: "message1title") as! String
        let message2 = defaults.object(forKey: "message2") as! String
        let message2title = defaults.object(forKey: "message2title") as! String
        
        businessMessageTextView.string = message1
        businessMessageSubject.stringValue = message1title
        privateMessageTextView.string = message2
        privateMessageSubject.stringValue = message2title
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fieldTextDidChange), name: .NSControlTextDidChange, object: nil)
        
        recipientOneImageOutlet.image = NSImage(named: "placeholder_contact.png")
        recipientOneImageOutlet.layer?.cornerRadius = (recipientOneImageOutlet.layer?.frame.width)! / 2
        recipientTwoImageOutlet.image = NSImage(named: "placeholder_contact.png")
        recipientTwoImageOutlet.layer?.cornerRadius = (recipientTwoImageOutlet.layer?.frame.width)! / 2
        
        recipientOneMultiEmailadressesOutlet.removeAllItems()
        recipientTwoMultiEmailadressesOutlet.removeAllItems()
     
        updateSendButton()
        
    }

    func fieldTextDidChange() {
        let query = searchNameOutlet.stringValue
        if query != "" {
            ContactStore.filterContacts(by: query)
            self.contactTableView.reloadData()
        }
        else {
            ContactStore.getContacts()
            self.contactTableView.reloadData()
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func composeMailAction(_ sender: Any) {
        
        let mailadress1 = recipientOneMultiEmailadressesOutlet.selectedItem?.title
        let mailadress2 = recipientTwoMultiEmailadressesOutlet.selectedItem?.title
        let mailSubject = businessMessageSubject.stringValue
        let mailMessage = businessMessageTextView.string!
        
        SendEmail.send(mailOne: mailadress1!, mailTwo: mailadress2!, subject: mailSubject, message: mailMessage)
    }
    

        // set first Recipient to selected Contact
    func updateRecipients() {
        let selectedItem = contactTableView.selectedRow
        let contact = ContactStore.contactsToShow[selectedItem]
        
        if(recipientOneLabelOutlet.stringValue == Defaults.recipientOne) {
            recipientOne = contact
            
            
            
            recipientOneLabelOutlet.stringValue = contact.fullname
            if (contact.imageData != nil) {
                recipientOneImageOutlet.image = NSImage(data: contact.imageData!)
            }
            else {
                recipientOneImageOutlet.image = NSImage(named: "placeholder_contact.png")
            }
            let emailadresses = contact.emailAddresses
            if emailadresses.count > 0 {
                recipientOneLabelOutlet.textColor = NSColor.black
                recipientOneMultiEmailadressesOutlet.removeAllItems()
                recipientOneMultiEmailadressesOutlet.isHidden = false
                for email in emailadresses {
                    recipientOneMultiEmailadressesOutlet.addItem(withTitle: email.value as String)
                }
            }
            else {
                recipientOneLabelOutlet.textColor = NSColor.red
            }
            deleteRecipientOneOutlet.isHidden = false
            
        }
        else if(recipientTwoLabelOutlet.stringValue == Defaults.recipientTwo) {
            recipientTwo = contact
            
            
            recipientTwoLabelOutlet.stringValue = contact.fullname
            if (contact.imageData != nil) {
                recipientTwoImageOutlet.image = NSImage(data: contact.imageData!)
            }
            else {
                recipientTwoImageOutlet.image = NSImage(named: "placeholder_contact.png")
            }

            let emailadresses = contact.emailAddresses
            if emailadresses.count > 0 {
                recipientTwoLabelOutlet.textColor = NSColor.black
                recipientTwoMultiEmailadressesOutlet.removeAllItems()
                recipientTwoMultiEmailadressesOutlet.isHidden = false
                for email in emailadresses {
                    recipientTwoMultiEmailadressesOutlet.addItem(withTitle: email.value as String)
                }
            }
            else {
                recipientTwoLabelOutlet.textColor = NSColor.red
            }

            deleteRecipientTwoOutlet.isHidden = false
            
 
        }
        
        // update Messagetext with contact Information
        businessMessageTextView.string = processMessage(contact1: recipientOne, contact2: recipientTwo)

        
        //update status of sendbutton
        updateSendButton()
        
    }
    
    // check if sendButton should be active
    func updateSendButton () {
        if recipientOneMultiEmailadressesOutlet.itemArray.count > 0 && recipientTwoMultiEmailadressesOutlet.itemArray.count > 0 {
            composeMailButtonOutlet.isEnabled = true
        }
        else {
            composeMailButtonOutlet.isEnabled = false
        }
    }
    
    // replace all [name1],.. etc with contact information
    func processMessage(contact1:CNContact, contact2:CNContact) -> String? {
        var text = businessMessageTextView.string!
        
        //familyname
        if !contact1.familyName.isEmpty {
                text = text.replacingOccurrences(of: "[familyname1]", with: contact1.familyName)
        }
        if !contact2.familyName.isEmpty {
            text = text.replacingOccurrences(of: "[familyname2]", with: contact2.familyName)
        }
        
        //selected email
        if (recipientOneMultiEmailadressesOutlet.selectedItem?.title != nil) {
            text = text.replacingOccurrences(of: "[email1]", with: (recipientOneMultiEmailadressesOutlet.selectedItem?.title)!)
        }
        if recipientTwoMultiEmailadressesOutlet.selectedItem != nil {
            text = text.replacingOccurrences(of: "[email2]", with: (recipientTwoMultiEmailadressesOutlet.selectedItem?.title)!)
        }
        
        //organization
        if !contact1.organizationName.isEmpty {
            text = text.replacingOccurrences(of: "[organizationName1]", with: contact1.organizationName)
        }
        if !contact2.organizationName.isEmpty {
            text = text.replacingOccurrences(of: "[organizationName1]", with: contact2.organizationName)
        }
        
        //adress
        
        if let postaladress = contact1.postalAddresses.first {
            
            let street = postaladress.value.street
            let city = postaladress.value.city
            let postalCode = postaladress.value.postalCode
            
            text = text.replacingOccurrences(of: "[address1]", with: "\(street)\n\(postalCode) \(city)")
        }

        
        return text
    }

    class SendEmail: NSObject {
        static func send(mailOne:String, mailTwo:String, subject:String, message:String) {
            let service = NSSharingService(named: NSSharingServiceNameComposeEmail)!
            service.recipients = [mailOne, mailTwo]
            service.subject = subject
            
            service.perform(withItems: [message])
        }
    }
    
}

//MARK: - UITableViewDataSource

extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn:NSTableColumn?, row: Int) -> NSView? {
        let cellIdentifier = "nameCell"
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? contactTableCellView {
           
            let contact = ContactStore.contactsToShow[row]
            cell.contactNameTextFieldOutlet.stringValue = contact.fullname
            
            if #available(OSX 10.12, *) {
                if contact.imageDataAvailable {
                    cell.contactImageViewOutlet.image = NSImage(data: contact.imageData!)
                }
                else {
                    cell.contactImageViewOutlet.image = NSImage(named: "placeholder_contact.png")
                }
            } else {
                if (contact.imageData != nil) {
                    cell.contactImageViewOutlet.image = NSImage(data: contact.imageData!)
                }
                else {
                    cell.contactImageViewOutlet.image = NSImage(named: "placeholder_contact.png")
                    cell.contactImageViewOutlet.layer?.cornerRadius = (cell.contactImageViewOutlet.layer?.frame.width)! / 2
                }
            }
            return cell
        }
        

        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateRecipients()
    }
    
}

extension ViewController: NSTableViewDataSource {


    func numberOfRows(in tableView: NSTableView) -> Int {
        return ContactStore.contactsToShow.count
        // return ContactStore.contacts.count
    }
}




