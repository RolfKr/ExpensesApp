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
        
        
        let categoryTypes = ["Income".localized(), "Entertainment".localized(), "Education".localized(), "Shopping".localized(), "Personal Care".localized(), "Health & Fitness".localized(), "Kids".localized(), "Food & Dining".localized(), "Gifts & Donations".localized(), "Investments".localized(), "Bills & Utilities".localized(), "Transport".localized(), "Travel".localized(), "Fees & Charges".localized(), "Business Services".localized()]
        
        let income = ["Paycheck".localized(), "Investment".localized(), "Returned Purchase".localized(), "Bonus".localized(), "Interest Income".localized(), "Reimbursement".localized(), "Rental Income".localized()]
        let entertainment = ["Arts".localized(), "Music".localized(), "Movies".localized(), "Newspaper & Magazines".localized(), "Games".localized()]
        let education = ["Tuition".localized(), "Student Loan".localized(), "Books & Supplies".localized()]
        let shopping = ["Clothing".localized(), "Books".localized(), "Electronics & Software".localized(), "Hobbies".localized(), "Sporting Goods".localized()]
        let personalCare = ["Laundry".localized(), "Hair".localized(), "Spa".localized()]
        let healthFitness = ["Dentist".localized(), "Doctor".localized(), "Eye care".localized(), "Pharmacy".localized(), "Health Insurance".localized(), "Gym".localized(), "Sports".localized()]
        let kids = ["Activities".localized(), "Allowance".localized(), "Baby Supplies".localized(), "Babysitter & Daycare".localized(), "Child Support".localized(), "Toys".localized()]
        let foodDining = ["Groceries".localized(), "Coffee shops".localized(), "Fast Food".localized(), "Restaurants".localized(), "Alcohol".localized()]
        let giftDonations = ["Gift".localized(), "Charity".localized()]
        let investments = ["Deposit".localized(), "Withdrawal".localized(), "Buy".localized()]
        let billsUtilities = ["Television".localized(), "Home Phone".localized(), "Internet".localized(), "Mobile Phone".localized(), "Utilities".localized()]
        let transport = ["Gas & Fuel".localized(), "Parking".localized(), "Service & Auto Parts".localized(), "Auto Payment".localized(), "Auto Insurance".localized()]
        let travel = ["Air Travel".localized(), "Hotel".localized(), "Rental Car & Taxi".localized(), "Vacation".localized()]
        let feesCharges = ["Service Fee".localized(), "ATM Fee".localized(), "Bank Fee".localized(), "Commissions".localized()]
        let businessServices = ["Advertising".localized(), "Office Supplies".localized(), "Printing".localized(), "Shipping".localized(), "Legal".localized()]
        
        let categories = [income, entertainment, education, shopping, personalCare, healthFitness, kids, foodDining, giftDonations, investments, billsUtilities, transport, travel, feesCharges, businessServices]
        var index = 0
        
        for category in categories {
            for item in category {
                let categoryEntity = Category(context: PersistenceManager.persistentContainer.viewContext)
                categoryEntity.name = item
                categoryEntity.items = []
                categoryEntity.categoryType = categoryTypes[index]
                categoryEntity.icon = (UIImage(named: "restaurant")!.pngData()!)
            }
            index += 1
        }
        
        
        PersistenceManager.saveContext()
    }
    
}
