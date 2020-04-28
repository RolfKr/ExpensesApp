//
//  BudgetComparison.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 28/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import Foundation

struct ReferenceBuget {
    var foodAndDrinks = 3500.0
    var clothes = 770.0
    var personalCare = 580.0
    var entertainment = 3480.0
    var transport = 3300.0
    
    func compareWithBudget(with items: [Item]) {
        var dictionary: [String: Int]
        for item in items {
            switch item.categoryType {
                case "Entertainment":
                break
                case "Food":
                break
                default:
                break
            }
        }
    }
}
