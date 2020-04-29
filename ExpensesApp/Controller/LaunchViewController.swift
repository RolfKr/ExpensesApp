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

class LaunchViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var fetchControllerItems: NSFetchedResultsController<Item>!
    var fetchControllerSettings: NSFetchedResultsController<Settings>!
    var fetchControllerCategories: NSFetchedResultsController<Category>!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults.standard
        
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
                print("")
            }
        }
    }
    
    private func presentMainViewController() {
        guard let vc = storyboard?.instantiateViewController(identifier: "TabBar") as? UITabBarController else {return}
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
