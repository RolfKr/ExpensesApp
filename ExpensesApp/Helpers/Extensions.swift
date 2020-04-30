//
//  Extensions.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 01/05/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import Foundation

extension String {
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
}
