//
//  DetailedContactView.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 25/08/2021.
//

import UIKit

class DetailedContactView: UIView {
    
    //MARK: Properties
    let nameLabel = ZCLabel(style: .largeTitle, alignment: .center)
    let phoneCard = ZCContactInfoCard(dataType: .phoneNumber)
    let emailCard = ZCContactInfoCard(dataType: .link)
    let addressCard = ZCContactInfoCard(dataType: .address)
    let birthdayCard = ZCContactInfoCard()
    let callContactButton = ZCButton(heightConstant: 50)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        return stack
    }()
    
    
    //MARK: Required Init
    func setupView(with contact: Contact) {
        backgroundColor = .systemBackground
        constrainNameLabel()
        constrainScrollView()
        constrainStackView()
        
        
        nameLabel.text = contact.fullName
        updateCardInfo(for: phoneCard, with: "Phone Number", and: contact.phoneNumber)
        updateCardInfo(for: emailCard, with: "Email Address", and: contact.email)
        updateCardInfo(for: birthdayCard, with: "Date of Birth", and: contact.birthday)
        updateCardInfo(for: addressCard, with: "Address", and: contact.address?.fullAddress)
        callContactButton.set(backgroundColor: ThemeColor.accentColor, title: "Call \(contact.firstName)")
        stackView.addArrangedSubview(callContactButton)
        stackView.addArrangedSubview(UIView())
    }
    
    
    //MARK: Setup Contact Card
    private func updateCardInfo(for contactCard: ZCContactInfoCard, with title: String, and contactInfo: String?) {
        guard let contactInfo = contactInfo, !contactInfo.isEmpty else { return }
        contactCard.setInfoCard(with: title, and: contactInfo)
        stackView.addArrangedSubview(contactCard)
    }
    
    
    //MARK: Constrain Name Label
    private func constrainNameLabel() {
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: safeAreaLayoutGuide.topAnchor, multiplier: 3.5),
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    
    //MARK: Constrain Scroll View
    private func constrainScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 3.5),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    
    //MARK: Constrain Stack View
    private func constrainStackView() {
        stackView.addArrangedSubview(phoneCard)
        stackView.pinSubview(to: scrollView)
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
}
