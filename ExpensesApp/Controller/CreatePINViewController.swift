//
//  CreatePINViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 29/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import LocalAuthentication

class CreatePINViewController: UIViewController {

    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var createPinLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    
    let defaults = UserDefaults.standard
    var fromSettings = false
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pinTextField.delegate = self
        if fromSettings == true {
            skipButton.setTitle("Dismiss", for: .normal)
        } else {
            skipButton.setTitle("SKIP", for: .normal)
        }
    }
    
    private func goToMainVC() {
        DispatchQueue.main.async {
            guard let tabBar = self.storyboard?.instantiateViewController(identifier: "TabBar") as? UITabBarController else {return}
            tabBar.modalPresentationStyle = .fullScreen
            self.present(tabBar, animated: true)
        }
    }

    @IBAction func enterBtnTapped(_ sender: UIButton) {
        guard !pinTextField.text!.isEmpty else {return}
        configureBiometrics()
        defaults.set(true, forKey: "useSecurity")
        defaults.set(pinTextField.text!, forKey: "unlockPIN")
    }
    
    
    @IBAction func skipBtnTapped(_ sender: UIButton) {
        if !fromSettings {
            goToMainVC()
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func tappedBackground(_ sender: UITapGestureRecognizer) {
        pinTextField.resignFirstResponder()
    }
    
    
    private func configureBiometrics() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please identify yourself") { [weak self] (success, error) in
                if success {
                    print("FaceID activated")
                    self?.goToMainVC()
                }
            }
        } else {
            print("No biometry")
            goToMainVC()
        }
    }
    
}

extension CreatePINViewController: UITextFieldDelegate {
    
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
