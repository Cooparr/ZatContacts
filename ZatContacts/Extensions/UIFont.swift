//
//  UIFont.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 25/08/2021.
//

import UIKit

extension UIFont {
    
    //MARK: Preferred Font + Weight
    static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}
