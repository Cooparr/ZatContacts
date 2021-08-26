//
//  ZCErrorAlertVC.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 25/08/2021.
//

import UIKit

class ZCErrorAlertVC: UIViewController {

    //MARK: Properties
    private let errorView = ZCErrorAlertView()
    
    
    //MARK: Load View
    override func loadView() {
        super.loadView()
        self.view = errorView
    }
    
    
    //MARK: Custom Init
    init(alertTitle: String, alertMessage: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
        errorView.configureErrorView(alertTitle, alertMessage, buttonTitle)
        errorView.actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    
    //MARK: Dismiss VC Action
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
