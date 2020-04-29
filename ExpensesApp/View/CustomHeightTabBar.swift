//
//  CustomHeightTabBar.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 29/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

class CustomHeightTabBar : UITabBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let defaultSizeWidth = self.frame.width
        
        if UIDevice.current.hasNotch {
            print("Got the notch")
            return CGSize(width: defaultSizeWidth, height: 100)
        } else {
            print("No notch")
            return CGSize(width: defaultSizeWidth, height: 60)
        }
        
    }
}


extension UIDevice {
    var hasNotch: Bool {
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        
        let bottom = keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
