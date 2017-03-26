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

    
    @IBOutlet weak var recipientOnetopLayer: RecipientOneDestinationView!
    @IBOutlet weak var recipientOneRoundedRectView: RoundedRectView!

    @IBOutlet weak var recipientTwotopLayer: RecipientTwoDestinationView!
    @IBOutlet weak var recipientTwoRoundedRectView: RoundedRectView!
    
    @IBOutlet weak var searchNameOutlet: NSSearchField!
    
    @IBOutlet weak var contactTableView: NSTableView!
    
    var recipientOne: Contact!
    var recipientTwo: Contact!

    var contactStore: CStore!
    
    @IBOutlet weak var recipientOneLabelOutlet: NSTextField! {
        didSet {
                    recipientOneLabelOutlet.stringValue = Defaults.recipientOne
        }
    }
    @IBOutlet weak var recipientTwoLabelOutlet: NSTextField! {
        didSet {
                    recipientTwoLabelOutlet.stringValue = Defaults.recipientTwo
        }
    }
    @IBOutlet weak var recipientOneImageOutlet: NSImageView! {
        didSet {
            recipientOneImageOutlet.image = NSImage(named: Defaults.placeholderImage)
        }
    }
    @IBOutlet weak var recipientTwoImageOutlet: NSImageView! {
        didSet {
            recipientTwoImageOutlet.image = NSImage(named: Defaults.placeholderImage)
        }
    }
    @IBOutlet weak var recipientOneMultiEmailadressesOutlet: NSPopUpButton! {
        didSet {
            recipientOneMultiEmailadressesOutlet.isHidden = true
        }
    }
    @IBOutlet weak var recipientTwoMultiEmailadressesOutlet: NSPopUpButton! {
        didSet {
        recipientTwoMultiEmailadressesOutlet.isHidden = true
        }
    }
    

    @IBOutlet weak var messageSubjectTextViewOutlet: NSTextField!
    @IBOutlet var messageTextViewOutlet: NSTextView!
    
    
    
    var message1:String = ""
    
   
    @IBOutlet weak var deleteRecipientOneOutlet: NSButton! {
        didSet {
            deleteRecipientOneOutlet.isHidden = true
        }
    }
    @IBOutlet weak var deleteRecipientTwoOutlet: NSButton! {
        didSet {
            deleteRecipientTwoOutlet.isHidden = true
        }
    }

    
    @IBOutlet weak var messageTabViewOutlet: NSTabView!
    @IBOutlet weak var composeMailButtonOutlet: NSButton!
    
    
    @IBAction func deleteRecipientOneAction(_ sender: Any) {
        
        //delete data from recipientOne
        // recipientOne = CNContact()
        recipientOne = nil
        
        //reset Label of recipients name
        recipientOneLabelOutlet.stringValue = Defaults.recipientOne
        recipientOneLabelOutlet.textColor = NSColor.black
        
        //reset Emaildress dropdown list
        recipientOneMultiEmailadressesOutlet.removeAllItems()
        recipientOneMultiEmailadressesOutlet.isHidden = true
        
        //hide delete recipient button
        deleteRecipientOneOutlet.isHidden = true
        
        //reset recipient to default empty recipent Image
        recipientOneImageOutlet.image = NSImage(named: Defaults.placeholderImage)
        
        //reset mail message -> remove recipients name of email-message
        messageTextViewOutlet.string = message1
        
        // deactivate sendButton
        composeMailButtonOutlet.isEnabled = false
    }
    
    @IBAction func deleteRecipientTwoAction(_ sender: Any) {
        
        //delete data from recipientTwo
        // recipientTwo = CNContact()
        recipientTwo = nil
        
        //reset Label of recipients name
        recipientTwoLabelOutlet.stringValue = Defaults.recipientTwo
        recipientTwoLabelOutlet.textColor = NSColor.black
        
        //reset Emaildress dropdown list
        recipientTwoMultiEmailadressesOutlet.removeAllItems()
        recipientTwoMultiEmailadressesOutlet.isHidden = true
        
        //hide delete recipient button
        deleteRecipientTwoOutlet.isHidden = true
        
        //reset recipient to default empty recipent Image
        recipientTwoImageOutlet.image = NSImage(named: Defaults.placeholderImage)
        
        //reset Message
        messageTextViewOutlet.string = message1

        // deactivate sendButton
        composeMailButtonOutlet.isEnabled = false

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(OSX 10.11, *) {
            contactStore = newCStore()
        } else {
            contactStore = oldCStore()
        }

        
        // set self as delegate of recipientOneLayer for Drag&Drop
        recipientOnetopLayer.delegate = self
        recipientTwotopLayer.delegate = self
        
        //get access to contacts
        
        
        /*AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
            NSLog("access to contacts allowed ")
        })*/

        //initialize ContactStore with available contacts
        contactStore.getContacts()
        
        //set delegate and dataSource of contactTable
        contactTableView.delegate = self
        contactTableView.dataSource = self
        contactTableView.rowHeight = 50
        self.contactTableView.reloadData()

        let defaultsFile = Bundle.main.url(forResource: "defaults", withExtension: "plist")
        
        let defaultDictionary = NSDictionary(contentsOf: defaultsFile!)
        let standardwerte = defaultDictionary as! [String : AnyObject]
        
        UserDefaults.standard.register(defaults: standardwerte)
        
        let defaults = UserDefaults.standard
        message1 = defaults.object(forKey: "message1") as! String
        let message1title = defaults.object(forKey: "message1title") as! String

        
        messageTextViewOutlet.string = message1
        messageSubjectTextViewOutlet.stringValue = message1title
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchFieldTextDidChange), name: .NSControlTextDidChange, object: nil)
        
        recipientOneMultiEmailadressesOutlet.removeAllItems()
        recipientTwoMultiEmailadressesOutlet.removeAllItems()
     
        updateSendButton()
        
        // make placeholder for recipient Image rounded
        recipientOneImageOutlet.layer?.cornerRadius = (recipientOneImageOutlet.layer?.frame.width)! / 2
        recipientTwoImageOutlet.layer?.cornerRadius = (recipientTwoImageOutlet.layer?.frame.width)! / 2
        
        //hide highlight for possible drop locations
        recipientOneRoundedRectView.isHidden = true
        recipientTwoRoundedRectView.isHidden = true
    }

    func searchFieldTextDidChange() {
        let query = searchNameOutlet.stringValue
        if query != "" {
            contactStore.filterContacts(by: query)
            self.contactTableView.reloadData()
        }
        else {
            contactStore.getContacts()
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
        let mailSubject = messageSubjectTextViewOutlet.stringValue
        let mailMessage = messageTextViewOutlet.string!
        
        SendEmail.send(mailOne: mailadress1!, mailTwo: mailadress2!, subject: mailSubject, message: mailMessage)
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
    func processMessage(contact1:Contact, contact2:Contact) -> String? {
        var text = messageTextViewOutlet.string!
        
        //familyname
        if !contact1.surname.isEmpty {
                text = text.replacingOccurrences(of: "[familyname1]", with: contact1.surname)
        }
        if !contact2.surname.isEmpty {
            text = text.replacingOccurrences(of: "[familyname2]", with: contact2.surname)
        }
        
        //fullname
        if !contact1.fullname.isEmpty {
            text = text.replacingOccurrences(of: "[fullname1]", with: contact1.fullname)
        }
        if !contact2.fullname.isEmpty {
            text = text.replacingOccurrences(of: "[fullname2]", with: contact2.fullname)
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

        //address
        
        text = text.replacingOccurrences(of: "[address1]", with: "\(contact1.street)\n\(contact1.postalCode) \(contact1.city)")

        text = text.replacingOccurrences(of: "[address2]", with: "\(contact2.street)\n\(contact2.postalCode) \(contact2.city)")

        
        //phones
        if let phoneNumber = contact1.phone.first {
            text = text.replacingOccurrences(of: "[phone1]", with: phoneNumber)
        }
        if let phoneNumber2 = contact2.phone.first {
            text = text.replacingOccurrences(of: "[phone2]", with: phoneNumber2)
        }

        
        //urls
        if let url1 = contact1.url.first {
            text = text.replacingOccurrences(of: "[url1]", with: url1)
        }
        if let url2 = contact2.url.first {
            text = text.replacingOccurrences(of: "[url2]", with: url2)
        }

        
        return text
    }

    func highlightPossibleDropTargets() {
        if recipientOneLabelOutlet.stringValue  == Defaults.recipientOne {
            recipientOneRoundedRectView.isHidden = false
        }
        if recipientTwoLabelOutlet.stringValue == Defaults.recipientTwo {
            recipientTwoRoundedRectView.isHidden = false
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
           
            let contact = contactStore.StoreContactsToShow[row]
            cell.contactNameTextFieldOutlet.stringValue = contact.fullname
            
            
            if contact.imageAvailable {
                cell.contactImageViewOutlet.image = NSImage(data: contact.image!)
            }
            else {
                cell.contactImageViewOutlet.image = NSImage(named: Defaults.placeholderImage)
            }
            
            return cell
        }
        return nil
    }

   
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        NSLog("Drag starts")
        
        highlightPossibleDropTargets()
        
        let data:NSData = NSKeyedArchiver.archivedData(withRootObject: rowIndexes) as NSData
        let registeredTypes:[String] = [ContactDrag.type]
        pboard.declareTypes(registeredTypes, owner: self)
        pboard.setData(data as Data, forType: ContactDrag.type)
    
        return true
    }


    
}

extension ViewController: NSTableViewDataSource {


    func numberOfRows(in tableView: NSTableView) -> Int {
        return contactStore.StoreContactsToShow.count
    }
}

extension ViewController: RecipientOneDestinationViewDelegate {

    func processContactOne(_ indexSet: NSIndexSet) {

        let index = indexSet.firstIndex
        let contact = contactStore.StoreContactsToShow[index]
        recipientOne = contact
        
        recipientOneLabelOutlet.stringValue = contact.fullname
        if contact.imageAvailable {
            recipientOneImageOutlet.image = NSImage(data: contact.image!)
            recipientOneImageOutlet.layer?.cornerRadius = (recipientOneImageOutlet.layer?.frame.width)! / 2
        }
        else {
            recipientOneImageOutlet.image = NSImage(named: Defaults.placeholderImage)
            
        }
        let emailadresses = contact.emails
        if emailadresses.count > 0 {
            recipientOneLabelOutlet.textColor = NSColor.black
            recipientOneMultiEmailadressesOutlet.removeAllItems()
            recipientOneMultiEmailadressesOutlet.isHidden = false
            for email in emailadresses {
                recipientOneMultiEmailadressesOutlet.addItem(withTitle: email)
            }
        }
        else {
            recipientOneMultiEmailadressesOutlet.removeAllItems()
            recipientOneMultiEmailadressesOutlet.isHidden = true
            recipientOneLabelOutlet.textColor = NSColor.red
        }
        deleteRecipientOneOutlet.isHidden = false

        //hide highlights of recipientFields
        recipientOneRoundedRectView.isHidden = true
        recipientTwoRoundedRectView.isHidden = true
     
        // update Messagetext with contact Information
        if(recipientOne != nil && recipientTwo != nil) {
                messageTextViewOutlet.string = processMessage(contact1: recipientOne!, contact2: recipientTwo!)
        }
        
        
        
        //update status of sendbutton
        updateSendButton()
        
    }

}

extension ViewController: RecipientTwoDestinationViewDelegate {
    
    func processContactTwo(_ indexSet: NSIndexSet) {
        
        let index = indexSet.firstIndex
        let contact = contactStore.StoreContactsToShow[index]
        recipientTwo = contact
        
        recipientTwoLabelOutlet.stringValue = contact.fullname
        if (contact.image != nil) {
            recipientTwoImageOutlet.image = NSImage(data: contact.image!)
            recipientTwoImageOutlet.layer?.cornerRadius = (recipientTwoImageOutlet.layer?.frame.width)! / 2
        }
        else {
            recipientTwoImageOutlet.image = NSImage(named: Defaults.placeholderImage)
        }
        let emailadresses = contact.emails
        if emailadresses.count > 0 {
            recipientTwoLabelOutlet.textColor = NSColor.black
            recipientTwoMultiEmailadressesOutlet.removeAllItems()
            recipientTwoMultiEmailadressesOutlet.isHidden = false
            for email in emailadresses {
                recipientTwoMultiEmailadressesOutlet.addItem(withTitle: email)
            }
        }
        else {
            recipientTwoMultiEmailadressesOutlet.removeAllItems()
            recipientTwoMultiEmailadressesOutlet.isHidden = true
            recipientTwoLabelOutlet.textColor = NSColor.red
        }
        deleteRecipientTwoOutlet.isHidden = false
        
        //hide highlights of recipientFields
        recipientOneRoundedRectView.isHidden = true
        recipientTwoRoundedRectView.isHidden = true
        
        // update Messagetext with contact Information
        if(recipientOne != nil && recipientTwo != nil) {
            messageTextViewOutlet.string = processMessage(contact1: recipientOne!, contact2: recipientTwo!)
        }
        
        //update status of sendbutton
        updateSendButton()
        
    }
    
}
