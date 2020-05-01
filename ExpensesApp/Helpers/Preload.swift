//
//  FirstBoot.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 17/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class Preload {
    
    static func preloadData() {
        
        let settingsEntity = Settings(context: PersistenceManager.persistentContainer.viewContext)
        settingsEntity.budget = 10_000
        settingsEntity.currency = "Dollar"
        settingsEntity.theme = "System"
        settingsEntity.currencyIcon = "$"
        
        
        let categoryTypes = ["Income", "Entertainment", "Education", "Shopping", "Personal Care", "Health & Fitness", "Kids", "Food & Dining", "Gifts & Donations", "Investments", "Bills & Utilities", "Transport", "Travel", "Fees & Charges", "Business Services"]
        
        let income = ["Paycheck", "Investment", "Returned Purchase", "Bonus", "Interest Income", "Reimbursement", "Rental Income"]
        let entertainment = ["Arts", "Music", "Movies", "Newspaper & Magazines", "Games"]
        let education = ["Tuition", "Student Loan", "Books & Supplies"]
        let shopping = ["Clothing", "Books", "Electronics & Software", "Hobbies", "Sporting Goods"]
        let personalCare = ["Laundry", "Hair", "Spa"]
        let healthFitness = ["Dentist", "Doctor", "Eye care", "Pharmacy", "Health Insurance", "Gym", "Sports"]
        let kids = ["Activities", "Allowance", "Baby Supplies", "Babysitter & Daycare", "Child Support", "Toys"]
        let foodDining = ["Groceries", "Coffee shops", "Fast Food", "Restaurants", "Alcohol"]
        let giftDonations = ["Gift", "Charity"]
        let investments = ["Deposit", "Withdrawal", "Buy"]
        let billsUtilities = ["Television", "Home Phone", "Internet", "Mobile Phone", "Utilities"]
        let transport = ["Gas & Fuel", "Parking", "Service & Auto Parts", "Auto Payment", "Auto Insurance"]
        let travel = ["Air Travel", "Hotel", "Rental Car & Taxi", "Vacation"]
        let feesCharges = ["Service Fee", "ATM Fee", "Bank Fee", "Commissions"]
        let businessServices = ["Advertising", "Office Supplies", "Printing", "Shipping", "Legal"]
        
        let categories = [income, entertainment, education, shopping, personalCare, healthFitness, kids, foodDining, giftDonations, investments, billsUtilities, transport, travel, feesCharges, businessServices]
        var index = 0
        
        for category in categories {
            for item in category {
                let categoryEntity = Category(context: PersistenceManager.persistentContainer.viewContext)
                categoryEntity.name = item.localized()
                categoryEntity.items = []
                categoryEntity.categoryType = categoryTypes[index].localized()
                categoryEntity.icon = item
            }
            index += 1
        }
        
        
        PersistenceManager.saveContext()
    }
    
}
