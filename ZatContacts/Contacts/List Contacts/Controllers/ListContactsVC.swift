//
//  ListContactsVC.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 24/08/2021.
//

import UIKit

class ListContactsVC: UIViewController {
    
    //MARK:- Properites
    private let contactsView = ListContactsView()
    private var sectionHeaders = [String?]()
    private var allContacts = [[Contact]]()
    private var filteredContacts = [[Contact]]()
    
    
    //MARK:- Load View
    override func loadView() {
        super.loadView()
        self.view = contactsView
    }
    
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        assignDelegates()
        fetchContacts()
    }

    
    //MARK:- Setup NavBar
    private func setupNavBar() {
        navigationItem.title = NavBarTitles.contacts
        navigationItem.searchController = contactsView.searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbol.addContact, style: .plain, target: self, action: #selector(addContactTapped))
    }
    
    
    //MARK:- Assign Delegates
    private func assignDelegates() {
        contactsView.contactsTableView.delegate = self
        contactsView.contactsTableView.dataSource = self
        contactsView.searchController.searchResultsUpdater = self
    }
    
    
    //MARK:- Fetch Contacts
    private func fetchContacts() {
        FirebaseManager.fetchUsersContacts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let contacts):
                self.allContacts = self.splitContactsIntoAlphabeticalSubArrays(fetchedContacts: contacts)
                self.updateTableView()
                
            case .failure(let error):
                self.presentErrorAlertOnMainThread(title: "Fetch Error", message: error.localizedDescription)
            }
        }
    }
    
    
    //MARK: Update Table View
    private func updateTableView() {
        guard let searchText = contactsView.searchController.searchBar.text else { return }
        
        switch searchText.isEmpty {
        case true:
            filteredContacts = allContacts

        case false:
            filteredContacts = allContacts.map { contactsForSection in
                contactsForSection.filter { contact in
                    let nameString = "\(contact.firstName) \(contact.lastName)"
                    guard let searchString = contactsView.searchController.searchBar.text else { return false }
                    return nameString.lowercased().contains(searchString.lowercased())
                }
            }
        }
        
        updateContactListSectionHeaders()
        contactsView.contactsTableView.reloadData()
    }
    
    
    //MARK: Create Alphabetical Sub Arrays
    private func splitContactsIntoAlphabeticalSubArrays(fetchedContacts: [Contact]) -> [[Contact]] {
        let alphabeticalSubArrays = Array(Dictionary(grouping: fetchedContacts) { $0.lastName.lowercased().first }.values)
            .sorted { lhs, rhs in
            return lhs[0].lastName < rhs[0].lastName
        }
        return alphabeticalSubArrays
    }
    
    
    //MARK: Update Section Headers
    private func updateContactListSectionHeaders() {
        sectionHeaders = allContacts.compactMap { contactsForSection in
            guard let firstChar = contactsForSection.first?.lastName.first else { return nil }
            return String(firstChar)
        }
    }
    
    
    //MARK:- Add Contact Action
    @objc func addContactTapped() {
        #warning("Storyboard or Programmatic Version")
//        let addContactVC = UIStoryboard(name: "AddContactForm", bundle: nil).instantiateViewController(withIdentifier: "ContactForm")
        let addContactVC = UINavigationController(rootViewController: AddContactVCProgrammatic())
        
        navigationController?.present(addContactVC, animated: true)
    }
}


//MARK: Table View Delegates & Datasource
extension ListContactsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredContacts.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactsCell.cellId, for: indexPath) as? ContactsCell else { return UITableViewCell() }
        cell.configureCell(with: filteredContacts[indexPath.section][indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedContact = filteredContacts[indexPath.section][indexPath.row]
        let detailContactVC = DetailedContactVC(contact: selectedContact)
        navigationController?.pushViewController(detailContactVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.numberOfRows(inSection: section) == 0 { return 0 }
        return 25
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = handleDeleteAction(for: tableView, indexPath)
        deleteAction.image = SFSymbol.trash

        let updateAction = handleUpdateAction(indexPath)
        updateAction.image = SFSymbol.edit
        updateAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
    }
}


extension ListContactsVC {
    
    //MARK: Delete Action
    private func handleDeleteAction(for tableView: UITableView, _ indexPath: IndexPath) -> UIContextualAction {
        return UIContextualAction(style: .destructive, title: NavBarBtnTitles.delete) { [weak self] _, _, isComplete in
            guard let self = self else { return isComplete(false) }
            let contactToDelete = self.filteredContacts[indexPath.section][indexPath.row]
            self.filteredContacts[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
            FirebaseManager.deleteContact(contactId: contactToDelete.uuid) { result in
                switch result {
                case .success:
                    isComplete(true)
                case .failure(let error):
                    self.presentErrorAlertOnMainThread(title: "Error Deleting", message: error.localizedDescription)
                    isComplete(false)
                }
            }
        }
    }
    
    
    //MARK: Update Action
    private func handleUpdateAction(_ indexPath: IndexPath) -> UIContextualAction {
        return UIContextualAction(style: .normal, title: NavBarBtnTitles.update) { [weak self] _, _, isComplete in
            guard let self = self else { return isComplete(false) }
            let contactToUpdate = self.filteredContacts[indexPath.section][indexPath.row]
            
            #warning("Storyboard or Programmatic Version")
//            let updateStoryboard = UIStoryboard(name: "AddContactForm", bundle: nil)
//            guard let updateContactVC = updateStoryboard.instantiateViewController(withIdentifier: "ContactForm") as? AddContactVCStoryboard else { return }
//            updateContactVC.contactToUpdate = contactToUpdate
            let updateContactVC = UpdateContactVCProgrammatic(contactToUpdate: contactToUpdate)
            
            let navCont = UINavigationController(rootViewController: updateContactVC)
            self.present(navCont, animated: true)
            isComplete(true)
        }
    }
}


//MARK: UI Search Results Updating Delegate
extension ListContactsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        updateTableView()
    }
}
