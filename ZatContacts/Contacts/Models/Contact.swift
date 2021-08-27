//
//  Contact.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 24/08/2021.
//

import Foundation
import Contacts

//MARK:- Contact
struct Contact: Codable {
    var uuid           = UUID()
    let salutation     : String
    var firstName      : String
    var middleName     : String?
    var lastName       : String
    let dateOfBirth    : Date?
    var address        : Address?
    var phoneNumber    : String
    var email          : String?
    
    
    //MARK: Equatable Conformance
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    
    //MARK: Full Name
    var fullName: String {
        guard let middleName = self.middleName, !middleName.isEmpty else {
            return "\(salutation) \(firstName) \(lastName)"
        }
        
        return "\(salutation) \(firstName) \(middleName) \(lastName)"
    }
    
    
    //MARK: Birthday
    var birthday: String? {
        guard let birthday = self.dateOfBirth else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, y"
        return dateFormatter.string(from: birthday)
    }
}


//MARK:- Address
struct Address: Codable {
    var streetOne       : String?
    var streetTwo       : String?
    var city            : String?
    var postcode        : String?
    
    
    //MARK: Full Name Property
    var fullAddress: String {
        let contactAddress = CNMutablePostalAddress()
        contactAddress.street = self.streetOne ?? ""
        contactAddress.state = self.streetTwo ?? ""
        contactAddress.postalCode = self.postcode ?? ""
        contactAddress.city = self.city ?? ""
        contactAddress.isoCountryCode = "GB"
        return CNPostalAddressFormatter.string(from: contactAddress, style: .mailingAddress)
    }
}
