//
//  ExpenseDetailCell.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 03/05/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

class ExpenseDetailCell: UITableViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(image: UIImage, name: String, amount: String) {
        categoryImage.image = image
        nameLabel.text = name
        amountLabel.text = amount
    }

}
