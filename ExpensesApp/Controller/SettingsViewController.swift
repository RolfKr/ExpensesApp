//
//  SettingsViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 17/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication

class SettingsViewController: UITableViewController, ChangedSecurity {
    
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var lockSwitch: UISwitch!
    
    var settings: Settings!
    let defaults = UserDefaults.standard
    
    override func viewDidAppear(_ animated: Bool) {
        if let useSecurity = defaults.value(forKey: "useSecurity") as? Bool {
            if useSecurity == true {
                lockSwitch.isOn = true
            } else {
                lockSwitch.isOn = false
            }
        } else {
            lockSwitch.isOn = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checkBiometrics = defaults.value(forKey: "useSecurity") as? Bool {
            print(checkBiometrics)
            lockSwitch.isOn = checkBiometrics
        }
        
        loadSettings()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "DarkBlueGradient")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    private func loadSettings() {
        guard let fetchedSettings = FetchRequest.fetchControllerSettings.fetchedObjects?.first else {return}
        print("Got Settings")
        settings = fetchedSettings
        
        budgetLabel.text = String(settings.budget)
        themeLabel.text = settings.theme
        currencyLabel.text = settings.currency
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            selectBudget()
        case 1:
            let dollarAction = UIAlertAction(title: "Dollar", style: .default, handler: selectcurrency(sender:))
            let kronerAction = UIAlertAction(title: "Kroner", style: .default, handler: selectcurrency(sender:))
            let euroAction = UIAlertAction(title: "Euro", style: .default, handler: selectcurrency(sender:))
            let actions = [dollarAction, kronerAction, euroAction]
            createAlert(title: nil, message: nil, actions: actions)
        case 2:
            let lightAction = UIAlertAction(title: "Light", style: .default, handler: selectTheme(sender:))
            let darkAction = UIAlertAction(title: "Dark", style: .default, handler: selectTheme(sender:))
            let systemAction = UIAlertAction(title: "System", style: .default, handler: selectTheme(sender:))
            let actions = [lightAction, darkAction, systemAction]
            createAlert(title: nil, message: nil, actions: actions)
            break
        case 3:
            if lockSwitch.isOn {
                lockSwitch.setOn(false, animated: true)
                configureSecurity()
            } else {
                lockSwitch.setOn(true, animated: true)
                configureSecurity()
            }
        default:
            break
        }
    }
    
    @IBAction func lockSwitchChanged(_ sender: UISwitch) {
        configureSecurity()
    }
    
    internal func didFinishEnteringPIN() {
        defaults.set(self.lockSwitch.isOn, forKey: "useSecurity")
    }
    
    private func configureSecurity() {
        if let _ = defaults.value(forKey: "useSecurity") {
            if let _ = defaults.value(forKey: "havePIN") {
                presentEnterPINView()
                didFinishEnteringPIN()
            } else {
                presentCreatePINView()
            }
            
        } else {
            if lockSwitch.isOn {
                presentCreatePINView()
            }
        }
    }
    
    private func presentCreatePINView() {
        guard let createPinVC = storyboard?.instantiateViewController(identifier: "createPIN") as? CreatePINViewController else {return}
        createPinVC.modalPresentationStyle = .fullScreen
        createPinVC.fromSettings = true
        present(createPinVC, animated: true)
    }
    
    private func presentEnterPINView() {
        guard let enterPINView = storyboard?.instantiateViewController(identifier: "LaunchVC") as? LaunchViewController else {return}
        enterPINView.fromSettings = true
        enterPINView.delegate = self
        present(enterPINView, animated: true)
    }
    
    private func selectcurrency(sender: UIAlertAction) {
        guard let currency = sender.title else {return}
        currencyLabel.text = currency
        settings.setValue(currency, forKey: "currency")
        
        switch sender.title {
        case "Dollar":
            settings.setValue("$", forKey: "currencyIcon")
        case "Kroner":
            settings.setValue("kr", forKey: "currencyIcon")
        case "Euro":
            settings.setValue("€", forKey: "currencyIcon")
        default:
            break
        }
        
        PersistenceManager.saveContext()
    }
    
    private func selectTheme(sender: UIAlertAction) {
        guard let theme = sender.title else {return}
        themeLabel.text = theme
        settings.setValue(theme, forKey: "theme")
        PersistenceManager.saveContext()
    }
    
    private func selectBudget() {
        let alert = UIAlertController(title: "Monthly Budget".localized(), message: "Enter a monthly budget".localized(), preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter budget here"
        }
        
        let changeBudgetAction = UIAlertAction(title: "Change", style: .default) { (_) in
            guard let enteredBudget = alert.textFields?.first?.text,
                !enteredBudget.isEmpty else {return}
            guard let budget = Double(enteredBudget) else {return}
            
            self.budgetLabel.text = String(budget)
            self.settings.setValue(budget, forKey: "budget")
            PersistenceManager.saveContext()
        }
        
        alert.addAction(changeBudgetAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func createAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
}
