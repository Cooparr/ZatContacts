//
//  UIView.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 25/08/2021.
//

import UIKit

extension UIView {
    
    //MARK: Add Subviews
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
    
    
    //MARK: Pin Subview
    func pinSubview(to superView: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
    }

    
    //MARK: Pin Subview (Padding All Sides)
    func pinSubviewWithPadding(to superView: UIView, allSides: CGFloat) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor, constant: allSides),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: allSides),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -allSides),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -allSides)
        ])
    }
}
