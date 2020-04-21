//
//  Settings+CoreDataProperties.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 21/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var currency: String
    @NSManaged public var budget: Double
    @NSManaged public var theme: String

}
