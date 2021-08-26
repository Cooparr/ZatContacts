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
    let contact: Contact
    private let detailedContactView = DetailedContactView()
    
    
    //MARK: Init
    required init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
        detailedContactView.setupView(with: contact)
        detailedContactView.callContactButton.addTarget(self, action: #selector(callContactTapped), for: .touchUpInside)
    }
    
    
    //MARK: Load View
    override func loadView() {
        super.loadView()
        self.view = detailedContactView
    }
    
    
    //MARK: Call Contact Tapped
    @objc func callContactTapped() {
        guard let number = URL(string: "tel://" + contact.phoneNumber) else { return }
        UIApplication.shared.open(number)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
