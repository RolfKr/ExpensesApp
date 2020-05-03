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

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var expensesButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyIcon: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    
    var delegate: AddItemDelegate?
    var addingExpense = true
    var categories = [Category]()
    var filteredCategories = [Category]()
    var selectedCategory: Category?
    
    var settings: Settings! {
        didSet {
            currencyIcon.text = "\(settings.currencyIcon)"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCategories()
        loadSettings()
        expensesButton.contentHorizontalAlignment = .left
        Constants.shared.setBackgroundGradient(for: view)
        filteredCategories = categories.filter { (category) -> Bool in
            category.categoryType != "Income"
        }
        
        let placeholderColor = UIColor.init(white: 1, alpha: 0.5)
        amountTextField.attributedPlaceholder = NSAttributedString(
            string: "0.00",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    }
    
    private func loadCategories() {
        categories = FetchRequest.fetchControllerCategory.fetchedObjects!
        filteredCategories = categories.filter {$0.categoryType != "Income"}
        collectionView.reloadData()
    }
    
    private func loadSettings() {
        guard let fetchedSettings = FetchRequest.fetchControllerSettings.fetchedObjects?.first else {return}
        settings = fetchedSettings
    }
    
    @IBAction func changeEntryTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "expense".localized() {
            addingExpense.toggle()
            sender.setTitle("income".localized(), for: .normal)
            sender.setTitleColor(.green, for: .normal)
            sender.contentHorizontalAlignment = .left
            filteredCategories = categories.filter { (category) -> Bool in
                category.categoryType == "Income".localized()
            }
        } else {
            addingExpense.toggle()
            sender.setTitle("expense".localized(), for: .normal)
            sender.setTitleColor(.red, for: .normal)
            sender.contentHorizontalAlignment = .left
            filteredCategories = categories.filter { (category) -> Bool in
                category.categoryType != "Income".localized()
            }
        }
        
        collectionView.reloadData()
    }
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {return}
        guard let amount = amountTextField.text, !amount.isEmpty else {return}
        guard let amountDouble = Double(amount) else {return}
        guard let category = selectedCategory else {return}
        
        let timeNow = Date()
        createItem(name: name, amount: amountDouble, category: category, date: timeNow)
        
        nameTextField.text = ""
        amountTextField.text = ""
        
        nameTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
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

extension AddItemViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionCell
        let category = filteredCategories[indexPath.row]
        cell.configureCell(image: UIImage(named: category.icon)!, name: category.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(selectedCategory)
        selectedCategory = filteredCategories[indexPath.row]
    }
}


extension AddItemViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        
        return true
    }
}
