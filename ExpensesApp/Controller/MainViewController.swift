//
//  ViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 16/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var monthLabel: UILabel!
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
    
    var selectedMonth = Date()
    var items: [Item]! {
        didSet {
            updateUI()
        }
    }

    var fetchControllerSettings: NSFetchedResultsController<Settings>! {
        didSet {
            let currencyIcon = fetchControllerSettings.fetchedObjects?.first?.currencyIcon ?? "$"
            let budget = fetchControllerSettings.fetchedObjects?.first?.budget ?? 1000
            monthlyBudgetLabel.text = "\(currencyIcon) \(budget) remaining"
        }
    }
    
    var categories = [ExpenseCategory]()
    var monthlyBudget = 1500.00
    var expensesSelected = true {
        didSet {
            if expensesSelected {
                expensesBtn.setTitleColor(.label, for: .normal)
                incomeBtn.setTitleColor(.lightGray, for: .normal)
            } else {
                expensesBtn.setTitleColor(.lightGray, for: .normal)
                incomeBtn.setTitleColor(.label, for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        intitialSetup()
        progressConstraint.constant = progress.frame.width
        filterCategories()
        updateUI()
    }
    
    private func intitialSetup() {
        loadItems()
        loadSettings()
        Constants.shared.setBackgroundGradient(for: view)
        cardBehind.layer.cornerRadius = 60
        cardFront.layer.cornerRadius = 60
        progressContainer.layer.cornerRadius = 6
        progressConstraint.constant = progress.frame.width
        monthlyBudget = FetchRequest.fetchControllerSettings.fetchedObjects?.first?.budget ?? 0.0
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        filterCategories()
        updateUI()
    }
    
    private func loadItems() {
        FetchRequest.loadItems()
        FetchRequest.fetchControllerItems.delegate = self

    }
    
    private func loadSettings() {
        FetchRequest.loadSettings()
        tableView.reloadData()
    }
    
    private func filterCategories() {
        categories = []
        
        var categoryExpenses = ["Income" : 0.0, "Entertainment" : 0.0, "Education" : 0.0, "Shopping" : 0.0, "Personal Care" : 0.0,
                                "Health & Fitness" : 0.0, "Kids" : 0.0, "Food & Dining" : 0.0, "Gifts & Donations" : 0.0,
                                "Investments" : 0.0, "Bills & Utilities" : 0.0, "Transport" : 0.0, "Travel" : 0.0,
                                "Fees & Charges" : 0.0, "Business Services" : 0.0]
              
        items = FetchRequest.fetchControllerItems.fetchedObjects!.filter({ item in
            let calendar = Calendar.current
            let selectedMonth = calendar.dateComponents([.month, .year], from: self.selectedMonth)
            let itemMonth = calendar.dateComponents([.month, .year], from: item.date)
            return selectedMonth == itemMonth
        })
        
        for item in items {
            var currentAmount = categoryExpenses[item.category.categoryType]!
            currentAmount += item.amount
            categoryExpenses[item.category.categoryType] = currentAmount
        }
        
        for categoryExpense in categoryExpenses where categoryExpense.value != 0.0 {
            if categoryExpense.key != "Income" {
                let category = ExpenseCategory(category: categoryExpense.key, amount: categoryExpense.value)
                self.categories.append(category)
            }
        }
        
        for category in categories {
            
            print(category.category)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func expensesBtnTapped(_ sender: UIButton) {
        expensesSelected = true
        tableView.reloadData()
    }
    
    @IBAction func incomeBtnTapped(_ sender: UIButton) {
        expensesSelected = false
        tableView.reloadData()
    }
    
    @IBAction func nextMonthBtntapped(_ sender: UIButton) {
        var dateComponent = DateComponents()
        dateComponent.month = 1
        selectedMonth = Calendar.current.date(byAdding: dateComponent, to: selectedMonth)!
        filterCategories()
        updateUI()
    }
    
    @IBAction func previousMonthBtntapped(_ sender: UIButton) {
        var dateComponent = DateComponents()
        dateComponent.month = -1
        selectedMonth = Calendar.current.date(byAdding: dateComponent, to: selectedMonth)!
        filterCategories()
        updateUI()
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
    
    private func calculateBudgetPercentage(totalAmount: Double, categoryAmount: Double) -> Int {
        return Int((categoryAmount / totalAmount) * 100)
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
    
    private func calculateTransactions(for category: ExpenseCategory) -> Int {
        var total = 0
        
        for item in FetchRequest.fetchControllerItems.fetchedObjects! {
            if item.category.categoryType == category.category {
                total += 1
            }
        }
        
        return total
    }
    
    private func updateUI() {
        print("*****")
        print(calculateTotalExpenses())
        
        let currencyIcon = FetchRequest.fetchControllerSettings.fetchedObjects?.first?.currencyIcon ?? "$"
        let budget = FetchRequest.fetchControllerSettings.fetchedObjects?.first?.budget ?? 1000
        
        totalExpensesLabel.text = "\(currencyIcon) \(calculateTotalExpenses())"
        progressConstraint.constant = calculateProgressbar()
        
        let remainingBudget = budget - calculateTotalExpenses()
        monthlyBudgetLabel.text = "\(currencyIcon) \(remainingBudget) remaining"
        
        let months = ["January", "Feburary", "March", "April", "May", "June", "July", "August", "September", "Oktober", "November", "December"]
        let calendar = Calendar.current
        let month = calendar.component(.month, from: selectedMonth)
        monthLabel.text = months[month - 1]
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
        }
        
        tableView.reloadData()
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expensesSelected {
            print("number of rows: \(categories.count)")
            return categories.count
        } else {
            return FetchRequest.fetchControllerItems.fetchedObjects!.filter({ $0.category.categoryType == "Income" }).count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as! ExpenseCell
        let budget = FetchRequest.fetchControllerSettings.fetchedObjects?.first?.budget ?? 1000
        let currencyIcon = FetchRequest.fetchControllerSettings.fetchedObjects?.first?.currencyIcon ?? "$"
        
        if expensesSelected {
            print(categories.count)
            let category = categories[indexPath.row]
            cell.configureCell(image: UIImage(named: "restaurant")!, category: category.category, budgetAmount: "\(calculateBudgetPercentage(totalAmount: budget, categoryAmount: category.amount))", moneyLabel: "\(currencyIcon) \(category.amount)", transactions: "\(calculateTransactions(for: category)) transactions")
        } else {
            let filteredOnIncome = FetchRequest.fetchControllerItems.fetchedObjects!.filter({ $0.category.categoryType == "Income" })
            
            let item = filteredOnIncome[indexPath.row]
            cell.configureCell(image: UIImage(named: "restaurant")!, category: item.category.name, budgetAmount: "", moneyLabel: "\(currencyIcon) \(item.amount)", transactions: "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
