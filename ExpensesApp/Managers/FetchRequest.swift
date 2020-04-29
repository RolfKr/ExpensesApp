//
//  FetchRequest.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 28/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import Foundation
import CoreData

class FetchRequest {
    
    static var fetchControllerItems: NSFetchedResultsController<Item>!
    static var fetchControllerSettings: NSFetchedResultsController<Settings>!
    static var fetchControllerCategory: NSFetchedResultsController<Category>!
    
    static var shared = FetchRequest()
    
    static func loadItems() {
        let request = NSFetchRequest<Item>(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        fetchControllerItems = NSFetchedResultsController(fetchRequest: request, managedObjectContext: PersistenceManager.persistentContainer.viewContext, sectionNameKeyPath: "date", cacheName: nil)
        
        do {
            try fetchControllerItems.performFetch()
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    static func loadCategories() {
        let request = NSFetchRequest<Category>(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        fetchControllerCategory = NSFetchedResultsController(fetchRequest: request, managedObjectContext: PersistenceManager.persistentContainer.viewContext, sectionNameKeyPath: "categoryType", cacheName: nil)
        
        do {
            try fetchControllerCategory.performFetch()
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    static func loadSettings() {
        let request = NSFetchRequest<Settings>(entityName: "Settings")
        let sortDescriptor = NSSortDescriptor(key: "budget", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        fetchControllerSettings = NSFetchedResultsController(fetchRequest: request, managedObjectContext: PersistenceManager.persistentContainer.viewContext, sectionNameKeyPath: "budget", cacheName: nil)
        
        do {
            try fetchControllerSettings.performFetch()
        } catch let err {
            print(err.localizedDescription)
        }
    }
}
