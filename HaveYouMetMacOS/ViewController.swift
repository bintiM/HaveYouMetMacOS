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

    @IBOutlet var messageTextView: NSTextView!
    @IBOutlet weak var appTitleTextField: NSTextField!
    @IBOutlet weak var searchNameOutlet: NSTextField!
    
    @IBOutlet weak var contactTableView: NSTableView!
    
    @IBOutlet weak var recipientOne: NSTextField!
    @IBOutlet weak var recipientTwo: NSTextField!
    
    var store = CNContactStore()
    var contacts: [CNContact] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contactTableView.delegate = self
        contactTableView.dataSource = self
        
        messageTextView.string = "Das ist ein Test"
        
        AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
            print(accessGranted)
        })
        getContacts()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction func searchNameValueChanged(_ sender: Any) {
        
        let query = searchNameOutlet.stringValue
        if query != "" {
            findContactsWithName(name: query)
        }
        else {
            getContacts()
        }
        
    }

    @IBAction func buttonPushed(_ sender: Any) {
        print("button wurde gedrückt")
    }

        // set first Recipient to selected Contact
    func updateRecipients() {
        let selectedItem = contactTableView.selectedRow
        recipientOne.stringValue = contacts[selectedItem].familyName + " " + contacts[selectedItem].givenName
        
    }
    
    //MARK: - contact helper functions//

    func findContactsWithName(name: String) {
        AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
            if accessGranted {
                self.contacts.removeAll(keepingCapacity: false)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: name)
                        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactBirthdayKey] as [Any]
                        self.contacts.append(contentsOf: try self.store.unifiedContacts(matching: predicate, keysToFetch:keysToFetch as! [CNKeyDescriptor]))
                        self.contactTableView.reloadData()
                    }
                    catch {
                        print("Unable to refetch the selected contact.")
                    }
                })
            }
        })
    }

    
    func getContacts() {
        AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
            if accessGranted {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        self.contacts.removeAll(keepingCapacity: false)
                        
                        // Get all the containers
                        var allContainers: [CNContainer] = []
                        do {
                            allContainers = try self.store.containers(matching: nil)
                            //allContainers = try contactStore.containersMatchingPredicate(nil)
                        } catch {
                            print("Error fetching containers")
                        }
                        for container in allContainers {
                            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactBirthdayKey] as [Any]
                            self.contacts.append(contentsOf: try self.store.unifiedContacts(matching: predicate, keysToFetch:keysToFetch as! [CNKeyDescriptor]))
                            
                        }
                        self.contactTableView.reloadData()
                    }
                    catch {
                        print("Unable to refetch the selected contact.")
                    }
                })
            }
        })
    }

    
}

//MARK: - UITableViewDataSource

extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn:NSTableColumn?, row: Int) -> NSView? {
        let cellIdentifier = "nameCell"
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = contacts[row].familyName + " " + contacts[row].givenName
            return cell
        }
        
        /*
         if let birthday = contacts[row].birthday {
         let formatter = DateFormatter()
         formatter.dateStyle = DateFormatter.Style.long
         formatter.timeStyle = .none
         
         cell!.detailTextLabel?.text = formatter.string(from: (birthday.date)!)
         }
         */
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateRecipients()
    }
    
}

extension ViewController: NSTableViewDataSource {


    func numberOfRows(in tableView: NSTableView) -> Int {
        return contacts.count
    }
}


/*
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let controller = CNContactViewController(for: contacts[indexPath.row])
        
        if(user1Label.text == standardUser1) {
            user1 = contacts[indexPath.row]
            user1Label.text = CNContactFormatter.string(from: user1, style: .fullName)
            
            if(user2Label.text != standardUser2) {
                sendButton.isEnabled = true
            }
            
        }
        else {
            if(user2Label.text == standardUser2) {
                user2 = contacts[indexPath.row]
                user2Label.text = CNContactFormatter.string(from: user2, style: .fullName)
                
                if(user1Label.text != standardUser1) {
                    sendButton.isEnabled = true
                }
            }
        }
        // controller.contactStore = self.store
        // controller.allowsEditing = false
        // self.navigationController?.pushViewController(controller, animated: true)
    }
}
 */
