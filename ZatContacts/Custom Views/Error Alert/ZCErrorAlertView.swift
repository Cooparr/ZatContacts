//
//  ZCErrorAlertView.swift
//  ZatContacts
//
//  Created by Alexander James Cooper on 26/08/2021.
//

import UIKit

class ZCErrorAlertView: UIView {
    
    //MARK: Properties
    private let containerView = ZCAlertContainer()
    private let titleLabel = ZCLabel(style: .title3, weight: .bold, alignment: .center)
    private let messageLabel = ZCLabel(style: .body, alignment: .center, fontColor: .secondaryLabel)
    private(set) var actionButton = ZCButton(backgroundColor: ThemeColor.accentColor, title: "Ok")
    
    private let padding: CGFloat = 20
    
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureTitleLabel()
        configureAlertButton()
        configureMessageLabel()
    }
    
    
    //MARK: Configure Error View
    func configureErrorView(_ alertTitle: String, _ alertMessage: String, _ buttonTitle: String) {
        titleLabel.text = alertTitle
        actionButton.setTitle(buttonTitle, for: .normal)
        messageLabel.text = alertMessage
    }
    
    
    //MARK: Configure Container View
    private func configureContainerView() {
        addSubview(containerView)
        containerView.addSubviews(titleLabel, actionButton, messageLabel)
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    
    //MARK: Configure Title Label
    private func configureTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    
    //MARK: Configure Alert Button
    private func configureAlertButton() {
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    //MARK: Configure Message Label
    private func configureMessageLabel() {
        messageLabel.numberOfLines = 4
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -8)
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
