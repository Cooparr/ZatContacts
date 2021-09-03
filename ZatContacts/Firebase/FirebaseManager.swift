//
//  FirebaseManager.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 24/08/2021.
//

import Firebase
import FirebaseFirestoreSwift

enum FirebaseManager {
    
    //MARK: Properties
    
    
    //MARK: Handler Type Aliases
    typealias CreateHandler     = (Result<Void, Error>) -> Void
    typealias FetchHandler      = (Result<[Contact], FirebaseManagerError>) -> Void
    typealias UpdateHandler     = (Result<Void, Error>) -> Void
    typealias DeleteHandler     = (Result<Void, FirebaseManagerError>) -> Void
    
    //MARK: Firestore Reference
    private static func getUsersContactsCollectionReference() throws -> CollectionReference  {
        guard let userId = Auth.auth().currentUser?.uid else { throw FirebaseManagerError.failedToGetCurrentUserId }
        return
            Firestore.firestore()
            .collection(Collection.users.rawValue)
            .document(userId)
            .collection(Collection.contacts.rawValue)
    }
    
    
    //MARK:- Save Contact
    static func saveContact(contact: Contact, onCompletion: @escaping CreateHandler) {
        do {
            let validContact = try ValidationService.validateContact(contact: contact)
            let contactId = validContact.uuid.uuidString
            try getUsersContactsCollectionReference().document(contactId).setData(from: validContact)
            onCompletion(.success(()))
        } catch let validationError as ValidationService.ValidationError {
            onCompletion(.failure(validationError))
        } catch {
            onCompletion(.failure(FirebaseManagerError.unexpectedErrorOccured))
        }
    }
    
    
    //MARK: Fetch Contacts
    static func fetchUsersContacts(onCompletion: @escaping FetchHandler) {
        guard let contactsReference = try? getUsersContactsCollectionReference() else {
            return onCompletion(.failure(.failedToGetCollectionRef))
        }
        
        contactsReference.order(by: "lastName").addSnapshotListener { snapshot, error in
            if let error = error {
                print(error)
                return onCompletion(.failure(.failedToFetchContacts))
            }
            
            guard let documents = snapshot?.documents else { return onCompletion(.failure(.failedToUnwrapDocuments)) }
            let fetchedContacts: [Contact] = documents.compactMap {
                guard let contact = try? $0.data(as: Contact.self) else { return nil }
                return contact
            }
            onCompletion(.success(fetchedContacts))
        }
    }
    
    
    //MARK: Update Contact
    static func updateExistingContact(contactToUpdate: Contact, onCompletion: @escaping UpdateHandler) {
        do {
            let validContact = try ValidationService.validateContact(contact: contactToUpdate)
            try getUsersContactsCollectionReference().document(contactToUpdate.uuid.uuidString).setData(from: validContact)
            onCompletion(.success(()))
        } catch let validationError as ValidationService.ValidationError {
            onCompletion(.failure(validationError))
        } catch {
            onCompletion(.failure(FirebaseManagerError.unexpectedErrorOccured))
        }
    }
    
    
    
    //MARK: Delete Contact
    static func deleteContact(contactId: UUID, onCompletion: @escaping DeleteHandler) {
        guard let firestoreRef = try? getUsersContactsCollectionReference() else { return onCompletion(.failure(.failedToGetCollectionRef)) }
        
        firestoreRef.document(contactId.uuidString).delete() { error in
            guard error == nil else { return onCompletion(.failure(.failedToDeleteTeamComp)) }
            onCompletion(.success(()))
        }
    }
    
    
    //MARK: Fetch Single Contact Data
    static func fetchSingleContactInfo(contactId: UUID, onCompletion: @escaping (Result<Contact, FirebaseManagerError>) -> Void) {
        guard let firestoreRef = try? getUsersContactsCollectionReference() else { return onCompletion(.failure(.failedToGetCollectionRef)) }
        
        firestoreRef.document(contactId.uuidString).getDocument { docSnapshot, error in
            let result = Result { try docSnapshot?.data(as: Contact.self) }
            switch result {
            case .success(let contact):
                guard let contact = contact else { return onCompletion(.failure(.failedToUnwrapDocuments)) }
                onCompletion(.success(contact))
            case .failure:
                onCompletion(.failure(.failedToFetchSingleContact))
            }
        }
    }
}

extension FirebaseManager {
    
    //MARK: Firebase Collections
    enum Collection: String {
        case users      = "Users"
        case contacts   = "Contacts"
    }
    
    //MARK: Firebase Manager Errors
    enum FirebaseManagerError: String, LocalizedError {
        case unexpectedErrorOccured     = "An unexpected error was throw."
        case failedToGetCurrentUserId   = "Error throw when trying to get the current user ID."
        case failedToGetCollectionRef   = "Error was throw when unwraping user's contacts collection reference."
        case failedToFetchContacts      = "Error was throw by firebase when trying to fetch Contacts."
        case failedToFetchSingleContact = "Error was throw when trying to fetch this particular contact."
        case failedToUnwrapDocuments    = "Error was thrown when unnwrapped snapshot document from firebase."
        case failedToParseData          = "Error was thrown when trying to parse data as Contact."
        case failedToDeleteTeamComp     = "Error was throw when trying to delete Team Comp."
        
        
        var errorDescription: String? {
            return self.rawValue
        }
    }
}

