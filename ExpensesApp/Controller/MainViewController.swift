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
    var itemsFilteredOnIncome = [Item]()
    var items: [Item]! {
        didSet {
            updateUI()
        }
    }

    var fetchControllerSettings: NSFetchedResultsController<Settings>! {
        didSet {
            let currencyIcon = fetchControllerSettings.fetchedObjects?.first?.currencyIcon ?? "$"
            let budget = fetchControllerSettings.fetchedObjects?.first?.budget ?? 1000
            monthlyBudgetLabel.text = "\(currencyIcon) \(budget) \("budgetRemaining".localized())"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        loadItems()
        loadSettings()
        progressConstraint.constant = progress.frame.width
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        intitialSetup()
        filterCategories()
    }
    
    private func intitialSetup() {
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
        var categoryExpenses = Constants.categoryExpenses
              
        items = FetchRequest.fetchControllerItems.fetchedObjects!.filter({ item in
            let calendar = Calendar.current
            let selectedMonth = calendar.dateComponents([.month, .year], from: self.selectedMonth)
            let itemMonth = calendar.dateComponents([.month, .year], from: item.date)
            return selectedMonth == itemMonth
        }).filter({ $0.category.categoryType != "Income".localized() })
        
        for item in items {
            var currentAmount = categoryExpenses[item.category.categoryType]!
            currentAmount += item.amount
            categoryExpenses[item.category.categoryType] = currentAmount
        }
        
        for categoryExpense in categoryExpenses where categoryExpense.value != 0.0 {

                let category = ExpenseCategory(category: categoryExpense.key, amount: categoryExpense.value)
                self.categories.append(category)
            
        }
        
        
        tableView.reloadData()
    }

    
    @IBAction func expensesBtnTapped(_ sender: UIButton) {
        expensesSelected = true
        tableView.reloadData()
    }
    
    @IBAction func incomeBtnTapped(_ sender: UIButton) {
        expensesSelected = false
        itemsFilteredOnIncome = FetchRequest.fetchControllerItems.fetchedObjects!.filter({ $0.category.categoryType == "Income".localized() })
        tableView.reloadData()
    }
    
    @IBAction func nextMonthBtntapped(_ sender: UIButton) {
        var dateComponent = DateComponents()
        dateComponent.month = 1
        selectedMonth = Calendar.current.date(byAdding: dateComponent, to: selectedMonth)!
        filterCategories()
        updateUI()
        
        print(selectedMonth)
    }
    
    @IBAction func previousMonthBtntapped(_ sender: UIButton) {
        var dateComponent = DateComponents()
        dateComponent.month = -1
        selectedMonth = Calendar.current.date(byAdding: dateComponent, to: selectedMonth)!
        filterCategories()
        updateUI()
        
        print(selectedMonth)
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
        let currencyIcon = FetchRequest.fetchControllerSettings.fetchedObjects?.first?.currencyIcon ?? "$"
        let budget = FetchRequest.fetchControllerSettings.fetchedObjects?.first?.budget ?? 1000
        
        totalExpensesLabel.text = "\(currencyIcon) \(calculateTotalExpenses())"
        progressConstraint.constant = calculateProgressbar()
        
        let remainingBudget = budget - calculateTotalExpenses()
        monthlyBudgetLabel.text = "\(currencyIcon) \(remainingBudget) \("budgetRemaining".localized())"
        
        let months = ["January".localized(), "Feburary".localized(), "March".localized(), "April".localized(), "May".localized(), "June".localized(), "July".localized(), "August".localized(), "September".localized(), "Oktober".localized(), "November".localized(), "December".localized()]
        
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
            print("categoriesCount: \(categories.count)")
            return categories.count
        } else {
            return itemsFilteredOnIncome.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as! ExpenseCell
        let budget = FetchRequest.fetchControllerSettings.fetchedObjects?.first?.budget ?? 1000
        let currencyIcon = FetchRequest.fetchControllerSettings.fetchedObjects?.first?.currencyIcon ?? "$"
        
        if expensesSelected {
            let category = categories[indexPath.row]
            cell.configureCell(image: UIImage(named: category.category)!, category: category.category, budgetAmount: "\(calculateBudgetPercentage(totalAmount: budget, categoryAmount: category.amount))"  + "% of budget".localized(), moneyLabel: "\(currencyIcon) \(category.amount)", transactions: "\(calculateTransactions(for: category)) " + "transactions".localized())
        } else {
            let item = itemsFilteredOnIncome[indexPath.row]
            print(item)
            cell.configureCell(image: UIImage(named: item.category.icon) ?? UIImage(named: "restaurant")!, category: item.name, budgetAmount: item.category.name, moneyLabel: "\(currencyIcon) \(item.amount)", transactions: "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !expensesSelected
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let item = itemsFilteredOnIncome[indexPath.row]
            PersistenceManager.persistentContainer.viewContext.delete(item)
            PersistenceManager.saveContext()

            itemsFilteredOnIncome.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if expensesSelected {
            let selectedCategory = categories[indexPath.row].category
            let expensesDetailVC = storyboard?.instantiateViewController(identifier: "expensesDetailVC") as! ExpensesDetailViewController
            expensesDetailVC.selectedCategory = selectedCategory
            present(expensesDetailVC, animated: true)
        }
    }
}
