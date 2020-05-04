//
//  LaunchViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 28/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication

protocol ChangedSecurity {
    func didFinishEnteringPIN()
}

class LaunchViewController: UIViewController {

    @IBOutlet weak var enterPinLabel: UILabel!
    @IBOutlet weak var pinTextField: UITextField!
    
    var delegate: ChangedSecurity?
    var fromSettings = false
    let defaults = UserDefaults.standard
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pinTextField.delegate = self
        if !fromSettings {
            if let useBiometrics = defaults.value(forKey: "useSecurity") as? Bool {
                if useBiometrics {
                    checkBiometrics()
                } else {
                    print("Use password")
                }
            } else {
                presentMainViewController()
            }
        }
    }
    
    private func checkBiometrics() {
        let context = LAContext()
        let reason = "Please identify yourself."
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self]
            success, authenticationError in
            
            if success {
                DispatchQueue.main.async {
                    self?.presentMainViewController()
                }
            } else {
                //TODO: Tell user that it failed. Use PIN instead.
            }
        }
    }
    
    @IBAction func enterBtnTapped(_ sender: UIButton) {
        guard let correctPin = defaults.value(forKey: "unlockPIN") as? String else {return}
        guard let enteredPin = pinTextField.text else {return}
        
        if enteredPin == correctPin {
            if fromSettings {
                defaults.set(true, forKey: "useSecurity")
                delegate?.didFinishEnteringPIN()
                dismiss(animated: true, completion: nil)
            } else {
                presentMainViewController()
            }
            
        } else {
            enterPinLabel.text = "Wrong PIN"
            enterPinLabel.textColor = .red
            
            // TODO: Animate the wrong pin label.
        }
    }
    
    
    private func presentMainViewController() {
        guard let vc = storyboard?.instantiateViewController(identifier: "TabBar") as? UITabBarController else {return}
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        pinTextField.resignFirstResponder()
    }
    
}

extension LaunchViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 4
    }
}
