//
//  UIViewController.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 25/08/2021.
//

import UIKit

extension UIViewController {
    
    //MARK: Present GFAlert On Main Thread
    func presentErrorAlertOnMainThread(title: String, message: String, buttonTitle: String = "Ok") {
        DispatchQueue.main.async {
            let alertVC = ZCErrorAlertVC(alertTitle: title, alertMessage: message, buttonTitle: buttonTitle)
            self.present(alertVC, animated: true)
        }
    }
}
