//
//  ZCSalutationCell.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 26/08/2021.
//

import UIKit

class ZCSalutationCell: ZCStaticCell {

    //MARK: Properties
    private let salutationLabel = ZCLabel(style: .body, fontColor: ThemeColor.accentColor, lblText: "Salutation:")
    let salutationSegmentControl: UISegmentedControl = {
        let segCont = UISegmentedControl(items: Salutation.allCases.map { $0.rawValue })
        segCont.translatesAutoresizingMaskIntoConstraints = false
        segCont.selectedSegmentIndex = 0
        return segCont
    }()
    
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = ZCStaticCell.reuseId) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews(salutationLabel, salutationSegmentControl)
        NSLayoutConstraint.activate([
            salutationLabel.topAnchor.constraint(equalTo: topAnchor),
            salutationLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            salutationLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.35),
            salutationLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            salutationSegmentControl.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            salutationSegmentControl.leadingAnchor.constraint(equalTo: salutationLabel.trailingAnchor),
            salutationSegmentControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            salutationSegmentControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
