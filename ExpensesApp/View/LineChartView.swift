//
//  LineChartView.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 18/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import Foundation
import Charts

class LineChart: LineChartView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        backgroundColor = UIColor(named: "ChartsViewColor")
        rightAxis.enabled = false
        let yAxix =  self.leftAxis
        yAxix.labelFont = .boldSystemFont(ofSize: 12)
        yAxix.setLabelCount(6, force: false)
        yAxix.labelTextColor = .label
        yAxix.axisLineColor = .white
        yAxix.labelPosition = .outsideChart
        
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .label
        xAxis.labelFont = .boldSystemFont(ofSize: 12)
        xAxis.axisLineColor = .systemBlue
    }
}
