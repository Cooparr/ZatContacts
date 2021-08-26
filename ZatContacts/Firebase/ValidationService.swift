//
//  ValidationService.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 25/08/2021.
//

import Foundation

enum ValidationService {
    
    //MARK: Validate Contact
    static func validateContact(contact: Contact) throws -> Contact {
        guard !contact.salutation.isEmpty               else { throw ValidationError.noSalutationProvided }
        guard !contact.firstName.isEmpty                else { throw ValidationError.noFirstNameProvided }
        guard !contact.lastName.isEmpty                 else { throw ValidationError.noLastNameProvided }
        guard !contact.phoneNumber.isEmpty              else { throw ValidationError.noPhoneNumberProvided }
        guard isValidPhoneNumber(contact.phoneNumber)   else { throw ValidationError.invalidPhoneNumber }
        guard isValidEmail(contact.email)               else { throw ValidationError.invalidEmail }
        return contact
    }
    
    
    static func isValidPhoneNumber(_ phoneNumber: String?) -> Bool {
        let phoneRegEx = "[0-9+]{0,1}[0-9]{5,16}\\b"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phoneNumber)
    }
    
    
    static func isValidEmail(_ email: String?) -> Bool {
        if let providedEmail = email, !providedEmail.isEmpty {
            let emailRegEx = "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,64}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,32})+"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: providedEmail)
        }
        
        return true
    }
    
    
    //MARK: Validation Errors
    enum ValidationError: String, LocalizedError {
        case noSalutationProvided = "Please provide a salutation for this contact."
        case noFirstNameProvided = "Please provide a first name for this contact."
        case noLastNameProvided = "Please provide a last name for this contact."
        case noPhoneNumberProvided =  "Please provide a phone number for this contact."
        case invalidEmail = "Email address provided is invalid."
        case invalidPhoneNumber = "Phone number provided is invalid."
        
        
        //MARK: Error Description
        var errorDescription: String? {
            return self.rawValue
        }
    }
}
