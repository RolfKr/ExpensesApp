//
//  CategoriesViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 16/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {

    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //https://www.mint.com/mint-categories
    var categoryTypes = Constants.shared.categoryTypes
    
    let categories = [
        ["Paycheck", "Investment", "Returned Purchase", "Bonus", "Interest Income", "Reimbursement", "Rental Income"],
        ["Arts", "Music", "Movies", "Newspaper & Magazines", "Games"],
        ["Tuition", "Student Load", "Books & Supplies"],
        ["Clothing", "Books", "Electronics & Software", "Hobbies", "Sporting Goods"],
        ["Laundry", "Hair", "Spa"],
        ["Dentist", "Doctor", "Eye care", "Pharmacy", "Health Insurance", "Gym", "Sports"],
        ["Activities", "Allowance", "Baby Supplies", "Babysitter & Daycare", "Child Support", "Toys"],
        ["Groceries", "Coffee shops", "Fast Food", "Restaurants", "Alcohol"],
        ["Gift", "Charity"],
        ["Deposit", "Withdrawal", "Dividends & Cap Gains", "Buy", "Sell"],
        ["Television", "Home Phone", "Internet", "Mobile Phone", "Utilities"],
        ["Gas & Fuel", "Parking", "Service & Auto Parts", "Auto Payment", "Auto Insurance"],
        ["Air Travel", "Hotel", "Rental Car & Taxi", "Vacation"],
        ["Service Fee", "Late Fee", "Finance Charge", "ATM Fee", "Bank Fee", "Commissions"],
        ["Advertising", "Office Supplies", "Printing", "Shipping", "Legal"]
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Constants.shared.setBackgroundGradient(for: view)
        searchContainer.layer.cornerRadius = 20
        
        
        
    }
    
    @IBAction func addCategoryTapped(_ sender: UIButton) {
        print("Add button tapped")
    }
    
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryTypes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categoryTypes[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryCell
        let category = categories[indexPath.section][indexPath.row]
        cell.configureCell(image: UIImage(named: "restaurant")!, name: category)
        return cell
    }
}
