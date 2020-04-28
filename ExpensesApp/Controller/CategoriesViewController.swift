//
//  CategoriesViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 16/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController, AddCategoryDelegate {

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
        navigationController?.setNavigationBarHidden(true, animated: true)
        textField.addTarget(self, action: #selector(editedTextfield), for: .editingChanged)
        Constants.shared.setBackgroundGradient(for: view)
        searchContainer.layer.cornerRadius = 20
        loadCategories()
    }
    
    private func loadCategories() {
        FetchRequest.loadCategories()
        allCategories = FetchRequest.fetchControllerCategory.fetchedObjects!
        filteredCategories = FetchRequest.fetchControllerCategory.fetchedObjects!
        
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
        
        tableView.reloadData()
    }
    
    @IBAction func addCategoryTapped(_ sender: UIButton) {
        let addCategoryVC = storyboard?.instantiateViewController(identifier: "AddCategoryViewController") as! AddCategoryViewController
        addCategoryVC.delegate = self
        present(addCategoryVC, animated: true, completion: nil)
    }
    
    func didfinishAddingCategory(category: Category) {
        var index = 0
        
        for categoryType in categoryTypes {
            if category.categoryType == categoryType {
                allCategoryTypes[index].append(category)
                tableView.reloadData()
                return
            }
            index += 1
        }
    }
    
    @objc private func editedTextfield() {
        guard let searchText = textField.text else {return}
        
        isSearching = !searchText.isEmpty
        filteredCategories = allCategories.filter({ category in category.name.lowercased().contains(searchText)})
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
            if allCategoryTypes[section].isEmpty  {
                return nil
            } else {
                return categoryTypes[section]
            }
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = allCategoryTypes[indexPath.section][indexPath.row]
            PersistenceManager.persistentContainer.viewContext.delete(category)
            PersistenceManager.saveContext()
            
            allCategoryTypes[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
