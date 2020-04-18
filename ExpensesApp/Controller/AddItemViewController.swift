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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    var delegate: AddItemDelegate?
    
    var addingExpense = true
    var categories: [Category] = {
        let fetchrequest: NSFetchRequest<Category> = Category.fetchRequest()
        var categories = [Category]()
        do {
            categories = try PersistenceManager.persistentContainer.viewContext.fetch(fetchrequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return categories
    }()
    
    var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.shared.setBackgroundGradient(for: view)
        background.layer.cornerRadius = 60
        print(categories.count)
        
        let placeholderColor = UIColor.init(white: 1, alpha: 0.5)
        amountTextField.attributedPlaceholder = NSAttributedString(
            string: "0.00",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    }
    
    @IBAction func changeEntryTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "expense" {
            addingExpense.toggle()
            sender.setTitle("income", for: .normal)
            sender.setTitleColor(.green, for: .normal)
        } else {
            addingExpense.toggle()
            sender.setTitle("expense", for: .normal)
            sender.setTitleColor(.red, for: .normal)
        }
    }
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
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
    
    private func createItem(name: String, amount: Double, category: Category, date: Date) {
        let itemEntity = Item(context: PersistenceManager.persistentContainer.viewContext)
        itemEntity.name = name
        itemEntity.amount = amount
        itemEntity.category = category
        itemEntity.date = date
        PersistenceManager.saveContext()
        
        print(itemEntity.category.name)
    }
    
}

extension AddItemViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionCell
        let category = categories[indexPath.row]
        cell.configureCell(image: UIImage(named: "restaurant")!, name: category.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        print(selectedCategory!.name)
    }
}


extension AddItemViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        
        return true
    }
}
