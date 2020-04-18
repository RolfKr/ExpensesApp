//
//  CategoryCollectionCell.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 17/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    
    func configureCell(image: UIImage, name: String) {
        categoryImage.image = image
        categoryName.text = name
        categoryName.layer.cornerRadius = 16
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                categoryName.backgroundColor = UIColor(red: 19/255, green: 156/255, blue: 205/255, alpha: 0.5)
                categoryName.textColor = .white
                
            }
            else
            {
                categoryName.backgroundColor = UIColor.clear
                categoryName.textColor = UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 0.75)
            }
        }
    }
    
}



