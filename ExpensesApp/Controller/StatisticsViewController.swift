//
//  StatisticsViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 17/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController {

    @IBOutlet weak var totalIncomeContainer: UIView!
    @IBOutlet weak var totalExpensesContainer: UIView!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var totalExpensesLabel: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var chart: LineChartView!
    
    var items = [Item]()
    var totalExpenses = 0.0
    var totalIncome = 0.0
    var chartDataEntries: [ChartDataEntry] = []
    var selectedYear = 2020
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    override func viewDidAppear(_ animated: Bool) {
        initialSetup()
        calculate()
        createChart()
    }
    
    private func initialSetup() {
        Constants.shared.setBackgroundGradient(for: view)
        totalIncomeContainer.layer.cornerRadius = 8
        totalExpensesContainer.layer.cornerRadius = 8
        background.layer.cornerRadius = 60
        items = PersistenceManager.fetchItems()
        items = items.filter({ item in checkForCurrentMonth(date: item.date)})
    }
    
    //MARK: Creates chart.
    private func createChart() {
        chart.animate(xAxisDuration: 0.5)
        setChartData()
        getDataPoints()
        setChartData()
    }
    
    // MARK: Draws each point in chart, based on datapoints.
    private func setChartData() {
        let set1 = LineChartDataSet(entries: chartDataEntries, label: "Expenses per month")
        set1.drawCirclesEnabled = false
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.setColors(.systemTeal)
        set1.fill = Fill(color: .systemTeal)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true

        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        chart.data = data
        
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        chart.xAxis.granularity = 1
    }
    
    // MARK: Calculates datapoints for chart. Uses items array fetched from coredata
    private func getDataPoints() {
        let calendar = Calendar.current
        
        for (index, _) in months.enumerated() {
            var totalAmountPerMonth = 0.0
            
            for item in items {
                let dateComponent = calendar.dateComponents([.month, .year], from: item.date)
                guard let month = dateComponent.month else {continue}
                guard let year = dateComponent.year else {continue}
                
                if index == month && selectedYear == year {
                    totalAmountPerMonth += item.amount
                    let entry = ChartDataEntry(x: Double(month), y: totalAmountPerMonth)
                    chartDataEntries.append(entry)
                }
            }
        }
    }
    
    // MARK: Checks item in items array if item is for current month
    private func checkForCurrentMonth(date: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
        let compOne = calendar.dateComponents([.month, .year], from: now)
        let compTwo = calendar.dateComponents([.month, .year], from: date)
        
        if compOne == compTwo {
            return true
        } else {
            return false
        }
    }
    
    private func updateUI() {
        totalExpensesLabel.text = "$\(totalExpenses)"
        totalIncomeLabel.text = "$\(totalIncome)"
    }
    
    //MARK: Calculates total expenses and income for current month.
    private func calculate() {
        totalIncome = 0.0
        totalExpenses = 0.0
        
        for item in items {
            if item.category.categoryType == "Income" {
                totalIncome += item.amount
            } else {
                totalExpenses += item.amount
            }
        }
        
        updateUI()
    }

}
