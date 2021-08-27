//
//  Constants.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 24/08/2021.
//

import UIKit

//MARK: Nav Bar Titles
enum NavBarTitles {
    static let contacts         = "Contacts"
    static let addContact       = "Add Contact"
    static let updateContact    = "Update Contact"
}

enum NavBarBtnTitles {
    static let save     = "Save"
    static let update   = "Update"
    static let delete   = "Delete"
}


//MARK: SF Symbol
enum SFSymbol {
    static let addContact   = UIImage(systemName: "person.fill.badge.plus")
    static let trash        = UIImage(systemName: "trash.fill")
    static let edit         = UIImage(systemName: "square.and.pencil")
}


//MARK: Theme Colo
enum ThemeColor {
    static let accentColor  =  UIColor.systemGreen
}


//MARK Salutation
enum Salutation: String, CaseIterable {
    case mr     = "Mr."
    case ms     = "Ms."
    case mrs    = "Mrs."
    case dr     = "Dr."
    case mx     = "Mx."
}
