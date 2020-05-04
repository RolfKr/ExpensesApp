//
//  AddCategoryViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 17/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import CoreData

protocol AddCategoryDelegate {
    func didfinishAddingCategory(category: Category)
}

class AddCategoryViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    
    var selectedIcon: String!
    var selectedType = "Income"
    var delegate: AddCategoryDelegate!
    
    var icons = ["Paycheck", "Investment", "Returned Purchase", "Bonus", "Interest Income", "Reimbursement", "Rental Income", "Arts", "Music", "Movies", "Newspaper & Magazines", "Games", "Tuition", "Student Loan", "Books & Supplies", "Clothing", "Books", "Electronics & Software", "Hobbies", "Sporting Goods", "Laundry", "Hair", "Spa", "Dentist", "Doctor", "Eye care", "Pharmacy", "Health Insurance", "Gym", "Sports", "Activities", "Allowance", "Baby Supplies", "Babysitter & Daycare", "Child Support", "Toys", "Groceries", "Coffee shops", "Fast Food", "Restaurants", "Alcohol", "Gift", "Charity", "Deposit", "Withdrawal", "Buy", "Television", "Home Phone", "Internet", "Mobile Phone", "Utilities", "Gas & Fuel", "Parking", "Service & Auto Parts", "Auto Payment", "Auto Insurance", "Air Travel", "Hotel", "Rental Car & Taxi", "Vacation", "Service Fee", "ATM Fee", "Bank Fee", "Commissions", "Advertising", "Office Supplies", "Printing", "Shipping", "Legal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let placeholderColor = UIColor.init(white: 1, alpha: 0.5)
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter name here".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])

        collectionView.layer.cornerRadius = 25
    }
    
    @objc private func hideKeyboard() {
        nameTextField.resignFirstResponder()
    }
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {return}
        createCategory(name: name, type: selectedType, icon: selectedIcon)
        dismiss(animated: true, completion: nil)
    }
    
    private func createCategory(name: String, type: String, icon: String) {
        let categoryEntity = Category(context: PersistenceManager.persistentContainer.viewContext)
        categoryEntity.name = name
        categoryEntity.items = []
        categoryEntity.categoryType = type
        categoryEntity.icon = selectedIcon
        PersistenceManager.saveContext()
        
        delegate.didfinishAddingCategory(category: categoryEntity)
    }

}

extension AddCategoryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.categoryTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let type = Constants.categoryTypes[row]
        return NSAttributedString(string: type, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = Constants.categoryTypes[row]
    }
}

extension AddCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AddCategoryCell
        cell.configureCell(image: UIImage(named: icons[indexPath.row])!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIcon = icons[indexPath.row]
    }
    
}

extension AddCategoryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
    }
}


