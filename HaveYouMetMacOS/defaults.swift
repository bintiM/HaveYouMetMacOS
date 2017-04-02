//
//  defaults.swift
//  HaveYouMetMacOS
//
//  Created by Marc Bintinger on 04.03.17.
//  Copyright © 2017 Marc Bintinger. All rights reserved.
//

import Foundation


struct Defaults {
    static let recipientOne = "Drag Recipient here"
    static let recipientTwo = "Drag Recipient here"
    static let radius: CGFloat = 10.0
    
    static let placeholderImage = "placeholder_contact_rounded_45px.png"
    
    static let mailText1 = "<p style=\"font-family:Helvetica\">Grüezi Herr [familyname1], lieber Herr [familyname2]</p><p style=\"font-family:Helvetica\">Wie mit Ihnen beiden bereits besprochen möchte ich Sie auf diese Weise unkompliziert in Verbindung bringen, direkt “kurzschliessen”.</p><p style=\"font-family:Helvetica\">Zur Erinnerung:</p><p style=\"font-family:Helvetica\">Herr [familyname1] ist…<br>Herr [familyname2] ist…<br>Hier nun die jeweiligen konkreten Adressen:</p><p style=\"font-family:Helvetica\"><b>Firma</b> [organizationName1]<br>[fullname1] – Funktion<br>[address1]<br>Tel. direkt:<br>Mobil: [phone1]<br>e-Mail: [email1]<br>Website: [url1]</p><p style=\"font-family:Helvetica\"><b>Firma</b> [organizationName2]<br>[fullname2] – Funktion<br>[address2]<br>Tel. direkt:<br>Mobil: [phone2]<br>e-Mail: [email2]<br>Website: [url2]</p><p style=\"font-family:Helvetica\">@ Herr [familyname1]: darf ich Sie bitten, dass Sie in nächster Zeit mit [fullname2]  Kontakt aufnehmen, um ein persönliches Treffen zu vereinbaren / das weitere Vorgehen zu definieren?</p><p style=\"font-family:Helvetica\">@ Herr [familyname2]: darf ich Dich bitten, dass Du in der nächsten Zeit mit [fullname1] Kontakt aufnimmst, um ein persönliches Treffen zu vereinbaren / das weitere Vorgehen zu definieren?</p><p style=\"font-family:Helvetica\">Vielen Dank - und viel Erfolg beim Netzwerken!</p><p style=\"font-family:Helvetica\">Mit besten Grüssen</p>"
    
    static let mailSubject = "Kurzschließ-Mail [fullname1] [organization1] und [fullname2] [organization2]"
    
    static let femalePrefixes:[String] = ["Frau", "Fr.", "Fr", "Miss", "Misses", "Ms", "Ms.", "Mrs.", "Mrs"]
    static let malePrefixes:[String] = ["Herr", "Hr.", "Hr", "Mister", "Mr", "Mr."]
    
}

enum ContactDrag {
    static let type = "mb.HaveYouMetMacOS.ContactAction"
    static let action = "DragContact"
}
