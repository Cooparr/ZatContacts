//
//  UITableView.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 27/08/2021.
//

import UIKit

extension UITableView {
    
    //MARK: Should Display Empty Message If
    func shouldDisplayEmptyMessage(if isEmpty: Bool, message: String) {
        guard isEmpty else { return self.backgroundView = nil }
        self.setEmptyMessage(message)
    }
    
    
    //MARK: Set Empty Message
    private func setEmptyMessage(_ message: String) {
        let emptyMessage = ZCLabel(style: .body, weight: .medium, alignment: .center, fontColor: ThemeColor.accentColor, lblText: message)
        emptyMessage.sizeToFit()
        
        let messageContainer = UIView()
        messageContainer.addSubview(emptyMessage)
        emptyMessage.pinSubview(to: messageContainer)
        
        self.backgroundView = messageContainer
    }
}
