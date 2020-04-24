//
//  ExpenseCell.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 16/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var transactionsLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(image: UIImage, category: String, budgetAmount: String, moneyLabel: String, transactions: String) {
        categoryImage.image = image
        categoryName.text = category
        budgetLabel.text = "\(budgetAmount)% of budget"
        self.moneyLabel.text = "\(moneyLabel)"
        transactionsLabel.text = transactions
    }

}
