//
//  CategoryType+CoreDataProperties.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 17/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//
//

import Foundation
import CoreData


extension CategoryType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryType> {
        return NSFetchRequest<CategoryType>(entityName: "CategoryType")
    }

    @NSManaged public var name: String?
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for categories
extension CategoryType {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
