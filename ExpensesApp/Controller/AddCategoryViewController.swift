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
    
    var selectedIcon = UIImage()
    var selectedType = "Income"
    var delegate: AddCategoryDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let placeholderColor = UIColor.init(white: 1, alpha: 0.5)
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter name here",
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
    
    private func createCategory(name: String, type: String, icon: UIImage) {
        let categoryEntity = Category(context: PersistenceManager.persistentContainer.viewContext)
        categoryEntity.name = name
        categoryEntity.items = []
        categoryEntity.categoryType = type
        categoryEntity.icon = icon.pngData()!
        PersistenceManager.saveContext()
        
        delegate.didfinishAddingCategory(category: categoryEntity)
    }

}

extension AddCategoryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.shared.categoryTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let type = Constants.shared.categoryTypes[row]
        return NSAttributedString(string: type, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = Constants.shared.categoryTypes[row]
    }
}

extension AddCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AddCategoryCell
        cell.configureCell(image: UIImage(named: "restaurant")!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIcon = UIImage(named: "restaurant")!
    }
    
}

extension AddCategoryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
    }
}


