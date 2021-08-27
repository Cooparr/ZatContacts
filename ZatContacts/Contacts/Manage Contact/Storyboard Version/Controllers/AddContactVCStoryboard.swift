//
//  AddContactVCStoryboard.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 24/08/2021.
//

import UIKit

class AddContactVCStoryboard: UITableViewController {
    
    //MARK: IBOutlets
    @IBOutlet var salutationSegCont: UISegmentedControl!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var middleNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var dateOfBirthPicker: UIDatePicker!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var streetOneTextField: UITextField!
    @IBOutlet var streetTwoTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var postcodeTextField: UITextField!
    
    
    //MARK: Properties
//    static let identifier = "AddContactForm"
    private(set) var selectedDateOfBirth: Date?
    var contactToUpdate: Contact?

    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        initalSetup()
        dateOfBirthPicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
    }
    
    
    //MARK: Inital Setup
    func initalSetup() {
        setRequiredFieldsPlaceholderColor()
        guard let contact = contactToUpdate else {
            navigationItem.title = NavBarTitles.addContact
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: NavBarBtnTitles.save, style: .done, target: self, action: #selector(saveNewContact))
            return
        }
        
        fillForm(withExisting: contact)
        navigationItem.title = NavBarTitles.updateContact
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NavBarBtnTitles.update, style: .done, target: self, action: #selector(updateExistingContact))
    }
    
    
    //MARK: Set Required Fields Placeholder Color
    private func setRequiredFieldsPlaceholderColor() {
        let requiredTextFields: [String: UITextField] = [
            "First Name"    : firstNameTextField,
            "Last Name"     : lastNameTextField,
            "Phone Number"  : phoneTextField
        ]
        
        requiredTextFields.forEach { (placeholderText, textField) in
            let attributedString = NSAttributedString(string: placeholderText,
                                                      attributes: [NSAttributedString.Key.foregroundColor: ThemeColor.accentColor])
            textField.attributedPlaceholder = attributedString
        }
    }
    
    
    //MARK: Create Contact
    private func createContact(uuid: UUID = UUID()) -> Contact? {
        guard
            let salutation = salutationSegCont.titleForSegment(at: salutationSegCont.selectedSegmentIndex),
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let phoneNumber = phoneTextField.text
            else { return nil }
        
        let middleName = middleNameTextField.text
        let emailAddress = emailTextField.text
        let dateOfBirth = selectedDateOfBirth
        let contactAddress = createAddressForContact()
        
        return Contact(uuid: uuid, salutation: salutation, firstName: firstName, middleName: middleName, lastName: lastName, dateOfBirth: dateOfBirth, address: contactAddress, phoneNumber: phoneNumber, email: emailAddress)
    }
    
    
    //MARK: Create Address For Contact
    private func createAddressForContact() -> Address? {
        return Address(streetOne: streetOneTextField.text, streetTwo: streetTwoTextField.text, city: cityTextField.text, postcode: postcodeTextField.text)
    }
    
    
    //MARK: Fill form With Existing Contact
    private func fillForm(withExisting existingContact: Contact) {
        firstNameTextField.text     = existingContact.firstName
        middleNameTextField.text    = existingContact.middleName
        lastNameTextField.text      = existingContact.lastName
        phoneTextField.text         = existingContact.phoneNumber
        emailTextField.text         = existingContact.email
        streetOneTextField.text     = existingContact.address?.streetOne
        streetTwoTextField.text     = existingContact.address?.streetTwo
        cityTextField.text          = existingContact.address?.city
        postcodeTextField.text      = existingContact.address?.postcode
        
        if let dateOfBirth = existingContact.dateOfBirth {
            dateOfBirthPicker.date = dateOfBirth
        }
        
        for (index, _) in Salutation.allCases.enumerated() {
            if existingContact.salutation == salutationSegCont.titleForSegment(at: index) {
                salutationSegCont.selectedSegmentIndex = index
            }
        }
    }
    
    
    //MARK: Save New Contact Tapped
    @objc func saveNewContact() {
        guard let contact = createContact() else { return }
        FirebaseManager.saveContact(contact: contact) { result in
            switch result {
            case .success:
                self.dismiss(animated: true)
            case .failure(let error):
                self.presentErrorAlertOnMainThread(title: "Error Saving", message: error.localizedDescription)
            }
        }
    }
    
    
    //MARK: Update Existing Contact Tapped
    @objc func updateExistingContact() {
        guard let contactToUpdateId = contactToUpdate?.uuid else { return }
        guard let updatedContact = createContact(uuid: contactToUpdateId) else { return }
        FirebaseManager.updateExistingContact(contactToUpdate: updatedContact) { result in
            switch result {
            case .success:
                self.dismiss(animated: true)
            case .failure(let error):
                self.presentErrorAlertOnMainThread(title: "Update Error", message: error.localizedDescription)
            }
        }
    }
    
    
    //MARK: Date Picker Value Changed
    @objc func datePickerChanged(picker: UIDatePicker) {
        selectedDateOfBirth = picker.date
    }
    
    
    //MARK: Cancel Tapped (IBAction)
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}


//MARK: UITableView Delegates & Data Source
extension AddContactVCStoryboard {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
