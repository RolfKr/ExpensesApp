//
//  Constants.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 16/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

struct Constants {
    
    static let shared = Constants()
    
    var categoryTypes = ["Income", "Entertainment", "Education", "Shopping", "Personal Care",
                                 "Health & Fitness", "Kids", "Food & Dining", "Gifts & Donations",
                                 "Investments", "Bills & Utilities", "Transport", "Travel",
                                 "Fees & Charges", "Business Services"]
    
    func setBackgroundGradient(for view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "DarkBlueGradient")!.cgColor, UIColor(named: "LightBlueGradient")!.cgColor]
        gradientLayer.locations = [0.2, 0.8]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
