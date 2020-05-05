//
//  StatisticsViewController.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 17/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import Charts
import CoreData


class StatisticsViewController: UIViewController {

    @IBOutlet weak var totalIncomeContainer: UIView!
    @IBOutlet weak var totalExpensesContainer: UIView!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var totalExpensesLabel: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var dataAvailableLabel: UILabel!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var mostExpenseCategoryLabel: UILabel!
    
    var items = [Item]()
    var allItems = [Item]() {
        didSet {
            dataAvailableLabel.text = "No data available. Add some new expenses first.".localized()
            dataAvailableLabel.isHidden = !allItems.isEmpty
        }
    }
    
    var savingTips = ["Tips number 1: Create a budget and follow it!".localized(),
        "Calculate how much a product will cost you in the amount of workhours. The probability of you buying the product is lowered when you see how many workhours it wil cost.".localized(),
        "Always pay in the local currency when you are traveling.".localized(),
        "Create a buffer account that contains a minimum of 3 months pay, in case of a rainy day.".localized(),
        "Create a savingsaccount that deducts a set amount of money on payday. By doing this you wont notice that you are saving.".localized()]
    
    var mostExpensiveCategory: String! {
        didSet {
            guard let categoryText = mostExpensiveCategory else {return}
            if categoryText == "" {
                mostExpenseCategoryLabel.text = savingTips.randomElement()
            } else {
                mostExpenseCategoryLabel.text = "\(categoryText) " +  "is your most expensive category.\n Try to reduce the cost of this category next month.".localized()
            }
        }
    }
    
    var settings: Settings!
    var totalExpenses = 0.0
    var totalIncome = 0.0
    var chartDataEntries: [ChartDataEntry]!
    var selectedYear = 2020
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"].map {$0.localized()}
    var datePicker = UIDatePicker()
    let toolBar = UIToolbar()
    
    override func viewDidAppear(_ animated: Bool) {
        chartDataEntries = []
        initialSetup()
        loadData()
        calculate()
        createChart()
    }
    
    private func initialSetup() {
        expensesLabel.text = "Expenses for ".localized() + String(selectedYear)
        totalIncomeContainer.layer.cornerRadius = 8
        totalExpensesContainer.layer.cornerRadius = 8
    }
    
    private func loadData(){
        FetchRequest.loadItems()
        allItems = FetchRequest.fetchControllerItems.fetchedObjects!
        items = FetchRequest.fetchControllerItems.fetchedObjects!.filter({ item in checkForCurrentMonth(date: item.date)})
        mostExpensiveCategory = ReferenceBuget.compareWithBudget(with: items)
    }
    
    @IBAction func changeBtnTapped(_ sender: UIButton) {
        createDatePickerView(changeButton: sender)
    }
    
    private func createDatePickerView(changeButton: UIView) {
        let width = view.frame.width * 0.8
        let height = view.frame.height * 0.3
        let startFrame = CGRect(x: view.frame.midX + width, y: view.frame.midY - (height/2), width: width, height: height)
        let endFrame = CGRect(x: view.frame.midX - (width/2), y: view.frame.midY - (height/2), width: width, height: height)
        let containerView = UIView(frame: startFrame)
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50),
            datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            datePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            containerView.frame = endFrame
            containerView.layoutIfNeeded()
        }, completion: nil)
    }

    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none

        datePicker.isHidden = true
        self.toolBar.isHidden = true
    }

    @objc func cancelClick() {
        datePicker.isHidden = true
        self.toolBar.isHidden = true
    }
    
    //MARK: Creates chart.
    private func createChart() {
        setChartData()
        getDataPoints()
        setChartData()
    }
    
    // MARK: Draws each point in chart, based on datapoints.
    private func setChartData() {
        let set1 = LineChartDataSet(entries: chartDataEntries, label: "Expenses per month".localized())
        set1.drawCirclesEnabled = false
        set1.mode = .horizontalBezier
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
            
            for item in allItems {
                let dateComponent = calendar.dateComponents([.month, .year], from: item.date)
                guard let month = dateComponent.month else {continue}
                guard let year = dateComponent.year else {continue}
                                
                if index == (month - 1) && selectedYear == year {
                    totalAmountPerMonth += item.amount
                    let entry = ChartDataEntry(x: Double(month - 1), y: totalAmountPerMonth)
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
        guard let fetchedSettings = FetchRequest.fetchControllerSettings.fetchedObjects?.first else {return}
        settings = fetchedSettings
        
        totalExpensesLabel.text = "\(settings.currencyIcon) \(totalExpenses)"
        totalIncomeLabel.text = "\(settings.currencyIcon) \(totalIncome)"

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
