//
//  ZCLabel.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 26/08/2021.
//

import UIKit

class ZCLabel: UILabel {
    
    // Init
    init(style: UIFont.TextStyle, weight: UIFont.Weight = .regular, alignment: NSTextAlignment = .natural, fontColor: UIColor = .label, lblText: String? = nil) {
        super.init(frame: .zero)
        font = UIFont.preferredFont(for: style, weight: weight)
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        lineBreakMode = .byWordWrapping
        minimumScaleFactor = 0.75
        textAlignment = alignment
        textColor = fontColor
        text = lblText
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
