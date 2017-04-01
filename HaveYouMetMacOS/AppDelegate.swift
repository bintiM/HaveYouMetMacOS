//
//  AppDelegate.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 26.02.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Cocoa
import Contacts

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @available(OSX 10.11, *)
    func checkAccessStatus(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
        case .denied, .notDetermined:
            self.store().requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(true)
                } else {
                    print("access denied")
                }
            })
        default:
            completionHandler(false)
        }
 
 
    }
    
    class func sharedDelegate() -> AppDelegate {
        return NSApplication.shared().delegate as! AppDelegate
    }
}

@available(OSX 10.11, *)
extension AppDelegate {
    func store() -> CNContactStore {
        return CNContactStore()
    }
}

