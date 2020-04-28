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
    
    static func compareWithBudget(with items: [Item]) -> String {

        var categories = [ExpenseCategory]()
        
        var categoryExpenses = ["Income" : 0.0, "Entertainment" : 0.0, "Education" : 0.0, "Shopping" : 0.0, "Personal Care" : 0.0,
                                "Health & Fitness" : 0.0, "Kids" : 0.0, "Food & Dining" : 0.0, "Gifts & Donations" : 0.0,
                                "Investments" : 0.0, "Bills & Utilities" : 0.0, "Transport" : 0.0, "Travel" : 0.0,
                                "Fees & Charges" : 0.0, "Business Services" : 0.0]
                
        for item in items {
            var currentAmount = categoryExpenses[item.category.categoryType]!
            currentAmount += item.amount
            categoryExpenses[item.category.categoryType] = currentAmount
        }
        
        for categoryExpense in categoryExpenses where categoryExpense.value != 0.0 {
            if categoryExpense.key != "Income" {
                let category = ExpenseCategory(category: categoryExpense.key, amount: categoryExpense.value)
                categories.append(category)
            }
        }
        
        var amount = 0.0
        var mostExpensiveCategory = ""
        
        for category in categories {
            if category.amount > amount {
                amount = category.amount
                mostExpensiveCategory = category.category
            }
        }
        
        return mostExpensiveCategory
    }
}
