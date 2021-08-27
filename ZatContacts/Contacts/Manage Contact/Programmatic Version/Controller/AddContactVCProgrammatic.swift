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
    let addContactView = AddContactProgrammaticView()
    
    
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
        assignDelegates()
        addKeyboardObservers()
    }
    
    
    //MARK: Setup VC
    private func setupVC() {
        addContactView.birthdayCell.birthdayPicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        addContactView.addGestureRecognizer(dismissKeyboardGesture)
    }
    
    
    //MARK: Setup Nav Bar
    func setupNavBar() {
        navigationItem.title = NavBarTitles.addContact
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NavBarBtnTitles.save, style: .done, target: self, action: #selector(saveNewContact))
    }
    
    
    //MARK: Assign Delegates
    private func assignDelegates() {
        addContactView.tableView.delegate = self
        addContactView.tableView.dataSource = self
        
        addContactView.formSections.forEach { formSection in
            formSection.cells.forEach { staticCell in
                guard let textFieldCell = staticCell as? ZCTextFieldCell else { return }
                textFieldCell.textField.delegate = self
            }
        }
    }
    
    
    //MARK: Create Contact
    func createContact(uuid: UUID = UUID()) -> Contact? {
        let salutationSelector = addContactView.salutationCell.salutationSegmentControl
        
        guard
            let salutation  = salutationSelector.titleForSegment(at: salutationSelector.selectedSegmentIndex),
            let firstName   = addContactView.firstNameCell.textField.text,
            let lastName    = addContactView.lastNameCell.textField.text,
            let phoneNumber = addContactView.phoneNumberCell.textField.text
            else { return nil }
        
        let middleName      = addContactView.middleNameCell.textField.text
        let emailAddress    = addContactView.emailAddressCell.textField.text
        let dateOfBirth     = selectedDateOfBirth
        let contactAddress  = createAddressForContact()
        
        return Contact(uuid: uuid, salutation: salutation, firstName: firstName, middleName: middleName, lastName: lastName, dateOfBirth: dateOfBirth, address: contactAddress, phoneNumber: phoneNumber, email: emailAddress)
    }
    
    
    //MARK: Create Address For Contact
    private func createAddressForContact() -> Address? {
        let streetOne   = addContactView.streetLineOneCell.textField.text
        let streetTwo   = addContactView.streetLineTwoCell.textField.text
        let city        = addContactView.cityCell.textField.text
        let postcode    = addContactView.postcodeCell.textField.text
        return Address(streetOne: streetOne, streetTwo: streetTwo, city: city, postcode: postcode)
    }
    
    
    //MARK: Add Keyboard Observers
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    
    //MARK: Date Picker Changed
    @objc func datePickerChanged(picker: UIDatePicker) {
        selectedDateOfBirth = picker.date
    }
    
    
    //MARK: Cancel Tapped
    @objc func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    //MARK: Keyboard Show / Hide
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            addContactView.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + addContactView.tableView.rowHeight, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        addContactView.tableView.contentInset = .zero
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


extension AddContactVCProgrammatic: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= getMaxCharValue(for: textField)
    }
    
    
    private func getMaxCharValue(for textField: UITextField) -> Int {
        switch textField {
        case addContactView.firstNameCell.textField,
             addContactView.middleNameCell.textField,
             addContactView.lastNameCell.textField,
             addContactView.phoneNumberCell.textField,
             addContactView.streetLineOneCell.textField,
             addContactView.streetLineTwoCell.textField,
             addContactView.cityCell.textField:
            return 30
        case addContactView.emailAddressCell.textField:
            return 200
        case addContactView.postcodeCell.textField:
            return 10
        default:
            print("Unrecognised textfield, setting limit to a default value")
            return 100
        }
    }
}
