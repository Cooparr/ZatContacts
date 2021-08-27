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
    
    let searchController: UISearchController = {
        let searchBar = UISearchController()
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.placeholder = "Search for a contact."
        return searchBar
    }()
    
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(contactsTableView)
        NSLayoutConstraint.activate([
            contactsTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contactsTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contactsTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            contactsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
