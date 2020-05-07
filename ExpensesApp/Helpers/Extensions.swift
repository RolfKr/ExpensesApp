//
//  Extensions.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 01/05/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

extension String {
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
}

extension UIViewController {
    
    func showPopupAlert(on view: UIView, message: String) {
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.alpha = 0.0
        containerView.layer.cornerRadius = 12
        view.addSubview(containerView)
        let messageLabel = UILabel()
        messageLabel.minimumScaleFactor = 0.6
        messageLabel.textColor = .red
        messageLabel.alpha = 0.0
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 60),
            
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .transitionCrossDissolve, animations: {
            containerView.alpha = 1.0
            messageLabel.alpha = 1.0
            view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 0.4, delay: 1.5, options: .transitionCrossDissolve, animations: {
                containerView.alpha = 0.0
                messageLabel.alpha = 0.0
                view.layoutIfNeeded()
            }) { (_) in
                messageLabel.removeFromSuperview()
                containerView.removeFromSuperview()
            }
        }
    }
}
