//
//  AddContactVCProgrammatic.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 26/08/2021.
//

import UIKit

class AddContactVCProgrammatic: UIViewController {
    
    //MARK: Properties
    private(set) var selectedDateOfBirth: Date?
    private let addContactView = AddContactProgrammaticView()
    
    
    //MARK: Load View
    override func loadView() {
        super.loadView()
        self.view = addContactView
        
    }
    
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupNavBar()
    }
    
    
    //MARK: Setup VC
    private func setupVC() {
        addContactView.tableView.delegate = self
        addContactView.tableView.dataSource = self
        
        addContactView.salutationCell.salutationSegmentControl.addTarget(self, action: #selector(salutationValueChanged), for: .valueChanged)
        addContactView.birthdayCell.birthdayPicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
    }
    
    
    //MARK: Setup Nav Bar
    func setupNavBar() {
        navigationItem.title = NavBarTitles.addContact
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNewContact))
    }
    
    
    //MARK: Create Contact
    private func createContact(uuid: UUID = UUID()) -> Contact? {
        let salutationSelector = addContactView.salutationCell.salutationSegmentControl
        
        guard
            let salutation = salutationSelector.titleForSegment(at: salutationSelector.selectedSegmentIndex),
            let firstName = addContactView.firstNameCell.textField.text,
            let lastName = addContactView.lastNameCell.textField.text,
            let phoneNumber = addContactView.phoneNumberCell.textField.text?.replacingOccurrences(of: " ", with: "")
            else { return nil }
        
        let middleName = addContactView.middleNameCell.textField.text
        let emailAddress = addContactView.emailAddressCell.textField.text
        let dateOfBirth = selectedDateOfBirth
        let contactAddress = createAddressForContact()
        
        return Contact(uuid: uuid, salutation: salutation, firstName: firstName, middleName: middleName, lastName: lastName, dateOfBirth: dateOfBirth, address: contactAddress, phoneNumber: phoneNumber, email: emailAddress)
    }
    
    
    //MARK: Create Address For Contact
    private func createAddressForContact() -> Address? {
        let streetOne = addContactView.streetLineOneCell.textField.text
        let streetTwo = addContactView.streetLineTwoCell.textField.text
        let city = addContactView.cityCell.textField.text
        let postcode = addContactView.postcodeCell.textField.text
        return Address(streetOne: streetOne, streetTwo: streetTwo, city: city, postcode: postcode)
    }
    
    
    //MARK: Save New Contact Tapped
    @objc func saveNewContact() {
        guard let contact = createContact() else { return }
        FirebaseManager.saveContact(contact: contact) { result in
            switch result {
            case .success:
                self.dismiss(animated: true)
            case .failure(let error):
                self.presentErrorAlertOnMainThread(title: "Error Saving", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
    
    
    @objc func salutationValueChanged(_ sender: UISegmentedControl) {
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        selectedDateOfBirth = picker.date
    }
    
    //MARK: Cancel Tapped (IBAction)
    @objc func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}


//MARK: TableView Delegate & Data Source
extension AddContactVCProgrammatic: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return addContactView.formSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addContactView.formSections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addContactView.formSections[indexPath.section].cells[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return addContactView.formSections[section].title
    }
}





