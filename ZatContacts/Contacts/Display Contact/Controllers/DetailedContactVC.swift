//
//  DetailedContactVC.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 24/08/2021.
//

import UIKit
import Contacts

class DetailedContactVC: UIViewController {
    
    //MARK: Properties
    private(set) var contact: Contact
    private let detailedContactView = DetailedContactView()
    
    
    //MARK: Init
    required init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
        detailedContactView.setupView(with: contact)
        detailedContactView.callContactButton.addTarget(self, action: #selector(callContactTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbol.edit, style: .plain, target: self, action: #selector(updateContactTapped))
    }
    
    
    //MARK: Load View
    override func loadView() {
        super.loadView()
        self.view = detailedContactView
    }
    
    
    //MARK: Call Contact Tapped
    @objc func callContactTapped() {
        guard let number = URL(string: "tel://" + contact.phoneNumber) else {
            return presentErrorAlertOnMainThread(title: "Call Failed", message: "There was an error when trying to call \(contact.firstName)")
        }
        
        UIApplication.shared.open(number)
    }
    
    
    //MARK: Update Contact Tapped
    @objc func updateContactTapped() {
        let updateContactVC = UpdateContactVCProgrammatic(contactToUpdate: self.contact)
        updateContactVC.updateContactDelegate = self
        let navCont = UINavigationController(rootViewController: updateContactVC)
        self.present(navCont, animated: true)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: Update Contact Delegate
extension DetailedContactVC: UpdateContactVCDelegate {
    func updateContactVCDismissed() {
        FirebaseManager.fetchSingleContactInfo(contactId: self.contact.uuid) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let updatedContact):
                self.contact = updatedContact
                self.detailedContactView.setupView(with: updatedContact)
            case .failure(let error):
                self.presentErrorAlertOnMainThread(title: "Error Occured", message: error.rawValue)
            }
        }
    }
}
