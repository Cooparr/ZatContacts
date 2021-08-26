//
//  ZCTextFieldCell.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 26/08/2021.
//

import UIKit

//MARK:- ZCStaticCell
class ZCStaticCell: UITableViewCell {
    static let reuseId = "staticCellId"
}


//MARK:- ZCTextFieldCell
class ZCTextFieldCell: ZCStaticCell {
    
    //MARK: Properties
    let textField = ZCTextField()
    
    
    //MARK: Init
    init(placeholder: String, contentType: UITextContentType, keyboardType: UIKeyboardType = .default, isRequiredField: Bool = false) {
        super.init(style: .default, reuseIdentifier: ZCStaticCell.reuseId)
        
        textField.placeholder = placeholder
        textField.textContentType = contentType
        textField.keyboardType = keyboardType
        
        if isRequiredField {
            let attributedString = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: ThemeColor.accentColor])
            textField.attributedPlaceholder = attributedString
        }
        
        constrainTextField()
    }
    
    
    //MARK: Constrain TextField
    private func constrainTextField() {
        contentView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
