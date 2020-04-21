//
//  SettingsViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 17/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
//            createAlert(title: "Budget", message: "Enter a budget")
            break
        case 1:
            let dollarAction = UIAlertAction(title: "Dollar", style: .default, handler: nil)
            let kronerAction = UIAlertAction(title: "Kroner", style: .default, handler: nil)
            let euroAction = UIAlertAction(title: "Euro", style: .default, handler: nil)
            let actions = [dollarAction, kronerAction, euroAction]
            createAlert(title: nil, message: nil, actions: actions)
        case 2:
            let lightAction = UIAlertAction(title: "Light", style: .default, handler: nil)
            let darkAction = UIAlertAction(title: "Dark", style: .default, handler: nil)
            let systemAction = UIAlertAction(title: "System", style: .default, handler: nil)
            let actions = [lightAction, darkAction, systemAction]
            createAlert(title: nil, message: nil, actions: actions)
            break
        default:
            break
        }
    }
    
    private func createAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
}
