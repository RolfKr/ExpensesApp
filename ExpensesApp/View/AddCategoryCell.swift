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
    @IBOutlet weak var background: UIView!
    
    
    func configureCell(image: UIImage) {
        icon.image = image
        background.layer.cornerRadius = 18
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                background.backgroundColor = UIColor(red: 19/255, green: 156/255, blue: 205/255, alpha: 0.25)
                
            }
            else
            {
                background.backgroundColor = UIColor.clear
            }
        }
    }
}
