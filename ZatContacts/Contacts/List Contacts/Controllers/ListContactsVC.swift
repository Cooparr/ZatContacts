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
    private var contactsDatasource = [[Contact]]()
    private var sectionHeaders = [String]()

    
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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbol.addContact, style: .plain, target: self, action: #selector(addContactTapped))
    }
    
    
    //MARK:- Assign Delegates
    private func assignDelegates() {
        contactsView.contactsTableView.delegate = self
        contactsView.contactsTableView.dataSource = self
    }
    
    
    //MARK:- Fetch Contacts
    private func fetchContacts() {
        FirebaseManager.fetchUsersContacts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let contacts):
                self.contactsDatasource = self.splitContactsIntoAlphabeticalSubArrays(fetchedContacts: contacts)
                self.updateContactListSectionHeaders()
                self.contactsView.contactsTableView.reloadData()
                
            case .failure(let error):
                self.presentErrorAlertOnMainThread(title: "Fetch Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
    
    
    //MARK: Create Alphabetical Sub Arrays
    private func splitContactsIntoAlphabeticalSubArrays(fetchedContacts: [Contact]) -> [[Contact]] {
        let alphabeticalSubArryas = Array(
            Dictionary(grouping: fetchedContacts) {
                $0.lastName.lowercased().prefix(1)
            }.values).sorted { lhs, rhs in
                return lhs[0].lastName < rhs[0].lastName
            }
        
        return alphabeticalSubArryas
    }
    
    
    //MARK: Update Section Headers
    private func updateContactListSectionHeaders() {
        sectionHeaders.removeAll()
        contactsDatasource.forEach { contactSection in
            guard let firstCharOfLastName = contactSection.first?.lastName.prefix(1) else { return }
            let character = String(firstCharOfLastName).uppercased()
            sectionHeaders.append(character)
        }
    }
    
    
    //MARK:- Add Contact Action
    @objc func addContactTapped() {
        let addContactVC = UINavigationController(rootViewController: AddContactVCProgrammatic())
//        let addContactVC = UIStoryboard(name: AddContactVCStoryboard.identifier, bundle: nil).instantiateViewController(withIdentifier: AddContactVCStoryboard.identifier)
        navigationController?.present(addContactVC, animated: true)
    }
}


//MARK: Table View Delegates & Datasource
extension ListContactsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactsDatasource.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsDatasource[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactsCell.cellId, for: indexPath) as? ContactsCell else { return UITableViewCell() }
        cell.configureCell(with: contactsDatasource[indexPath.section][indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedContact = contactsDatasource[indexPath.section][indexPath.row]
        let detailContactVC = DetailedContactVC(contact: selectedContact)
        navigationController?.pushViewController(detailContactVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
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


//MARK: Delete & Update Swipe Actions
extension ListContactsVC {
    private func handleDeleteAction(for tableView: UITableView, _ indexPath: IndexPath) -> UIContextualAction {
        return UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, isComplete in
            guard let self = self else { return }
            let contactToDelete = self.contactsDatasource[indexPath.section][indexPath.row]
            self.contactsDatasource[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
            FirebaseManager.deleteContact(contactId: contactToDelete.uuid) { result in
                switch result {
                case .success:
                    isComplete(true)
                case .failure(let error):
                    self.presentErrorAlertOnMainThread(title: "Error Deleting", message: error.localizedDescription, buttonTitle: "Ok")
                    isComplete(false)
                }
            }
        }
    }
    
    
    private func handleUpdateAction(_ indexPath: IndexPath) -> UIContextualAction {
        return UIContextualAction(style: .normal, title: "Update") { [weak self] _, _, isComplete in
            guard let self = self else { return }

            let updateStoryboard = UIStoryboard(name: AddContactVCStoryboard.identifier, bundle: nil)
            guard let updateContactVC = updateStoryboard.instantiateViewController(withIdentifier: "AddContactFormV2") as? AddContactVCStoryboard else { return }
            
            let navCont = UINavigationController(rootViewController: updateContactVC)
            updateContactVC.contactToUpdate = self.contactsDatasource[indexPath.section][indexPath.row]
            self.present(navCont, animated: true)
            isComplete(true)
        }
    }
}
