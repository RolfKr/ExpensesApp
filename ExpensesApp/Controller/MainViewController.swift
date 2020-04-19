//
//  ViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 16/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cardBehind: UIView!
    @IBOutlet weak var cardFront: UIView!
    @IBOutlet weak var monthlyBudgetLabel: UILabel!
    @IBOutlet weak var totalExpensesLabel: UILabel!
    @IBOutlet weak var progressContainer: UIView!
    @IBOutlet weak var expensesBtn: UIButton!
    @IBOutlet weak var incomeBtn: UIButton!
    @IBOutlet weak var progress: UIView!
    @IBOutlet weak var progressConstraint: NSLayoutConstraint!
    
    var items = [Item]()
    var monthlyBudget = 1500.00
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        intitialSetup()
        progressConstraint.constant = progress.frame.width
        items = PersistenceManager.fetchItems()
        items = items.filter({ item in checkDataSelectedDate(date: item.date)})
        updateUI()
    }
    
    private func intitialSetup() {
        Constants.shared.setBackgroundGradient(for: view)
        cardBehind.layer.cornerRadius = 60
        cardFront.layer.cornerRadius = 60
        progressContainer.layer.cornerRadius = 6
        progressConstraint.constant = progress.frame.width
    }
    
    @IBAction func expensesBtnTapped(_ sender: UIButton) {
        print("Expenses tapped")
    }
    
    @IBAction func incomeBtnTapped(_ sender: UIButton) {
        print("Income tapped")
    }
    
    private func checkDataSelectedDate(date: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
        let compOne = calendar.dateComponents([.month, .year], from: now)
        let compTwo = calendar.dateComponents([.month, .year], from: date)
        
        if compOne == compTwo {
            return true
        } else {
            return false
        }
    }
    
    private func calculateTotalExpenses() -> Double {
        var totalExpenses = 0.0
        for item in items {
            if item.category.categoryType != "Income" {
                totalExpenses += item.amount
            }
        }
        return totalExpenses
    }
    
    private func calculateProgressbar() -> CGFloat {
        let budgetPercentage = (calculateTotalExpenses() / monthlyBudget)
        let progressWidth = progressContainer.frame.width
        let constraintConstant = progressWidth - (CGFloat(budgetPercentage) * progressWidth)
        
        if abs(constraintConstant) <= progressWidth && budgetPercentage < 1.0 {
            return constraintConstant
        } else {
            return 0
        }
    }
    
    private func updateUI() {
        totalExpensesLabel.text = "$\(calculateTotalExpenses())"
        progressConstraint.constant = calculateProgressbar()
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
        }
        
        tableView.reloadData()
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as! ExpenseCell
        let item = items[indexPath.row]
        
        cell.configureCell(image: UIImage(named: "restaurant")!, category: item.category.name, budgetAmount: "45", moneyLabel: "\(item.amount)", transactions: "9")
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            PersistenceManager.persistentContainer.viewContext.delete(item)
            PersistenceManager.saveContext()
            
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            updateUI()
        }
    }
}
