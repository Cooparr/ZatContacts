//
//  AddContactProgrammaticView.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 26/08/2021.
//

import UIKit

class AddContactProgrammaticView: UIView {
    
    //MARK:- Properties
    private let requiredLabel = ZCLabel(style: .footnote, alignment: .center, fontColor: ThemeColor.accentColor, lblText: "Required Fields")
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ZCStaticCell.reuseId)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .systemBackground
        tableView.allowsSelection = false
        return tableView
    }()
    
    //MARK:- Form Section Struct
    struct FormSection {
        let title: String
        let cells: [ZCStaticCell]
    }
    
    let formSections: [FormSection]

    let salutationCell      = ZCSalutationCell()
    let firstNameCell       = ZCTextFieldCell(placeholder: "First Name", contentType: .givenName, isRequiredField: true)
    let middleNameCell      = ZCTextFieldCell(placeholder: "Middle Name", contentType: .middleName)
    let lastNameCell        = ZCTextFieldCell(placeholder: "Last Name", contentType: .familyName, isRequiredField: true)
    let birthdayCell        = ZCBirthdayCell()
    
    let phoneNumberCell     = ZCTextFieldCell(placeholder: "Phone Number", contentType: .telephoneNumber, keyboardType: .phonePad, isRequiredField: true)
    let emailAddressCell    = ZCTextFieldCell(placeholder: "Email Address", contentType: .emailAddress, keyboardType: .emailAddress)
    
    let streetLineOneCell   = ZCTextFieldCell(placeholder: "Street Line 1", contentType: .streetAddressLine1)
    let streetLineTwoCell   = ZCTextFieldCell(placeholder: "Street Line 2", contentType: .streetAddressLine2)
    let cityCell            = ZCTextFieldCell(placeholder: "City", contentType: .addressCity)
    let postcodeCell        = ZCTextFieldCell(placeholder: "Postcode", contentType: .postalCode, capitalizeType: .allCharacters)
    
    
    //MARK: Init
    override init(frame: CGRect) {
        self.formSections = [
            FormSection(title: "Contact Information", cells: [salutationCell, firstNameCell, middleNameCell, lastNameCell, birthdayCell]),
            FormSection(title: "Contact Details",cells: [phoneNumberCell, emailAddressCell]),
            FormSection(title: "Address", cells: [streetLineOneCell, streetLineTwoCell, cityCell, postcodeCell])
        ]
        
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        constrainTableView()
        setupTableFooterView()
    }
    
    
    //MARK: Constrain Table View
    private func constrainTableView() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    //MARK: Setup Table Footer View
    func setupTableFooterView() {
        let footerView = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        tableView.tableFooterView = footerView
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: Double.leastNormalMagnitude))

        footerView.addSubview(requiredLabel)
        NSLayoutConstraint.activate([
            requiredLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            requiredLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
