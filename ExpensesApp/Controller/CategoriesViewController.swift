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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            let categories = try PersistenceManager.persistentContainer.viewContext.fetch(fetchRequest)
            
            for categoryType in categoryTypes {
                var categoryGroup: [Category] = []
                for category in categories {
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
    
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryTypes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categoryTypes[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCategoryTypes[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryCell
        //let category = categories[indexPath.item]
        let category = allCategoryTypes[indexPath.section][indexPath.item]
        cell.configureCell(image: UIImage(data: category.icon)!, name: category.name)
        
        return cell
    }
}


