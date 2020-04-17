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
    var allCategoryTypes = [[Category]]()
    var allCategories = [Category]()
    var isSearching = false
    var filteredCategories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.addTarget(self, action: #selector(editedTextfield), for: .editingChanged)
        Constants.shared.setBackgroundGradient(for: view)
        searchContainer.layer.cornerRadius = 20
        fetchCategories()
        
    }
    
    @IBAction func addCategoryTapped(_ sender: UIButton) {
        print("Add button tapped")
    }
    
    private func fetchCategories() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
                
        do {
            allCategories = try PersistenceManager.persistentContainer.viewContext.fetch(fetchRequest)
            filteredCategories = allCategories
            
            for categoryType in categoryTypes {
                var categoryGroup: [Category] = []
                for category in allCategories {
                    if category.categoryType == categoryType {
                        categoryGroup.append(category)
                    } else{
                        continue
                    }
                }
                allCategoryTypes.append(categoryGroup)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc private func editedTextfield() {
        guard let searchText = textField.text else {return}
        isSearching = !searchText.isEmpty
        
        filteredCategories = allCategories.filter({ (category) -> Bool in
            category.name.contains(searchText)
        })
    
        tableView.reloadData()
    }
    
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1
        } else {
            return categoryTypes.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching {
            return "Search results"
        } else {
            return categoryTypes[section]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredCategories.count
        } else {
            return allCategoryTypes[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryCell
        
        if isSearching {
            let category = filteredCategories[indexPath.row]
            cell.configureCell(image: UIImage(data: category.icon)!, name: category.name)
        } else {
            let category = allCategoryTypes[indexPath.section][indexPath.item]
            cell.configureCell(image: UIImage(data: category.icon)!, name: category.name)
        }
        
        return cell
    }
}
