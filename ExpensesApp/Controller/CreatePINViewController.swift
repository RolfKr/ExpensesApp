//
//  CreatePINViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 29/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

class CreatePINViewController: UIViewController {

    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var createPinLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinTextField.delegate = self
    }

    @IBAction func enterBtnTapped(_ sender: UIButton) {
        guard !pinTextField.text!.isEmpty else {return}
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
