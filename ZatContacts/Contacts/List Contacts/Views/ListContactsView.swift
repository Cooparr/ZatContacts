//
//  ContactView.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 24/08/2021.
//

import UIKit

class ListContactsView: UIView {

    //MARK: Properties
    let contactsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ContactsCell.self, forCellReuseIdentifier: ContactsCell.cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(contactsTableView)
        contactsTableView.pinSubview(to: self)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
