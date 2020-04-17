//
//  SceneDelegate.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 16/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var standardCategoryTypes = ["Income", "Entertainment", "Education", "Shopping", "Personal Care",
                           "Health & Fitness", "Kids", "Food & Dining", "Gifts & Donations",
                           "Investments", "Bills & Utilities", "Transport", "Travel",
                           "Fees & Charges", "Business Services"]
    
    let standardCategories = [
        ["Paycheck", "Investment", "Returned Purchase", "Bonus", "Interest Income", "Reimbursement", "Rental Income"],
        ["Arts", "Music", "Movies", "Newspaper & Magazines", "Games"],
        ["Tuition", "Student Load", "Books & Supplies"],
        ["Clothing", "Books", "Electronics & Software", "Hobbies", "Sporting Goods"],
        ["Laundry", "Hair", "Spa"],
        ["Dentist", "Doctor", "Eye care", "Pharmacy", "Health Insurance", "Gym", "Sports"],
        ["Activities", "Allowance", "Baby Supplies", "Babysitter & Daycare", "Child Support", "Toys"],
        ["Groceries", "Coffee shops", "Fast Food", "Restaurants", "Alcohol"],
        ["Gift", "Charity"],
        ["Deposit", "Withdrawal", "Dividends & Cap Gains", "Buy", "Sell"],
        ["Television", "Home Phone", "Internet", "Mobile Phone", "Utilities"],
        ["Gas & Fuel", "Parking", "Service & Auto Parts", "Auto Payment", "Auto Insurance"],
        ["Air Travel", "Hotel", "Rental Car & Taxi", "Vacation"],
        ["Service Fee", "Late Fee", "Finance Charge", "ATM Fee", "Bank Fee", "Commissions"],
        ["Advertising", "Office Supplies", "Printing", "Shipping", "Legal"]
    ]

    private func saveStandardCategories() {
        if checkIfFirstBoot() {
            for categoryType in standardCategoryTypes {
                let categoryTypeEntity = CategoryType(context: PersistenceManager.persistentContainer.viewContext)
                categoryTypeEntity.name = categoryType
                PersistenceManager.saveContext()
                firstBoot()
            }
        }
    }
    
    private func firstBoot() {
        let firstBoot = FirstBoot(context: PersistenceManager.persistentContainer.viewContext)
        firstBoot.firstBoot = false
        PersistenceManager.saveContext()
    }
    
    private func checkIfFirstBoot() -> Bool {
        let fetchRequest: NSFetchRequest<FirstBoot> = FirstBoot.fetchRequest()
        var firstBoots = [FirstBoot]()
        
        do {
            firstBoots = try PersistenceManager.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        if let _ = firstBoots.first?.objectID {
            print("First time booting the app")
            return false
        }
        print("Not the first time booting the app")
        return true
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        saveStandardCategories()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

