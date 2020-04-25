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
    
    var fetchControllerItems: NSFetchedResultsController<Item>!
    
    var categories = [ExpenseCategory]()
    
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

    var monthlyBudget = 1500.00
    var settings: Settings! {
        didSet {
            monthlyBudgetLabel.text = "\(settings.currencyIcon) \(settings.budget) remaining"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadItems()
        
        settings = PersistenceManager.fetchSettings()!
        //items = PersistenceManager.fetchItems()

        
        intitialSetup()
        
        progressConstraint.constant = progress.frame.width
        //items = items.filter({ item in checkDataSelectedDate(date: item.date)})
        //filteredItemIncomes = items.filter { item in
        //    item.category.categoryType == "Income"
        //}
        
        updateUI()
        
        filterCategories()
    }
    
    private func intitialSetup() {
        
        Constants.shared.setBackgroundGradient(for: view)
        cardBehind.layer.cornerRadius = 60
        cardFront.layer.cornerRadius = 60
        progressContainer.layer.cornerRadius = 6
        progressConstraint.constant = progress.frame.width
        monthlyBudget = settings.budget
        
    }
    
    private func loadItems() {
        let request = NSFetchRequest<Item>(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        // TODO: Add NSPredicate to filter out incomes.
        
        fetchControllerItems = NSFetchedResultsController(fetchRequest: request, managedObjectContext: PersistenceManager.persistentContainer.viewContext, sectionNameKeyPath: "date", cacheName: nil)
        
        do {
            try fetchControllerItems.performFetch()
            
            for item in fetchControllerItems.fetchedObjects! {
                print(item.name)
                print(item.category.categoryType)
            }
            
        } catch let err {
            print(err.localizedDescription)
        }
        
        tableView.reloadData()
    }
    
    private func filterCategories() {
        categories = []
        
        var categoryExpenses = ["Income" : 0.0, "Entertainment" : 0.0, "Education" : 0.0, "Shopping" : 0.0, "Personal Care" : 0.0,
                                "Health & Fitness" : 0.0, "Kids" : 0.0, "Food & Dining" : 0.0, "Gifts & Donations" : 0.0,
                                "Investments" : 0.0, "Bills & Utilities" : 0.0, "Transport" : 0.0, "Travel" : 0.0,
                                "Fees & Charges" : 0.0, "Business Services" : 0.0]
        
        for item in fetchControllerItems.fetchedObjects! {
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
        
        for item in fetchControllerItems.fetchedObjects! {
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
        
        for item in fetchControllerItems.fetchedObjects! {
            if item.category.categoryType == category.category {
                total += 1
            }
        }
        
        return total
    }
    
    private func updateUI() {
        totalExpensesLabel.text = "\(settings.currencyIcon) \(calculateTotalExpenses())"
        progressConstraint.constant = calculateProgressbar()
        
        let remainingBudget = settings.budget - calculateTotalExpenses()
        monthlyBudgetLabel.text = "\(settings.currencyIcon) \(remainingBudget) remaining"
        
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
            return categories.count
        } else {
            return fetchControllerItems.fetchedObjects?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as! ExpenseCell
        
        if expensesSelected {
            let category = categories[indexPath.row]
            cell.configureCell(image: UIImage(named: "restaurant")!, category: category.category, budgetAmount: "\(calculateBudgetPercentage(totalAmount: settings.budget, categoryAmount: category.amount))% of budget", moneyLabel: "\(settings.currencyIcon) \(category.amount)", transactions: "\(calculateTransactions(for: category)) transactions")
        } else {
            let item = fetchControllerItems.fetchedObjects![indexPath.row]
            cell.configureCell(image: UIImage(named: "restaurant")!, category: item.category.name, budgetAmount: "", moneyLabel: "\(settings.currencyIcon) \(item.amount)", transactions: "")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
