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
    
    
    
    var message1:Message = Message()
    
   
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

    @IBOutlet weak var firstNameBasisCheckboxOutlet: NSButton! {
        didSet {
            firstNameBasisCheckboxOutlet.isHidden = true
        }
    }
    @IBOutlet weak var maleRecipientOneOutlet: NSButton! {
        didSet {
            maleRecipientOneOutlet.isHidden = true
        }
    }
    @IBOutlet weak var femaleRecipientOneOutlet: NSButton! {
        didSet {
            femaleRecipientOneOutlet.isHidden = true
        }
    }
    @IBOutlet weak var firstNameBasis2CheckboxOutlet: NSButton!  {
        didSet {
            firstNameBasis2CheckboxOutlet.isHidden = true
        }
    }
    @IBOutlet weak var maleRecipientTwoOutlet: NSButton! {
        didSet {
            maleRecipientTwoOutlet.isHidden = true
        }
    }
    @IBOutlet weak var femaleRecipientTwoOutlet: NSButton! {
        didSet {
            femaleRecipientTwoOutlet.isHidden = true
        }
    }
    @IBOutlet weak var activityIndicatorOutlet: NSProgressIndicator! {
        didSet {
            activityIndicatorOutlet.isHidden = true
        }
    }
    
    @IBOutlet weak var messageTabViewOutlet: NSTabView!
    @IBOutlet weak var composeMailButtonOutlet: NSButton!
    
    @IBOutlet weak var recipientOneDeleteButtonCellOutlet: NSButtonCell!
    @IBOutlet weak var recipientTwoDeleteButtonCellOutlet: NSButtonCell!
    
    @IBAction func deleteRecipientOneAction(_ sender: Any) {
        
        //delete data from recipientOne
        recipientOne = nil
        
        //reset Label of recipients name
        recipientOneLabelOutlet.stringValue = Defaults.recipientOne
        recipientOneLabelOutlet.textColor = NSColor.black
        
        //reset Emaildress dropdown list
        recipientOneMultiEmailadressesOutlet.removeAllItems()
        recipientOneMultiEmailadressesOutlet.isHidden = true
        
        //hide option buttons
        deleteRecipientOneOutlet.isHidden = true
        firstNameBasisCheckboxOutlet.isHidden = true
        maleRecipientOneOutlet.isHidden = true
        femaleRecipientOneOutlet.isHidden = true
        
        //reset recipient to default empty recipent Image
        recipientOneImageOutlet.image = NSImage(named: Defaults.placeholderImage)
        
        //reset mail message -> remove recipients name of email-message
        let mailText = message1.resetMessage()
        messageTextViewOutlet.updateText(with: mailText)
        messageSubjectTextViewOutlet.stringValue = Defaults.mailSubject
        
        // deactivate sendButton
        composeMailButtonOutlet.isEnabled = false
    }
    
    @IBAction func deleteRecipientTwoAction(_ sender: Any) {
        
        //delete data from recipientTwo
        recipientTwo = nil
        
        //reset Label of recipients name
        recipientTwoLabelOutlet.stringValue = Defaults.recipientTwo
        recipientTwoLabelOutlet.textColor = NSColor.black
        
        //reset Emaildress dropdown list
        recipientTwoMultiEmailadressesOutlet.removeAllItems()
        recipientTwoMultiEmailadressesOutlet.isHidden = true
        
        //hide option buttons
        deleteRecipientTwoOutlet.isHidden = true
        firstNameBasis2CheckboxOutlet.isHidden = true
        maleRecipientTwoOutlet.isHidden = true
        femaleRecipientTwoOutlet.isHidden = true
        
        //reset recipient to default empty recipent Image
        recipientTwoImageOutlet.image = NSImage(named: Defaults.placeholderImage)
        
        //reset Message
        let mailText = message1.resetMessage()
        messageTextViewOutlet.updateText(with: mailText)
        messageSubjectTextViewOutlet.stringValue = Defaults.mailSubject

        // deactivate sendButton
        composeMailButtonOutlet.isEnabled = false

    }
    @IBAction func firstNameBasisCheckboxAction(_ sender: Any) {
        
        if firstNameBasisCheckboxOutlet.state == 1 {
            recipientOne.firstNameBasis = true
        }
        else {
            recipientOne.firstNameBasis = false
        }
 
        messageTextViewOutlet.updateText(with: message1.generateMessage(contact1: recipientOne, contact2: recipientTwo))
    }
    @IBAction func genderRecipientOneAction(_ sender: Any) {
        
        if maleRecipientOneOutlet.state == 1 {
            recipientOne.gender = Gender.male
        }
        else if femaleRecipientOneOutlet.state == 1 {
            recipientOne.gender = Gender.female
        }
        messageTextViewOutlet.updateText(with: message1.generateMessage(contact1: recipientOne, contact2: recipientTwo))
    }

    @IBAction func firstNameBasisCheckbox2Action(_ sender: Any) {
        
        if firstNameBasis2CheckboxOutlet.state == 1 {
            recipientTwo.firstNameBasis = true
        }
        else {
            recipientTwo.firstNameBasis = false
        }
        
        messageTextViewOutlet.updateText(with: message1.generateMessage(contact1: recipientOne, contact2: recipientTwo))
    }
    @IBAction func genderRecipientTwoAction(_ sender: Any) {
        if maleRecipientTwoOutlet.state == 1 {
            recipientTwo.gender = Gender.male
        }
        else if femaleRecipientTwoOutlet.state == 1 {
            recipientTwo.gender = Gender.female
        }
        messageTextViewOutlet.updateText(with: message1.generateMessage(contact1: recipientOne, contact2: recipientTwo))
    }

    @IBAction func recipientOneMultiMail(_ sender: Any) {
        if (recipientOneMultiEmailadressesOutlet.selectedItem?.title != nil) {
            recipientOne.selectedEmail = (recipientOneMultiEmailadressesOutlet.selectedItem?.title)!
        }
    }
    @IBAction func recipientTwoMultiMail(_ sender: Any) {
        if (recipientTwoMultiEmailadressesOutlet.selectedItem?.title != nil) {
            recipientTwo.selectedEmail = (recipientTwoMultiEmailadressesOutlet.selectedItem?.title)!
        }
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

        //set delegate and dataSource of contactTable
        contactTableView.delegate = self
        contactTableView.dataSource = self
        contactTableView.rowHeight = 50
        
        //set target for double click
        contactTableView.target = self
        contactTableView.doubleAction = #selector(contactTableViewDoubleClick(_:))
        
        
        //initialize ContactStore with available contacts
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.activityIndicatorOutlet.isHidden = false
            self.activityIndicatorOutlet.startAnimation(self)
            self.contactStore.getContacts()
            
            DispatchQueue.main.async {
                self.activityIndicatorOutlet.stopAnimation(self)
                self.activityIndicatorOutlet.isHidden = true
                self.contactTableView.reloadData()
            }
        }

        

        


        /*
        let defaultsFile = Bundle.main.url(forResource: "defaults", withExtension: "plist")
        
        let defaultDictionary = NSDictionary(contentsOf: defaultsFile!)
        let standardwerte = defaultDictionary as! [String : AnyObject]
        
        UserDefaults.standard.register(defaults: standardwerte)
        */
        
        messageTextViewOutlet.insertText(message1.text)
        messageSubjectTextViewOutlet.stringValue = message1.subject
        
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
       
        //design
        
        recipientOneDeleteButtonCellOutlet.highlightsBy = NSCellStyleMask(rawValue: 0)
        recipientTwoDeleteButtonCellOutlet.highlightsBy = NSCellStyleMask(rawValue: 0)
       
    }

    func searchFieldTextDidChange() {
        let query = searchNameOutlet.stringValue
        if query != "" {
            contactStore.filterContacts(by: query)
            self.contactTableView.reloadData()
        }
        else {
            contactStore.resetContactList()
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
        let mailText = message1.text
        SendEmail.send(mailOne: mailadress1!, mailTwo: mailadress2!, subject: mailSubject, message: mailText)
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
    

    func highlightPossibleDropTargets() {
        if recipientOneLabelOutlet.stringValue  == Defaults.recipientOne {
            recipientOneRoundedRectView.isHidden = false
        }
        if recipientTwoLabelOutlet.stringValue == Defaults.recipientTwo {
            recipientTwoRoundedRectView.isHidden = false
        }
    }
    
    func contactTableViewDoubleClick(_ sender:AnyObject) {
        
        if contactTableView.selectedRow >= 0 {
            
            if recipientOne == nil {
                processContactOne(NSIndexSet(index: contactTableView.selectedRow))
            }
            else if recipientTwo == nil {
                processContactTwo(NSIndexSet(index: contactTableView.selectedRow))
            }
            
        }
    }
    
    class SendEmail: NSObject {
        static func send(mailOne:String, mailTwo:String, subject:String, message:NSAttributedString) {
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
        
        //show options
        deleteRecipientOneOutlet.isHidden = false
        firstNameBasisCheckboxOutlet.isHidden = false
        maleRecipientOneOutlet.isHidden = false
        femaleRecipientOneOutlet.isHidden = false

        if Defaults.femalePrefixes.contains(contact.prefix) {
            femaleRecipientOneOutlet.state = 1
        }
        else if Defaults.malePrefixes.contains(contact.prefix) {
            maleRecipientOneOutlet.state = 1
        }
        
        firstNameBasisCheckboxOutlet.state = 0
        
        //hide highlights of recipientFields
        recipientOneRoundedRectView.isHidden = true
        recipientTwoRoundedRectView.isHidden = true
     
        // update Messagetext with contact Information

        if(recipientOne != nil && recipientTwo != nil) {
            let mailText = message1.generateMessage(contact1: recipientOne, contact2: recipientTwo)
            messageTextViewOutlet.updateText(with: mailText)
            messageSubjectTextViewOutlet.stringValue = message1.subject
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
        if (contact.imageAvailable) {
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
        
        // show options
        deleteRecipientTwoOutlet.isHidden = false
        firstNameBasis2CheckboxOutlet.isHidden = false
        maleRecipientTwoOutlet.isHidden = false
        femaleRecipientTwoOutlet.isHidden = false
        
        firstNameBasis2CheckboxOutlet.state = 0
        
        //hide highlights of recipientFields
        recipientOneRoundedRectView.isHidden = true
        recipientTwoRoundedRectView.isHidden = true
        
        
        // update Messagetext with contact Information
        
        if(recipientOne != nil && recipientTwo != nil) {
            let mailText = message1.generateMessage(contact1: recipientOne, contact2: recipientTwo)
            messageTextViewOutlet.updateText(with: mailText)
            messageSubjectTextViewOutlet.stringValue = message1.subject
        }
        
        
        //update status of sendbutton
        updateSendButton()
        
    }
    
}

extension NSTextView {
    func updateText(with newText:NSMutableAttributedString) {
        let messageTextLength = NSMakeRange(0, (self.string?.characters.count)!)
        self.insertText(newText, replacementRange: messageTextLength)
    }
}
