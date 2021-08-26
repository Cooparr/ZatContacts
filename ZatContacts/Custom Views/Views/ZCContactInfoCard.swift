//
//  ZCContactInfoCard.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 25/08/2021.
//

import UIKit

class ZCContactInfoCard: UIView {
    
    //MARK: Properties
    private let containerTitleLabel = ZCLabel(style: .subheadline, fontColor: .secondaryLabel)
    private let contactInfoTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .label
        textView.backgroundColor = .secondarySystemBackground
        return textView
    }()
    
    
    //MARK: Init
    init(dataType: UIDataDetectorTypes? = nil) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        
        
        constrainSubviews()
        
        if let dataDetectorType = dataType {
            contactInfoTextView.dataDetectorTypes = dataDetectorType
        }
    }
    
    
    //MARK Setup Info Card
    func setInfoCard(with cardTitle: String, and cardInfo: String?) {
        containerTitleLabel.text = cardTitle
        contactInfoTextView.text = cardInfo
    }
    
    
    //MARK: Constrain Subviews
    private func constrainSubviews() {
        addSubviews(containerTitleLabel, contactInfoTextView)
        NSLayoutConstraint.activate([
            containerTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            contactInfoTextView.topAnchor.constraint(equalToSystemSpacingBelow: containerTitleLabel.bottomAnchor, multiplier: 0.5),
            contactInfoTextView.leadingAnchor.constraint(equalTo: containerTitleLabel.leadingAnchor),
            contactInfoTextView.trailingAnchor.constraint(equalTo: containerTitleLabel.trailingAnchor),
            contactInfoTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
