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
    @IBOutlet weak var monthlyBudget: UILabel!
    @IBOutlet weak var progressContainer: UIView!
    @IBOutlet weak var expensesBtn: UIButton!
    @IBOutlet weak var incomeBtn: UIButton!
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.shared.setBackgroundGradient(for: view)
        cardBehind.layer.cornerRadius = 60
        cardFront.layer.cornerRadius = 60
        progressContainer.layer.cornerRadius = 6
        
        fetchItems()
    }
    
    @IBAction func expensesBtnTapped(_ sender: UIButton) {
        print("Expenses tapped")
    }
    
    @IBAction func incomeBtnTapped(_ sender: UIButton) {
        print("Income tapped")
    }
    
    private func fetchItems() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            items = try PersistenceManager.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as! ExpenseCell
        cell.configureCell(image: UIImage(named: "restaurant")!, category: "Restaurants", budgetAmount: "45", moneyLabel: "800", transactions: "9")
        return cell
    }
}
