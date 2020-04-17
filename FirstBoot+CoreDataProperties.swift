//
//  FirstBoot+CoreDataProperties.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 17/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//
//

import Foundation
import CoreData


extension FirstBoot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FirstBoot> {
        return NSFetchRequest<FirstBoot>(entityName: "FirstBoot")
    }

    @NSManaged public var firstBoot: Bool

}
