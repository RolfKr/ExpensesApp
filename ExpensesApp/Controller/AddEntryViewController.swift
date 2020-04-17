//
//  AddEntryViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 17/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    
    private var addingExpense = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.shared.setBackgroundGradient(for: view)
        background.layer.cornerRadius = 60
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
        createNewItem()
    }
    
    private func createNewItem() {
        guard let name = nameTextField.text, !name.isEmpty else {return}
        print(name)
    }
    
}

extension AddEntryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionCell
        cell.configureCell(image: UIImage(named: "restaurant")!, name: "Restaurant")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}
