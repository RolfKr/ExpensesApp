//
//  Scorestreak+CoreDataProperties.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 20/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//
//

import Foundation
import CoreData


extension Scorestreak {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Scorestreak> {
        return NSFetchRequest<Scorestreak>(entityName: "Scorestreak")
    }

    @NSManaged public var score: Int16
    @NSManaged public var highscore: Int16
    @NSManaged public var date: Date

}
