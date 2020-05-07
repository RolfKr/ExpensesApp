//
//  CustomHeightTabBar.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 29/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

class CustomTabbar : UITabBar {
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        barTintColor = UIColor(named: "MainColor")
        tintColor = .white
        unselectedItemTintColor = UIColor(named: "TabbarTextColor")
    }
    
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let defaultSizeWidth = self.frame.width
        
        if UIScreen.main.bounds.height > 736 {
            return CGSize(width: defaultSizeWidth, height: 100)
        } else {
            return CGSize(width: defaultSizeWidth, height: 60)
        }

    }
}
