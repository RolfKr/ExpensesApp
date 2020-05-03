//
//  ExpensesDetailViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 02/05/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

class ExpensesDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCategory: String!
    var filteredItems = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterCategories()
    }

    
    private func filterCategories() {
        guard let items = FetchRequest.fetchControllerItems.fetchedObjects else {return}
        
        filteredItems = items.filter({ (item) -> Bool in
            item.category.categoryType == selectedCategory
        })
        tableView.reloadData()
        
        for item in filteredItems {
            print(item.category.name)
        }
    }
}

extension ExpensesDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ExpenseDetailCell
        let item = filteredItems[indexPath.row]
        cell.configureCell(image: UIImage(named: item.category.name)!, name: item.name, amount: String(item.amount))
        return cell
    }
}
