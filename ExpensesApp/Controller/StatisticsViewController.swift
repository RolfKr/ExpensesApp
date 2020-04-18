//
//  StatisticsViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 17/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var totalIncomeContainer: UIView!
    @IBOutlet weak var totalExpensesContainer: UIView!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var totalExpensesLabel: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var chartContainerView: UIView!
    
    var items = [Item]()
    var totalExpenses = 0.0
    var totalIncome = 0.0

    override func viewDidAppear(_ animated: Bool) {
        initialSetup()
        calculate()
    }
    
    private func initialSetup() {
        Constants.shared.setBackgroundGradient(for: view)
        totalIncomeContainer.layer.cornerRadius = 8
        totalExpensesContainer.layer.cornerRadius = 8
        background.layer.cornerRadius = 60
        items = PersistenceManager.fetchItems()
        items = items.filter({ item in checkDataSelectedDate(date: item.date)})
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
    
    private func updateUI() {
        totalExpensesLabel.text = "$\(totalExpenses)"
        totalIncomeLabel.text = "$\(totalIncome)"
    }
    
    private func calculate() {
        for item in items {
            if item.category.categoryType == "Income" {
                totalIncome += item.amount
            } else {
                totalExpenses += item.amount
            }
        }
        
        updateUI()
    }

}
