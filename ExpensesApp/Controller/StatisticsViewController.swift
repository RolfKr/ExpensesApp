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
    
    var containerView = UIView()
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
    var datePicker = UIPickerView()
    var datePickerSelectedValue = 2020
    
    var years: [String] {
        var years = [String]()
        for index in 2000..<2051 {
            years.append(String(index))
        }
        return years
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initialSetup()
        setupChart()
    }
    
    private func setupChart() {
        chartDataEntries = []
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
        containerView = UIView(frame: startFrame)
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        datePicker.dataSource = self
        datePicker.delegate = self
        datePicker.selectRow(datePickerSelectedValue - 2000, inComponent:0, animated:true)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(datePicker)
        
        let dismissButton = UIButton(type: .custom)
        dismissButton.setTitle("Dismiss".localized(), for: .normal)
        dismissButton.backgroundColor = .red
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.layer.cornerRadius = 8
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.addTarget(self, action: #selector(dismissBtnTapped), for: .touchUpInside)
        containerView.addSubview(dismissButton)
        
        let selectButton = UIButton(type: .custom)
        selectButton.setTitle("Select".localized(), for: .normal)
        selectButton.backgroundColor = UIColor(named: "MainColor")
        selectButton.setTitleColor(.white, for: .normal)
        selectButton.layer.cornerRadius = 8
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.addTarget(self, action: #selector(selectBtnTapped), for: .touchUpInside)
        containerView.addSubview(selectButton)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            datePicker.bottomAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: -40),
            
            dismissButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50),
            dismissButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            dismissButton.widthAnchor.constraint(equalToConstant: 100),
            dismissButton.heightAnchor.constraint(equalToConstant: 30),
            
            selectButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50),
            selectButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            selectButton.widthAnchor.constraint(equalToConstant: 100),
            selectButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        containerView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            self.containerView.frame = endFrame
            self.containerView.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func dismissBtnTapped() {
        containerView.removeFromSuperview()
    }
    
    @objc private func selectBtnTapped() {
        containerView.removeFromSuperview()
        selectedYear = datePickerSelectedValue
        setupChart()
    }
    
    private func dismissPickerView(containerView: UIView) {
        containerView.removeFromSuperview()
    }
    
    //MARK: Creates chart.
    private func createChart() {
        getDataPoints()
        setChartData()
    }
    
    // MARK: Draws each point in chart, based on datapoints.
    private func setChartData() {
        let set1 = LineChartDataSet(entries: chartDataEntries, label: "Expenses per month".localized())
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

extension StatisticsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return years[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var title = UILabel()
        if let view = view { title = view as! UILabel }
        title.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        title.textColor = UIColor.label
        title.text =  years[row]
        title.textAlignment = .center
        
        return title
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        datePickerSelectedValue = Int(years[row])!
        print(datePickerSelectedValue)
    }
}
