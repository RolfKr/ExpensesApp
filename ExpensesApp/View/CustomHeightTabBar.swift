//
//  CustomHeightTabBar.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 29/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

class CustomHeightTabBar : UITabBar {
    @IBInspectable var height: CGFloat = 0.0

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 150, height: 60)
    }
}
