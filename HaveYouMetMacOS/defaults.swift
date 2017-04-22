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
    
    static let mailText1 = "<p style=\"font-family:Helvetica\">[Anrede1] [Titel1] [familyname1], [Anrede2] [Titel2] [familyname2]</p><p style=\"font-family:Helvetica\">Wie mit Ihnen beiden bereits besprochen möchte ich Sie auf diese Weise unkompliziert in Verbindung bringen, direkt “kurzschliessen”.</p><p style=\"font-family:Helvetica\">Zur Erinnerung:</p><p style=\"font-family:Helvetica\">[Titel1] [familyname1] ist…<br>[Titel2] [familyname2] ist…<br>Hier nun die jeweiligen konkreten Adressen:</p><p style=\"font-family:Helvetica\"><b>Firma</b> [organizationName1]<br>[fullname1] – Funktion<br>[address1]<br>Tel. direkt:<br>Mobil: [phone1]<br>e-Mail: [email1]<br>Website: [url1]</p><p style=\"font-family:Helvetica\"><b>Firma</b> [organizationName2]<br>[fullname2] – Funktion<br>[address2]<br>Tel. direkt:<br>Mobil: [phone2]<br>e-Mail: [email2]<br>Website: [url2]</p><p style=\"font-family:Helvetica\">@ [Titel1] [familyname1]: darf ich [SieDu1_2] bitten, dass [SieDu1] in nächster Zeit mit [fullname2] Kontakt aufnehmen, um ein persönliches Treffen zu vereinbaren / das weitere Vorgehen zu definieren?</p><p style=\"font-family:Helvetica\">@ [Titel2] [familyname2]: darf ich [SieDu2_2] bitten, dass [SieDu2] in der nächsten Zeit mit [fullname1] Kontakt aufnehmen, um ein persönliches Treffen zu vereinbaren / das weitere Vorgehen zu definieren?</p><p style=\"font-family:Helvetica\">Vielen Dank - und viel Erfolg beim Netzwerken!</p><p style=\"font-family:Helvetica\">Mit besten Grüssen</p>"
    
    static let mailSubject = "Kurzschließ-Mail [fullname1] [organizationName1] und [fullname2] [organizationName2]"
    
    static let femalePrefixes:[String] = ["Frau", "Fr.", "Fr", "Miss", "Misses", "Ms", "Ms.", "Mrs.", "Mrs"]
    static let malePrefixes:[String] = ["Herr", "Hr.", "Hr", "Mister", "Mr", "Mr."]
    
    static let titleFemale = "Fr."
    static let titleMale = "Hr."
    
    static let PronounfirstNameBasis = "Du"
    static let Pronoun2firstNameBasis = "Dich"
    static let Pronoun = "Sie"
    static let Pronoun2 = "Sie"
    
    static let salutationMaleFirstNameBasis = "Lieber"
    static let salutationFemaleFirstNameBasis = "Liebe"
    static let salutationMale = "Sehr geehrter"
    static let salutationFemale = "Sehr geehrte"
    
}

enum ContactDrag {
    static let type = "mb.HaveYouMetMacOS.ContactAction"
    static let action = "DragContact"
}

public enum Gender {
    case male
    case female
}
 
