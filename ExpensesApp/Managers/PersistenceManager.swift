//
//  PersistenceManager.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 17/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import Foundation
import CoreData

class PersistenceManager {
        
    static var persistentContainer: NSPersistentCloudKitContainer = {
        
        let container = NSPersistentCloudKitContainer(name: "ExpensesApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()

    // MARK: - Core Data Saving support

    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func fetchItems() -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        var items = [Item]()
        do {
            items = try PersistenceManager.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return items
    }
    
    static func fetchScore() -> Scorestreak? {
        #warning("Need to fix this. Use Fetched controller instead.")
        let fetchRequest: NSFetchRequest<Scorestreak> = Scorestreak.fetchRequest()
        var score: [Scorestreak] = []
        
        do {
            score = try persistentContainer.viewContext.fetch(fetchRequest)
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        guard let firstEntry = score.first else {return nil}
        return firstEntry
    }
}
