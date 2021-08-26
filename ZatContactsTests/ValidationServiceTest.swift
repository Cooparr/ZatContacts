//
//  ValidationServiceTest.swift
//  ZatContactsTests
//
//  Created by Alexander James Cooper on 25/08/2021.
//

import XCTest
@testable import ZatContacts

class ValidationServiceTests: XCTestCase {
    
    //MARK:- Email Tests
    func testValidEmails() {
        // Given
        let charLength32 = "validEmailvalidEmailvalidEmailva"
        let charLength64 = "validEmailvalidEmailvalidEmailvavalidEmailvalidEmailvalidEmailva"
        let validEmails = [
            "validEmail@gmail.com",
            "validEmail@university.co.uk",
            "x@x.com",
            "validEmail@herts.ac.ac.uk",
            "validEmail@c.o",
            "validEmail@c-.uk",
            "validEmail@co.u-",
            "VALIDEMAIL@CO.UK",
            "43110@12.14",
            "validEmail@" + charLength64 + ".com",
            charLength64 + "@gmail.com",
            "validEmail@hotmail." + charLength32,
            "valid+Email.valid_Email-valid%" + "@outlook.com"
        ]
        
        
        for (index, validEmail) in validEmails.enumerated() {
            // When
            let result = ValidationService.isValidEmail(validEmail)
            
            // Then
            XCTAssertEqual(charLength32.count, 32)
            XCTAssertEqual(charLength64.count, 64)
            XCTAssertTrue(result, "\(validEmails[index]): Asserted to False, Index = \(index)")
        }
    }
    
    
    func testInvalidEmails() {
        // Given
        let charLength34 = "invalidEmailinvalidEmailinvalidEma"
        let charLength66 = "invalidEmailinvalidEmailinvalidEminvalidEmailinvalidEmailinvalidEm"
        let invalidEmails = [
            "@invalidEmail.com",
            "invalidEmail@.com",
            "invalid Email@gmail.com",
            "invalid!Email@gmail.com",
            "invalid£Email@gmail.com",
            "invalid$Email@gmail.com",
            "invalid^Email@gmail.com",
            "invalid&Email@gmail.com",
            "invalid*Email@gmail.com",
            "invalid@invalid@Email@gmail.com",
            "invalidEmail@",
            "invalidEmail@-.com",
            "invalidEmail@c.",
            "invalidEmail@c.-",
            "invalidEmail@hotmail.",
            "invalidEmail@hotmail." + charLength34,
            charLength66 + "@gmail.com",
            "invalidEmail@" + charLength66 + ".com"
        ]
        
        
        for (index, invalidEmail) in invalidEmails.enumerated() {
            // When
            let result = ValidationService.isValidEmail(invalidEmail)
            
            // Then
            XCTAssertEqual(charLength34.count, 34)
            XCTAssertEqual(charLength66.count, 66)
            XCTAssertFalse(result, "\(invalidEmails[index]): Asserted to True, Index \(index)")
        }
    }
    
    
    
    //MARK: Phone Number Tests
    func testValidPhoneNumber() {
        
    }
    
    
}
