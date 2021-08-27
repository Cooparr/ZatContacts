//
//  ValidationServiceTest.swift
//  ZatContactsTests
//
//  Created by Alexander James Cooper on 25/08/2021.
//

import XCTest
@testable import ZatContacts

class ValidationServiceTests: XCTestCase {
    
    //MARK:- Test Valid Emails
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
            "valid+Email.valid_Email-valid%" + "@outlook.com",
            charLength64 + "@" + charLength64 + "." + charLength32 + "." + charLength32
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
    
    
    //MARK: Test Invalid Emails
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
    
    
    //MARK:- Test Valid Phone Number
    func testValidPhoneNumber() {
        let validPhoneNumbers = [
            "07700900843",
            "07700 900 843",
            "+447700 900 843"
        ]
        
        for (index, validNumber) in validPhoneNumbers.enumerated() {
            // When
            let result = ValidationService.isValidPhoneNumber(validNumber)
            
            // Then
            XCTAssertTrue(result, "\(validPhoneNumbers[index]): Asserted to False, Index \(index)")
        }
    }
    
    
    //MARK: Test Invalid Phone Numbers
    func testInvalidPhoneNumber() {
        let numberToShort = "+1234"
        let numberToLong = "43543534535423535j"
        print(numberToLong.count)
        let invalidPhoneNumbers = [
            "rehjeyteuewtrey",
            "++7700 900 843",
            "0+7700 900 843",
            "-7700 900 843",
            "*7700 900 843",
            "#7700 900 843",
            numberToLong,
            numberToShort
        ]
        
        for (index, invalidNumber) in invalidPhoneNumbers.enumerated() {
            // When
            let result = ValidationService.isValidPhoneNumber(invalidNumber)
            
            // Then
            XCTAssertEqual(numberToShort.count, 5)
            XCTAssertEqual(numberToLong.count, 18)
            XCTAssertFalse(result, "\(invalidPhoneNumbers[index]): Asserted to True, Index \(index)")
        }
    }
}
