//
//  StatisticsViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 17/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var totalIncomeContainer: UIView!
    @IBOutlet weak var totalExpensesContainer: UIView!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var income30DaysLabel: UILabel!
    @IBOutlet weak var totalExpensesLabel: UILabel!
    @IBOutlet weak var expenses30DaysLabel: UILabel!
    @IBOutlet weak var background: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.shared.setBackgroundGradient(for: view)
        totalIncomeContainer.layer.cornerRadius = 8
        totalExpensesContainer.layer.cornerRadius = 8
        background.layer.cornerRadius = 60
    }

}
