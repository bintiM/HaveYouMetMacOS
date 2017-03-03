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

    @IBOutlet weak var searchNameOutlet: NSTextField!
    
    @IBOutlet weak var contactTableView: NSTableView!
    
    @IBOutlet weak var recipientOne: NSTextField!
    @IBOutlet weak var recipientTwo: NSTextField!
    

    @IBOutlet var businessMessageTextView: NSTextView!
    @IBOutlet var privateMessageTextView: NSTextView!
    @IBOutlet weak var businessMessageSubject: NSTextField!
    @IBOutlet weak var privateMessageSubject: NSTextField!
    
    
    @IBOutlet weak var deleteRecipientOneOutlet: NSButton!
    @IBOutlet weak var deleteRecipientTwoOutlet: NSButton!
    
    @IBOutlet weak var imageOutlet: NSImageView!
    
    @IBAction func deleteRecipientOneAction(_ sender: Any) {
        recipientOne.stringValue = ""
        deleteRecipientOneOutlet.isHidden = true
    }
    @IBAction func deleteRecipientTwoAction(_ sender: Any) {
        recipientTwo.stringValue = ""
        deleteRecipientTwoOutlet.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ContactStore.getContacts()
        
        AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
            print(accessGranted)
        })


        
        contactTableView.delegate = self
        contactTableView.dataSource = self
        contactTableView.rowHeight = 50
        
        self.contactTableView.reloadData()
        
        deleteRecipientOneOutlet.isHidden = true
        deleteRecipientTwoOutlet.isHidden = true
        
        let defaultsFile = Bundle.main.url(forResource: "defaults", withExtension: "plist")
        
        let defaultDictionary = NSDictionary(contentsOf: defaultsFile!)
        let standardwerte = defaultDictionary as! [String : AnyObject]
        
        UserDefaults.standard.register(defaults: standardwerte)
        
        let defaults = UserDefaults.standard
        let message1 = defaults.object(forKey: "message1") as! String
        let message1title = defaults.object(forKey: "message1title") as! String
        let message2 = defaults.object(forKey: "message2") as! String
        let message2title = defaults.object(forKey: "message2title") as! String
        
        businessMessageTextView.string = message1
        businessMessageSubject.stringValue = message1title
        privateMessageTextView.string = message2
        privateMessageSubject.stringValue = message2title
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fieldTextDidChange), name: .NSControlTextDidChange, object: nil)
        
        

    }

    func fieldTextDidChange() {
        let query = searchNameOutlet.stringValue
        if query != "" {
            // ContactStore.findContactsWithName(name: query)
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
    
    
    @IBAction func buttonPushed(_ sender: Any) {
        SendEmail.send(mailOne: recipientOne.stringValue, mailTwo: recipientTwo.stringValue, subject: businessMessageSubject.stringValue, message: businessMessageTextView.string!)
    }

        // set first Recipient to selected Contact
    func updateRecipients() {
        let selectedItem = contactTableView.selectedRow
        
        if(recipientOne.stringValue.isEmpty) {
            recipientOne.stringValue = ContactStore.contactsToShow[selectedItem].familyName + " " + ContactStore.contactsToShow[selectedItem].givenName
            deleteRecipientOneOutlet.isHidden = false
        }
        else {
            recipientTwo.stringValue = ContactStore.contactsToShow[selectedItem].familyName + " " + ContactStore.contactsToShow[selectedItem].givenName
            deleteRecipientTwoOutlet.isHidden = false
        }
        
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
                    cell.contactImageViewOutlet.image = NSImage(byReferencingFile: "dummy.png")
                }
            } else {
                if (contact.imageData != nil) {
                    cell.contactImageViewOutlet.image = NSImage(data: contact.imageData!)
                }
                else {
                    cell.contactImageViewOutlet.image = NSImage(byReferencingFile: "dummy.png")
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




