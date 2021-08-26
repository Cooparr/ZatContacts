//
//  ContactCell.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 24/08/2021.
//

import UIKit

class ContactsCell: UITableViewCell {
    
    //MARK: Properties
    static let cellId = "contactCellId"
    
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    
    
    //MARK: Configure Cell
    func configureCell(with contact: Contact) {
        textLabel?.text = "\(contact.firstName) \(contact.lastName)"
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
