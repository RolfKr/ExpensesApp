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
    
    static var categoryTypes = ["Income".localized(), "Entertainment".localized(), "Education".localized(), "Shopping".localized(), "Personal Care".localized(), "Health & Fitness", "Kids".localized(), "Food & Dining".localized(), "Gifts & Donations".localized(), "Investments".localized(), "Bills & Utilities".localized(), "Transport".localized(), "Travel".localized(), "Fees & Charges".localized(), "Business Services".localized()]
    
    static var categoryExpenses = ["Income".localized() : 0.0, "Entertainment".localized() : 0.0, "Education".localized() : 0.0, "Shopping".localized() : 0.0, "Personal Care".localized() : 0.0, "Health & Fitness".localized() : 0.0, "Kids".localized() : 0.0, "Food & Dining".localized() : 0.0, "Gifts & Donations".localized() : 0.0, "Investments".localized() : 0.0, "Bills & Utilities".localized() : 0.0, "Transport".localized() : 0.0, "Travel".localized() : 0.0, "Fees & Charges".localized() : 0.0, "Business Services".localized() : 0.0]
    
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
