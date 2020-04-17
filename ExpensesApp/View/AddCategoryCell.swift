//
//  AddCategoryCell.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 17/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

class AddCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    
    func configureCell(image: UIImage) {
        icon.image = image
    }
}
