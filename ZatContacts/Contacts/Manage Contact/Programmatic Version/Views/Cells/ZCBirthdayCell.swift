//
//  ZCBirthdayCell.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 26/08/2021.
//

import UIKit

class ZCBirthdayCell: ZCStaticCell {
    
    //MARK: Properties
    private let dateOfBirthLabel = ZCLabel(style: .body, fontColor: .tertiaryLabel, lblText: "Date of Birth:")
    let birthdayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        return picker
    }()
    
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = ZCStaticCell.reuseId) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews(dateOfBirthLabel, birthdayPicker)
        NSLayoutConstraint.activate([
            dateOfBirthLabel.topAnchor.constraint(equalTo: topAnchor),
            dateOfBirthLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            dateOfBirthLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),
            dateOfBirthLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            birthdayPicker.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            birthdayPicker.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.35),
            birthdayPicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            birthdayPicker.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
