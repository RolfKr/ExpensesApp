//
//  AddEntryViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 17/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import CoreData

protocol AddItemDelegate {
    func didFinishAddingItem()
}

class AddItemViewController: UIViewController, SetTimeDelegate {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyIcon: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    
    var delegate: AddItemDelegate?
    var addingExpense = true
    var categoryTypes = Constants.categoryTypes
    var allCategoryTypes = [[Category]]()
    var allCategories = [Category]()
    var filteredCategories = [Category]()
    var isSearching = false
    var selectedCategory: Category?
    
    var selectedDate: Date?
    
    var settings: Settings! {
        didSet {
            currencyIcon.text = "\(settings.currencyIcon)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCategories()
        loadSettings()
        
        let placeholderColor = UIColor.init(white: 1, alpha: 0.5)
        amountTextField.attributedPlaceholder = NSAttributedString(
            string: "0.00",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
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
    
    private func loadSettings() {
        guard let fetchedSettings = FetchRequest.fetchControllerSettings.fetchedObjects?.first else {return}
        settings = fetchedSettings
    }
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {return}
        guard let amount = amountTextField.text, !amount.isEmpty else {return}
        guard let amountDouble = Double(amount) else {return}
        guard let category = selectedCategory else {return}
        
        createItem(name: name, amount: amountDouble, category: category, date: selectedDate ?? Date())
        delegate?.didFinishAddingItem()
        
        nameTextField.text = ""
        amountTextField.text = ""
        
        nameTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
        #warning("Show an error message when some of the fields are empty")
    }
    
    func didSelectTime(date: Date) {
        selectedDate = date
    }
    
    @IBAction func setTimeButtonTapped(_ sender: UIButton) {
        let setTimeVC = storyboard?.instantiateViewController(identifier: "SetTimeVC") as! SetTimeViewController
        setTimeVC.delegate = self
        present(setTimeVC, animated: true)
    }
    
    
    private func getYesterdayDate() -> Date {
        let calender = Calendar.current
        guard let yesterday = calender.date(byAdding: .day, value: -1, to: Date()) else {return Date()}
        return yesterday
    }
    
    private func createItem(name: String, amount: Double, category: Category, date: Date) {
        let itemEntity = Item(context: PersistenceManager.persistentContainer.viewContext)
        itemEntity.name = name
        itemEntity.amount = amount
        itemEntity.category = category
        itemEntity.date = date
        PersistenceManager.saveContext()
    }
    
}

extension AddItemViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor(named: "SecondaryColor")
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryCell
        
        if isSearching {
            let category = filteredCategories[indexPath.row]
            cell.configureCell(image: UIImage(named: category.icon)!, name: category.name)
        } else {
            let category = allCategoryTypes[indexPath.section][indexPath.item]
            cell.configureCell(image: UIImage(named: category.icon)!, name: category.name)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            let category = filteredCategories[indexPath.row]
            selectedCategory = category
        } else {
            let category = allCategoryTypes[indexPath.section][indexPath.item]
            selectedCategory = category
        }
    }
}
