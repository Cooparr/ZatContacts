//
//  UpdateContactVCProgrammatic.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 26/08/2021.
//

import UIKit

class UpdateContactVCProgrammatic: AddContactVCProgrammatic {
    
    //MARK: Properties
    let contactToUpdate: Contact
    
    
    //MARK: Init
    init(contactToUpdate: Contact) {
        self.contactToUpdate = contactToUpdate
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillFormWithExistingContactInfo()
        navigationItem.title = NavBarTitles.updateContact
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NavBarBtnTitles.update, style: .done, target: self, action: #selector(updateExistingContact))
    }
    
    
    //MARK: Fill form With Existing Contact
    private func fillFormWithExistingContactInfo() {
        addContactView.firstNameCell.setTextField       (to: contactToUpdate.firstName)
        addContactView.middleNameCell.setTextField      (to: contactToUpdate.middleName)
        addContactView.lastNameCell.setTextField        (to: contactToUpdate.lastName)
        addContactView.phoneNumberCell.setTextField     (to: contactToUpdate.phoneNumber)
        addContactView.emailAddressCell.setTextField    (to: contactToUpdate.email)
        addContactView.streetLineOneCell.setTextField   (to: contactToUpdate.address?.streetOne)
        addContactView.streetLineTwoCell.setTextField   (to: contactToUpdate.address?.streetTwo)
        addContactView.cityCell.setTextField            (to: contactToUpdate.address?.city)
        addContactView.postcodeCell.setTextField        (to: contactToUpdate.address?.postcode)

        if let dateOfBirth = contactToUpdate.dateOfBirth {
            addContactView.birthdayCell.birthdayPicker.date = dateOfBirth
        }

        let salutationSegCont = addContactView.salutationCell.salutationSegmentControl
        for (index, _) in Salutation.allCases.enumerated() {
            if contactToUpdate.salutation == salutationSegCont.titleForSegment(at: index) {
                salutationSegCont.selectedSegmentIndex = index
            }
        }
    }
    
    
    //MARK: Update Existing Contact Tapped
    @objc func updateExistingContact() {
        guard let updatedContact = createContact(uuid: contactToUpdate.uuid) else { return }
        FirebaseManager.updateExistingContact(contactToUpdate: updatedContact) { result in
            switch result {
            case .success:
                self.dismiss(animated: true)
            case .failure(let error):
                self.presentErrorAlertOnMainThread(title: "Update Error", message: error.localizedDescription)
            }
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
