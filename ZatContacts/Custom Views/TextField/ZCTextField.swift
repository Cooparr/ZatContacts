//
//  ZCTextField.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 24/08/2021.
//

import UIKit

class ZCTextField: UITextField {

    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        clearButtonMode = .whileEditing
    }
    
    
    //MARK: Add Padding to Textfield
    private let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
