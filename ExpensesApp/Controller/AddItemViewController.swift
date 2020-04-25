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
    @IBOutlet weak var currencyIcon: UILabel!
    
    
    var delegate: AddItemDelegate?
    
    var fetchControllerSettings: NSFetchedResultsController<Settings>!
    var fetchControllerCategory: NSFetchedResultsController<Category>!
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
        Constants.shared.setBackgroundGradient(for: view)
        background.layer.cornerRadius = 60
        filteredCategories = categories.filter { (category) -> Bool in
            category.categoryType != "Income"
        }
        
        let placeholderColor = UIColor.init(white: 1, alpha: 0.5)
        amountTextField.attributedPlaceholder = NSAttributedString(
            string: "0.00",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    }
    
    private func loadCategories() {
        let request = NSFetchRequest<Category>(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        fetchControllerCategory = NSFetchedResultsController(fetchRequest: request, managedObjectContext: PersistenceManager.persistentContainer.viewContext, sectionNameKeyPath: "categoryType", cacheName: nil)
        
        do {
            try fetchControllerCategory.performFetch()
            categories = fetchControllerCategory.fetchedObjects!
            filteredCategories = categories.filter {$0.categoryType != "Income"}
        } catch let err {
            print(err.localizedDescription)
        }
        
        collectionView.reloadData()
    }
    
    private func loadSettings() {
        let request = NSFetchRequest<Settings>(entityName: "Settings")
        let sortDescriptor = NSSortDescriptor(key: "budget", ascending: true)
        request.sortDescriptors = [sortDescriptor]
    
        fetchControllerSettings = NSFetchedResultsController(fetchRequest: request, managedObjectContext: PersistenceManager.persistentContainer.viewContext, sectionNameKeyPath: "budget", cacheName: nil)
        
        do {
            try fetchControllerSettings.performFetch()
        } catch let err {
            print(err.localizedDescription)
        }
        
        settings = fetchControllerSettings.fetchedObjects?.first
    }
    
    @IBAction func changeEntryTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "expense" {
            addingExpense.toggle()
            sender.setTitle("income", for: .normal)
            sender.setTitleColor(.green, for: .normal)
            filteredCategories = categories.filter { (category) -> Bool in
                category.categoryType == "Income"
            }
        } else {
            addingExpense.toggle()
            sender.setTitle("expense", for: .normal)
            sender.setTitleColor(.red, for: .normal)
            filteredCategories = categories.filter { (category) -> Bool in
                category.categoryType != "Income"
            }
        }
        
        collectionView.reloadData()
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
        
        addToScoreStreak()
    }
    
    private func getYesterdayDate() -> Date {
        let calender = Calendar.current
        guard let yesterday = calender.date(byAdding: .day, value: -1, to: Date()) else {return Date()}
        return yesterday
    }
    
    private func addToScoreStreak() {
        guard let scoreStreak = PersistenceManager.fetchScore() else {return}
        let calendar = Calendar.current
        
        let yesterday = calendar.dateComponents([.day, .month, .year], from: getYesterdayDate())
        let lastTimeAdded = calendar.dateComponents([.day, .month, .year], from: scoreStreak.date)
        
        if yesterday == lastTimeAdded {
            scoreStreak.setValue(scoreStreak.score + 1, forKey: "score")
            if scoreStreak.highscore < scoreStreak.score {
                scoreStreak.setValue(scoreStreak.highscore + 1, forKey: "highscore")
            }
        } else {
            scoreStreak.setValue(1, forKey: "score")
        }
        
        scoreStreak.date = Date()
        PersistenceManager.saveContext()
        
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
        cell.configureCell(image: UIImage(named: "restaurant")!, name: category.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
