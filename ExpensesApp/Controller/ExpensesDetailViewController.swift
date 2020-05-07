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
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var swipeToDeleteLabel: UILabel! {
        didSet {
            swipeToDeleteLabel.text = "Swipe to delete".localized()
        }
    }
    
    
    var selectedCategory: String!
    var filteredItems = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterCategories()
        detailTitle.text = "Details".localized()
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
        print(item)
        print(item.category)
        print(item.category.icon)
        cell.configureCell(image: UIImage(named: item.category.icon)!, name: item.name, amount: String(item.amount))
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = filteredItems[indexPath.row]
            PersistenceManager.persistentContainer.viewContext.delete(item)
            
            filteredItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            PersistenceManager.saveContext()
        }
    }
}
